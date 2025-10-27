% clc
clear
close all

%% === 0) FILE PATHS (EDIT AS NEEDED) ===

AJBPrefix = 'C:\Users\ajber\Box\research';

WLdata25APath = [AJBPrefix,'\BergerLabBoneProject\Data\Sadia\05March2025\WL_25F_9s.mat'];
WLdata25BPath = [AJBPrefix,'\BergerLabBoneProject\Data\Sadia\05March2025\WL_25F_9s_P2.mat'];
WLdata75Path  = [AJBPrefix,'\BergerLabBoneProject\Data\Sadia\05March2025\WL_75F_9s.mat'];

darkPath      = [AJBPrefix, '\BergerLabBoneProject\Data\Sadia\05March2025\DS_25F_9s.mat'];
measDataPath  = [AJBPrefix,'\BergerLabBoneProject\Data\Cadaver\1st_14\2024_05_15\MD24021688_T_D2P2_MM00.mat'];
measDarkPath  = [AJBPrefix,'\BergerLabBoneProject\Data\Cadaver\1st_14\2024_05_15\darkspec.mat'];

% Rows to correct (0mm region)
rows0 = 70:92;

%% LOAD & AVERAGE THE 9s DARK FOR BASELINE OFFSET ===
darkStruct = load(darkPath);
rawDark   = double(darkStruct.RawData.Spectrum);   % e.g. (6400 x 1024) => 25 frames

numRows = 256; 
numCols = 1024;

% Reshape the 25 dark frames => (256 x 1024 x 25)
Z_darkAll = reshape(rawDark.', [numCols, numRows, 25]);
Z_darkAll = permute(Z_darkAll, [2,1,3]);  % => (256 x 1024 x 25)

% Average them => (256 x 1024) baseline offset
Dark_9s = mean(Z_darkAll, 3);

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

% Subtract the dark from each frame => Z_wlAll - Dark_9s
for f = 1:125
    Z_wlAll(:,:,f) = Z_wlAll(:,:,f) - Dark_9s;  % now purely photon counts
end

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

testRow          = 80;            % pick any row in rows0
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

%% BUILD 3D CORRECTION FACTOR, ONLY rows0 => (256x1024x5)
smoothWindow = 80;  
CF_3D = ones(numRows, numCols, numMetaFrames);

for f = 1:numMetaFrames
    for rr = rows0
        wlRow = Z_wlMeta(rr,:,f);
        wlRowSmooth = smooth(wlRow, smoothWindow).';
        % define correctionFactor = (wlRow / wlRowSmooth)
        CF_3D(rr,:,f) = wlRow ./ wlRowSmooth;
    end
end

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

%% APPLY CF_3D FOR rows0 ONLY
Z_meas_corrected = Z_meas;

for f = 1:numMeasFrames
    for rr = rows0
        measRow       = Z_meas(rr,:,f);
        correctionRow = CF_3D(rr,:,f);  % 1x1024
        Z_meas_corrected(rr,:,f) = measRow ./ correctionRow;
    end
end

%% RE-ADD THE DARK OFFSET TO THE CORRECTED DATA
% so final .mat has the same offset as raw
for f = 1:numMeasFrames
    Z_meas_corrected(:,:,f) = Z_meas_corrected(:,:,f) + Z_Dark(:,:,f);
end

