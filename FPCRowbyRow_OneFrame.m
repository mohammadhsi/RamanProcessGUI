% Fixed Pattern Correction

%  based upon Sadia's script "FPCRowbyRow_.metaframes"
%    The goal of this was to apply fixed pattern correction to the zero-mm
%    data and then add back the non-photon counts -- because the
%    expectation was that the corrected data would then be sent as "raw"
%    data to be treated.

%  ajb modification 2025.10.27:
%    Our goal now is simply to average all of the white light frames to
%    make a single frame with high SNR (fixed-pattern limited rather than
%    shot noise limited) so that fixed pattern can be corrected. The
%    correction factor is then applied to the biological data. Note that
%    the biological specimen's measurement time is independent of the fixed
%    pattern data.
%    
%    There is no longer any need to re-add the non-photon counts
%    afterwards. We simply move on to the next step, which will be
%    aberration correction.


% clc
clear
close all

%% === 0) FILE PATHS (EDIT AS NEEDED) ===

AJBPrefix = 'C:\Users\ajber\Box\research';

% white light and darkPath, 25 (or in one case 75) frames of 9 sec
% data from 2025.03.05 
WLdata25APath = [AJBPrefix,'\BergerLabBoneProject\Data\Sadia\05March2025\WL_25F_9s.mat'];
WLdata25BPath = [AJBPrefix,'\BergerLabBoneProject\Data\Sadia\05March2025\WL_25F_9s_P2.mat'];
WLdata75Path  = [AJBPrefix,'\BergerLabBoneProject\Data\Sadia\05March2025\WL_75F_9s.mat'];

% darkPath      = [AJBPrefix, '\BergerLabBoneProject\Data\Sadia\05March2025\DS_25F_9s.mat'];

% Dark frames for WL – now using three dark files
DSdata25APath = [AJBPrefix, '\BergerLabBoneProject\Data\Sadia\2025-03-24\DS_25F_9s.mat'];
DSdata25BPath = [AJBPrefix, '\BergerLabBoneProject\Data\Sadia\2025-03-24\DS_25F_9s_P2.mat'];
DSdata75Path  = [AJBPrefix, '\BergerLabBoneProject\Data\Sadia\2025-03-24\DS_75F_9s.mat'];

% cadaver measurement and corresponding DarkPath - data from 2024.05.15
% measDataPath  = [AJBPrefix,'\BergerLabBoneProject\Data\Cadaver\1st_14\2024_05_15\MD24021688_T_D2P2_MM00.mat'];
% measDarkPath  = [AJBPrefix,'\BergerLabBoneProject\Data\Cadaver\1st_14\2024_05_15\darkspec.mat'];

% another bio measurement, taken from 2025.03.24 (same day as when the
% WL was taken) -- this is an exposed femur
% measDataPath  = [AJBPrefix,'\BergerLabBoneProject\Data\Cadaver\2nd_14\2025_03_24\MD240419105_F_I.mat'];
% measDarkPath  = [AJBPrefix,'\BergerLabBoneProject\Data\Cadaver\2nd_14\2025_03_24\darkspec.mat'];

% data from 2025.04.09 [closest cadaver to the WL data; I assume it's intact] 
measDataPath = [AJBPrefix,'\BergerLabBoneProject\Data\Cadaver\2nd_14\2025_04_09\MD24041998_T_D2P1_MM00.mat'];
measDarkPath = [AJBPrefix,'\BergerLabBoneProject\Data\Cadaver\2nd_14\2025_04_09\darkspec.mat'];



% Rows to correct (0mm region)
% rows0 = 70:92; % original "tight" guess
rows0 = 60:110; % better sense of the values above and below the 0 mm region

ZerommOnly = 74:96;  % values associated with the 0 mm region only (for summing)

%% LOAD & AVERAGE THE 9s DARK FOR BASELINE OFFSET ===
% darkStruct = load(darkPath);
% rawDark   = double(darkStruct.RawData.Spectrum);   % e.g. (6400 x 1024) => 25 frames

numRows = 256; 
numCols = 1024;

% 1B) Load dark for WL from three DS files, reshape and average to obtain a baseline offset
dsStruct25A = load(DSdata25APath);
dsStruct25B = load(DSdata25BPath);
dsStruct75  = load(DSdata75Path);

rawDS_25A = double(dsStruct25A.RawData.Spectrum);
rawDS_25B = double(dsStruct25B.RawData.Spectrum);
rawDS_75  = double(dsStruct75.RawData.Spectrum);

Z_ds25A = reshape(rawDS_25A.', [numCols, numRows, 25]);
Z_ds25A = permute(Z_ds25A, [2,1,3]);  % (256 x 1024 x 25)

Z_ds25B = reshape(rawDS_25B.', [numCols, numRows, 25]);
Z_ds25B = permute(Z_ds25B, [2,1,3]);

Z_ds75 = reshape(rawDS_75.', [numCols, numRows, 75]);
Z_ds75 = permute(Z_ds75, [2,1,3]);

% Combine all dark frames from DS files: (256 x 1024 x 125)
Z_dsAll = cat(3, Z_ds25A, Z_ds25B, Z_ds75);

% Average them to get the dark offset for WL
darkWLAvg = mean(Z_dsAll, 3);  % (256 x 1024)

%% LOAD & MERGE PARTIAL WHITELAMP => 125 FRAMES (256x1024x125)
wlStruct25A = load(WLdata25APath);
wlStruct25B = load(WLdata25BPath);
wlStruct75  = load(WLdata75Path);

rawWL_25A = double(wlStruct25A.RawData.Spectrum);  % => (6400 x 1024)
rawWL_25B = double(wlStruct25B.RawData.Spectrum);  % => (6400 x 1024)
rawWL_75  = double(wlStruct75.RawData.Spectrum);   % => (19200 x 1024)

Z_wl25A = reshape(rawWL_25A.', [numCols, numRows, 25]);
Z_wl25A = permute(Z_wl25A, [2,1,3]);  % => (256 x 1024 x 25)

Z_wl25B = reshape(rawWL_25B.', [numCols, numRows, 25]);
Z_wl25B = permute(Z_wl25B, [2,1,3]);  

Z_wl75  = reshape(rawWL_75.',  [numCols, numRows, 75]);
Z_wl75  = permute(Z_wl75, [2,1,3]);

Z_wlAll = cat(3, Z_wl25A, Z_wl25B, Z_wl75);  % => (256 x 1024 x 125)

% Subtract the dark offset from each WL frame
for f = 1:size(Z_wlAll,3)
    Z_wlAll(:,:,f) = Z_wlAll(:,:,f) - darkWLAvg;
end

%  AJB: average to get a single white-light frame
Z_OneFrame = mean(Z_wlAll,3);

%% FORM 5 META-FRAMES (25 frames each) => (256 x 1024 x 5)
numFramesAll  = 125;
groupSize     = 25;
numMetaFrames = 5;

Z_wlMeta = zeros(numRows, numCols, numMetaFrames);

for m = 1:numMetaFrames
    frameStart = (m-1)*groupSize + 1;
    frameEnd   = m*groupSize;
    % Summation in each meta-frame
    Z_wlMeta(:,:,m) = sum(Z_wlAll(:,:,frameStart:frameEnd), 3);
end

%% PLOT WL HF RIPPLE ACROSS THE 5 META-FRAMES
%  We'll pick a testRow in rows0 (e.g. 80) and compare "row / smooth(row) - 1"
%  across all 5 meta-frames (Z_wlMeta(:,:,1..5)).



testRow          = 85;            % pick any row in rows0
localSmoothWin   = 50;            % smoothing for HF extraction
offsetIncrement  = 0.05;          % vertical offset 
colors           = lines(numMetaFrames);

figure('Name','WL HF Ripple for 5 Meta-Frames','Color','w');
hold on;

for f = 1:numMetaFrames
    % Extract the row from meta-frame f
    wlRow = Z_wlMeta(testRow, :, f);

    % Smooth & compute ratio => row / smooth(row) ~ 1 => HF = ratio - 1
    wlSm   = smooth(wlRow, localSmoothWin).';  % ensure a 1x1024 row
    ratio  = wlRow ./ wlSm;                    % ~1 => small ripple
    % ajb 2025.11.14 : note that here Sadia is calculating 
    %       ratio = wlRow ./ wlSm
    % i.e. the raw data DIVIDED by wlSm
    %     this is the opposite convention of what I am defining in the next
    %     section

    % Offset each frame's trace so we can see all 5 lines
    yOffset = offsetIncrement * (f-1);
    plot((ratio - 1) + yOffset, 'LineWidth',1, 'Color',colors(f,:), ...
         'DisplayName', sprintf('Meta-frame %d', f));
end

xlabel('Pixel index');
ylabel('HF ripple (ratio - 1) + offset');
title(sprintf('WL HF Ripple: row %d across 5 meta-frames', testRow));
legend('Location','bestoutside');
axis tight;

%% BUILD 3D CORRECTION FACTOR (CF), ONLY rows0 => (256x1024x5)

% keep this the same as previous segment
% smoothWindow = 80;  
smoothWindow = 50;

CF_3D = ones(numRows, numCols, numMetaFrames);  % default is all 1's

% AJB: I choose to define the multiplicative correction factor as 
%         CF = wlRowSmooth / wlRow
%      and the corresponding corrected sample measurement is defined as
%         CorrectedSample = RawSample * (wlRowSmooth/wlRow)
%                         = RawSample * CF

for f = 1:numMetaFrames
    for rr = rows0
        wlRow = Z_wlMeta(rr,:,f);
        wlRowSmooth = smooth(wlRow, smoothWindow).';
        % define correctionFactor = (wlRowSmooth / wlRow)
        CF_3D(rr,:,f) = wlRowSmooth ./ wlRow;
    end
end
% AJB: note that the CF plots should have valleys where the sample data have peaks


%% LOAD THE MEASUREMENT & SUBTRACT DARK => (256x1024x5)
measStruct = load(measDataPath);
rawMeas    = double(measStruct.RawData.Spectrum);  % e.g. 5 frames => (1280x1024)

measDark = load(measDarkPath);
rawmeasDark    = double(measDark.RawData.Spectrum);  % e.g. 5 frames => (1280x1024)

numMeasFrames = size(rawMeas,1) / 256;

Z_meas = reshape(rawMeas.', [numCols, numRows, numMeasFrames]);
Z_meas = permute(Z_meas, [2,1,3]);  % => (256 x 1024 x 5)

Z_Dark = reshape(rawmeasDark.', [numCols, numRows, numMeasFrames]);
Z_Dark = permute(Z_Dark, [2,1,3]);  % => (256 x 1024 x 5)

% Subtract the same dark offset from the measurement
for f = 1:numMeasFrames
    Z_meas(:,:,f) = Z_meas(:,:,f) - Z_Dark(:,:,f);
end

%% NEW: Take the mean of Z_meas(:,:,:) over the third dimension
% this gives us an average single frame of biological data, 256 x 1024

OneFrame = mean(Z_meas,3);      % mean frame of *biological data*
% we only care about the high-SNR average frame

% similarly, we only care about the mean of CF_3D, not the individual
% frames

OneCF = mean(CF_3D,3);          % mean frame of *correction factor*

% show single rows of the sample, the wlRow, and the correction factor
figure(100); clf
mysubplot = 110;
range = [800:1000];


% plot biological
subplot(mysubplot+1)
plot( OneFrame(testRow,range) / max(OneFrame(testRow,range) ) ,'r') ;
axis tight
% xlim(range + 799)
title('biological row')

% plot corresponding WL row -- should have peaks where biological has them
% subplot(mysubplot+2)
hold on
plot(Z_OneFrame(testRow,range) / max(Z_OneFrame(testRow,range) ),'b' );
axis tight
% xlim([800 1000])
title('white light row')

% plot CF - this should have troughs where the biological has peaks
% subplot(mysubplot+3)
plot(OneCF(testRow,range) / max(OneCF(testRow,range) ) ,'k');
axis tight
% xlim([800 1000])
title('oscillations at the right of the spectrum')

% legend('bio', 'WL', 'CF')
% legend('bio', 'WL')



%% APPLY CF_3D FOR rows0 ONLY

OneFrame_corrected = OneFrame;

for rr = rows0
    measRow       = OneFrame(rr,:); % raw plot of the biological data
    correctionRow = OneCF(rr,:);  % correction factor for each row
    % OneFrame_corrected(rr,:) = measRow ./ correctionRow;
    OneFrame_corrected(rr,:) = measRow .* correctionRow;
end



%% Plot before and after

figure(2); clf

SubFig = 210;

% initial image of biological data, only 0 mm data
subplot(SubFig+1)

imagesc(1:numCols, rows0, OneFrame(rows0,:)); colormap('gray')
% plot(OneFrame(testRow,:), 'r')
axis tight
title('0 mm spectral image, before')

% final image of biological data
subplot(SubFig+2)

% imagesc(OneFrame_corrected); colormap('gray')
imagesc(1:numCols, rows0, OneFrame_corrected(rows0,:)); colormap('gray')
axis tight
title('0 mm spectral image, after correction')


%% show the '1' values for all rows0 
% spectra from rr
% subplot(SubFig+2)

figure(3); clf;
imagesc(1:numCols, rows0,OneCF(rows0,:)); colormap('gray') 
axis tight
title('correction factors for all 0 mm rows')


figure(4); clf
plot(sum(OneFrame_corrected(ZerommOnly,:)), 'b');
axis tight
title('sum of raw 0 mm data (no aberration correction)')
legend('corrected')

figure(5); clf
Offset = 0.1e4; % easier to compare
plot(sum(OneFrame(ZerommOnly,:)), 'r');
hold on
plot(-1*Offset + sum(OneFrame_corrected(ZerommOnly,:)), 'b')
axis tight
title('sum of raw 0 mm data (no aberration correction)')
legend('uncorrected','corrected')
return



% plot(mean(OneFrame(rr,:),1),'r');
% hold on
% plot(mean(OneFrame_corrected(rr,:),1),'b');
% title('0 mm spectra before and after correction')
% 
% 
% return


% for f = 1:numMeasFrames
%     for rr = rows0
%         measRow       = Z_meas(rr,:,f);
%         correctionRow = CF_3D(rr,:,f);  % 1x1024
%         Z_meas_corrected(rr,:,f) = measRow ./ correctionRow;
%     end
% end



%% RE-ADD THE DARK OFFSET TO THE CORRECTED DATA
% so final .mat has the same offset as raw

% we no longer need this

% for f = 1:numMeasFrames
%     Z_meas_corrected(:,:,f) = Z_meas_corrected(:,:,f) + Z_Dark(:,:,f);
% end

