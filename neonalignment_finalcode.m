clc;
close all;
clear;

%% ========================================================================
% STEP 1: LOAD RAW DATA
% Load white lamp and neon lamp spectral data 
% ========================================================================
% dataDir = 'C:\Users\Sadia\Desktop\Data Files\Neonasdata\polyorderneon = 3';

% acceptable but arbitrary choice of data - ajb
dataDir =  'C:\Users\ajber\Box\research\BergerLabBoneProject\Data\Cadaver\2025_06_12';

whiteLampFile = fullfile(dataDir, 'whitelamp.mat');
neonFile = fullfile(dataDir, 'neon.mat');

% Load white lamp data and extract the spectrum.
load(whiteLampFile, 'RawData'); 
whiteLampData = RawData.Spectrum;

% Load neon lamp data and extract the spectrum.
load(neonFile, 'RawData'); 
neonData = RawData.Spectrum; 

% Restrict to the first 256 rows.
whiteLampImage = whiteLampData(1:256, :); 
neonImage = neonData(1:256, :);

% Quick visualization of the raw neon image.
figure(545)
imagesc(neonImage)
title('Raw Neon Image');

% Get image dimensions.
[Ny, Nx] = size(whiteLampImage);
fprintf('Image dimensions: %d x %d\n', Ny, Nx); 

%% ========================================================================
% STEP 2: DETECT FIBER POSITIONS (Y-axis horizontal stripes)
% Here we collapse the white lamp image along the columns and use peak 
% detection to determine the fiber rows (which we trust as the ideal Y).
% ========================================================================
disp('Detecting fiber positions...');
whiteLampSum = sum(whiteLampImage, 2);  % Sum each row
dynamicThreshold = mean(whiteLampSum) + 0.2 * std(whiteLampSum);
expected_spacing = 3;  % Minimum spacing in rows

% Find peaks in the summed profile.
[pks, locs] = findpeaks(whiteLampSum, 'MinPeakHeight', dynamicThreshold, 'MinPeakDistance', expected_spacing);
fprintf('Total detected fibers: %d\n', length(locs));

% Display detected fiber rows.
figure;
imshow(whiteLampImage, []);
hold on;
for i = 1:length(locs)
    row = locs(i);
    line([1 Nx], [row row], 'Color', 'r', 'LineWidth', 1);
end
title('Detected Fiber Positions');
hold off;

%% ========================================================================
% STEP 3: IDENTIFY NEON COLUMNS & MATCH TO WAVELENGTHS
% Load the reference wavelengths from the process structure and match the 
% expected neon wavelengths to pixel columns. Then display the neon image 
% with vertical markers.
% ========================================================================

% need an initprocess-created file rather than raw, to get wavelengths
load(fullfile(dataDir, 'initprocess', 'WV24041682_E_D2P1_MD05.mat'), 'process');
wavelengths = process.wavelength;  % Reference wavelength scale.

% Define the expected neon wavelengths (in nm).
npeaklambda = [849.54, 859.13, 865.44, 878.06, 885.39, 886.55, 891.95, 914.87, 920.18, 930.09, 932.65, 942.54, 953.42, 954.74, 966.54]';
pixelPositions = zeros(size(npeaklambda));  % Preallocate for pixel columns

% For each expected wavelength, find the closest match in the wavelength array.
for i = 1:length(npeaklambda)
    [~, idx] = min(abs(wavelengths - npeaklambda(i)));
    pixelPositions(i) = idx;
end

% Display the neon image with vertical markers.
figure;
imagesc(neonImage);
set(gcf, 'Color', 'w');   % White figure background
axis image;
hold on;
for i = 1:length(pixelPositions)
    col = pixelPositions(i);
    % Draw a vertical red line at the detected neon column.
    line([col col], [1 Ny], 'Color', 'r', 'LineWidth', 2);
    % Label the line with the corresponding wavelength.
    text(col + 5, Ny/2, num2str(npeaklambda(i)), 'Color', 'yellow', ...
         'Rotation', 90, 'FontWeight', 'bold', 'FontSize', 10);
end
xlabel('Pixel Column (Wavelength Scale)');
ylabel('Fiber Row');
title('Matched Neon Columns with Wavelengths');
set(gca, 'XTick', pixelPositions, 'XTickLabel', num2str(npeaklambda, '%.2f'));
hold off;

%% ========================================================================
% STEP 4: COMBINE & ALIGN CONTROL POINTS
% Create a grid of control points by pairing each detected neon column 
% with each fiber row. The ideal control point for a given neon line is 
% (idealX, fiberRow) where idealX comes from the wavelength lookup.
% ========================================================================
detectedFiberPositions = locs;      % Y positions (from white lamp)
detectedNeonColumns = pixelPositions; % X positions (from neon wavelengths)

% Create a grid of ideal control points.
[gridX, gridY] = meshgrid(detectedNeonColumns, detectedFiberPositions);
combinedControlPoints = [gridX(:), gridY(:)];

% For visual verification, display the control points on the neon image.
figure; 
imshow(neonImage, []); 
hold on; 
for i = 1:size(combinedControlPoints, 1)
    x = combinedControlPoints(i, 1);
    y = combinedControlPoints(i, 2);
    plot(x, y, 'go', 'MarkerSize', 5, 'LineWidth', 1.5);
end 
title('Combined Control Points on Neon Image');
hold off;

%% ========================================================================
% STEP 5: STRAIGHTEN NEON COLUMNS WITH DATA-DRIVEN 2D INTERSECTION
%
% Goal:
%  For each neon column (each expected wavelength), we determine the 
%  refined (actualX, actualY) control points from the data without relying 
%  solely on the fixed ideal X.
%
% Process for each fiber (each ideal Y from white lamp detection):
%  1. Define the ideal control point as [selectedColumn, idealY] where:
%       - selectedColumn is from the wavelength lookup.
%       - idealY is from the white-lamp detected fiber.
%
%  2. In a vertical window (±verticalSearchHalf rows around idealY), loop 
%     over candidate rows. For each candidate row:
%       a. Use a horizontal search window (±searchWin pixels around selectedColumn)
%          to locate the brightest pixel.
%       b. In a refined window (±halfWin pixels around that brightest pixel),
%          compute the weighted (sub-pixel) X centroid.
%       c. Save the candidate row (Y) and the computed X centroid.
%
%  3. From all candidates in the vertical window, compute the median of the
%     candidate Y's and the median of the candidate X centroids. These medians 
%     are taken as the refined (actualX, actualY) control point.
%
%  4. Compute shifts:
%         dx = idealX - refined_actualX
%         dy = idealY - refined_actualY
%
% These control points (and shifts) will later be used for the global 2D warp.
% ========================================================================

% Save the original neon image (unchanged) for reference.
originalNeonImage = neonImage;

% Parameters for horizontal centroid detection.
halfWin = 8;           % Refined (sub-pixel) window half-width in X.
searchWin = 15;        % Initial horizontal search window half-width in X.

% Parameter for vertical search (to refine Y).
verticalSearchHalf = 3; % Vertical window: ±3 rows around the ideal Y.

% (Optional) Define the width of the band for later interpolation (not needed for
% control point extraction itself).
colBandHalfWidth = 10; % Used in later 2D re-sampling, kept here for clarity.

% Create a copy for storing the corrected result.
% (This variable will later be used in global correction, so we keep it separate.)
adjustedNeonImage = originalNeonImage;

% Preallocate cell arrays for saving control points for each neon column
% (for debugging/verification).
allActualControlPoints = cell(length(pixelPositions), 1);
allIdealControlPoints  = cell(length(pixelPositions), 1);

% Loop over each neon column (i.e., each expected wavelength).
for k = 1:length(pixelPositions)
    % Get the ideal X for this neon column (from the wavelength lookup).
    selectedColumn = pixelPositions(k);
    
    % Number of fibers (rows) from white lamp detection.
    numFibers = length(detectedFiberPositions);
    
    % Preallocate arrays to store control points for each fiber.
    actualControlPoints = zeros(numFibers, 2);  % Will store [refined_actualX, refined_actualY]
    idealControlPoints  = zeros(numFibers, 2);   % Defined as [selectedColumn, idealY]
    
    % Process each fiber (each ideal Y).
    for i = 1:numFibers
        % The ideal Y is given by the white lamp (detected fiber row).
        idealY = detectedFiberPositions(i);
        % The ideal control point is fixed: [selectedColumn, idealY].
        idealControlPoints(i,:) = [selectedColumn, idealY];
        
        % Define the vertical search window around this ideal Y.
        yMin_search = max(1, idealY - verticalSearchHalf);
        yMax_search = min(Ny, idealY + verticalSearchHalf);
        candidateRows = yMin_search:yMax_search;
        
        % Initialize arrays to collect candidate data.
        candidateYs = [];         % Will store candidate row indices.
        candidateCentroids = [];  % Will store computed X centroids for each candidate.
        
        % Loop over each candidate row in the vertical window.
        for r = candidateRows
            % Extract the intensity profile for row r.
            rowProfile = originalNeonImage(r, :);
            
            % Define a horizontal search window around selectedColumn.
            xMin_search = max(1, selectedColumn - searchWin);
            xMax_search = min(Nx, selectedColumn + searchWin);
            segment = rowProfile(xMin_search:xMax_search);
            
            % Find the brightest pixel within this horizontal segment.
            [~, relMaxIdx] = max(segment);
            brightestPixelIdx = xMin_search + relMaxIdx - 1;
            
            % Define a refined horizontal window around the brightest pixel.
            xMin = max(1, brightestPixelIdx - halfWin);
            xMax = min(Nx, brightestPixelIdx + halfWin);
            xWindow = xMin:xMax;
            windowIntensities = rowProfile(xWindow);
            
            % Compute the weighted (sub-pixel) centroid for X.
            if sum(windowIntensities) > 0
                centroidXCandidate = sum(xWindow .* windowIntensities) / sum(windowIntensities);
            else
                centroidXCandidate = brightestPixelIdx;
            end
            
            % Save the candidate row and its computed X centroid.
            candidateYs(end+1) = r;
            candidateCentroids(end+1) = centroidXCandidate;
        end
        
        % Compute the median of candidate Y's and candidate X centroids.
        % This median is our data-driven estimate of the control point.
        refinedY = round(median(candidateYs));   % Y is taken as an integer.
        refinedX = median(candidateCentroids);     % X can be sub-pixel.
        
        % Store the refined (actual) control point for this fiber.
        actualControlPoints(i,:) = [refinedX, refinedY];
    end
    
    % Save the control points (optional for later visualization).
    allActualControlPoints{k} = actualControlPoints;
    allIdealControlPoints{k}  = idealControlPoints;
    
    % Compute the shifts between the ideal and actual control points.
    % These will be used later for the global 2D correction.
    dx = idealControlPoints(:,1) - actualControlPoints(:,1); % Horizontal shifts.
    dy = idealControlPoints(:,2) - actualControlPoints(:,2); % Vertical shifts.
    
    % Here we store the shifts for each neon column for later global correction.
    % (We keep them in allIdealControlPoints and allActualControlPoints already.)
    
end


%% ========================================================================
% STEP 6: GLOBAL 2D CORRECTION
%
% In the previous steps, we computed refined (actualX, actualY) control points
% for each neon line (for each fiber) and obtained dx and dy shifts (where:
%   dx = idealX - actualX
%   dy = idealY - actualY).
%
% Instead of applying interp2 piecewise (i.e., only on narrow bands around the 
% neon columns), we now combine the information from all neon columns to get 
% a global shift for each fiber. We then interpolate these shifts to every row 
% of the image and apply a global 2D warp using interp2.
% ========================================================================

% --- Combine control point shifts across all neon columns ---
numFibers = length(detectedFiberPositions);  % number of fiber rows (ideal Y's)
numColumns = length(pixelPositions);           % number of neon lines

% Preallocate matrices to store dx and dy shifts for each fiber and each neon column.
dx_all = zeros(numFibers, numColumns);
dy_all = zeros(numFibers, numColumns);

% Loop over each neon column and extract the shifts for each fiber.
for k = 1:numColumns
    % Retrieve the refined control points from Step 5.
    % idealCP contains the ideal control points: [idealX, idealY],
    % where idealX is the expected column (from the wavelength lookup)
    % and idealY is the fiber row from white lamp detection.
    idealCP = allIdealControlPoints{k};   % Size: [numFibers x 2]
    
    % actualCP contains the refined (data-driven) control points:
    % [refined_actualX, refined_actualY]
    actualCP = allActualControlPoints{k};   % Size: [numFibers x 2]
    
    % Compute the per-fiber horizontal and vertical shifts for this neon column.
    dx_all(:,k) = idealCP(:,1) - actualCP(:,1); % dx: shift in X
    dy_all(:,k) = idealCP(:,2) - actualCP(:,2); % dy: shift in Y
end

% Average the shifts across all neon columns for each fiber.
% This yields one dx and one dy per fiber row.
dx_fiber = mean(dx_all, 2);  % [numFibers x 1] vector for horizontal shifts.
dy_fiber = mean(dy_all, 2);  % [numFibers x 1] vector for vertical shifts.

% The ideal fiber rows (Y positions) are given by detectedFiberPositions.
global_fiber_rows = detectedFiberPositions;

% Interpolate these per-fiber shifts to every row in the image.
allRows = (1:Ny)';  % All row indices in the image.
global_dx = interp1(global_fiber_rows, dx_fiber, allRows, 'linear', 'extrap');
global_dy = interp1(global_fiber_rows, dy_fiber, allRows, 'linear', 'extrap');

% --- Build a global coordinate grid for the image and apply the shifts ---
[Xgrid, Ygrid] = meshgrid(1:Nx, 1:Ny);  % Create coordinate grids for the full image.

% For each row, subtract the corresponding shift (applied uniformly across the row):
%   X_corrected = X_original - global_dx(row)
%   Y_corrected = Y_original - global_dy(row)
X_corrected_global = Xgrid - repmat(global_dx, 1, Nx);
Y_corrected_global = Ygrid - repmat(global_dy, 1, Nx);

% Use interp2 to re-sample the entire neon image at the corrected coordinates.
% 'spline' interpolation for smoothness.
correctedImage = interp2(1:Nx, 1:Ny, double(neonImage), ...
                         X_corrected_global, Y_corrected_global, 'spline', 0);

%% ========================================================================
% FINAL VISUALIZATION: RAW VS. GLOBALLY CORRECTED NEON IMAGE
% ========================================================================
figure('Name', 'Raw vs. Globally Corrected Neon Images');

% Subplot 1: Raw Neon Image.
subplot(2,1,1);
imagesc(neonImage);
axis image;
title('Raw Neon Image');
xlabel('X (pixels)');
ylabel('Y (pixels)');
colorbar;

% Subplot 2: Globally Corrected Neon Image.
subplot(2,1,2);
imagesc(correctedImage);
axis image;
title('Globally Corrected Neon Image');
xlabel('X (pixels)');
ylabel('Y (pixels)');
colorbar;


%% ========================================================================
% EXTRA FIGURE: Overlay Matched Neon Columns on Raw & Corrected Images
%% ========================================================================
figure (1500)
subplot(211)
imagesc(neonImage);
axis image;
colorbar; 
hold on;
for i = 1:length(pixelPositions)
    col = pixelPositions(i);
    line([col col], [1 Ny], 'Color', 'r', 'LineWidth', 2);
    text(col + 5, Ny/2, num2str(npeaklambda(i)), 'Color', 'yellow', ...
         'Rotation', 90, 'FontWeight', 'bold', 'FontSize', 10);
end
xlabel('Pixel Column (Wavelength Scale)');
ylabel('Fiber Row');
title('Matched Neon Columns with Wavelengths (Raw)');
set(gca, 'XTick', pixelPositions, 'XTickLabel', num2str(npeaklambda, '%.2f'));
hold off;

subplot(212)
imagesc(correctedImage);
axis image;
title('Globally Corrected Neon Image');
xlabel('X (pixels)');
ylabel('Y (pixels)');
colorbar;

%%
figure(123)
imagesc(correctedImage);
% axis image;
title('Globally Corrected Neon Image');
xlabel('X (pixels)');
ylabel('Y (pixels)');
% colorbar;

%% Plot Neon Spectra at 0 mm, 3 mm, and 6 mm with Vertical Offsets
% --- Parameters for Plotting ---
% Row ranges for each location:
rows0 = 73:93;    % 0 mm
rows3 = 1:65;     % 3 mm
rows6 = 101:252;  % 6 mm

% Number of frames (assumed from neonData)
[~, Nx, numFrames] = size(neonData);

% Define vertical offsets (to separate the curves in the plot)
% (These offsets are added to the intensity values.)
offset0 = 0;                   % No offset for 0 mm
offset3 = 0.5 * max(neonData(:));  % 3 mm: add 50% of the maximum raw intensity
offset6 = 1.0 * max(neonData(:));  % 6 mm: add 100% of the maximum raw intensity

% Define colors for each location:
color0 = [1 0 0];    % Red for 0 mm
color3 = [0 0.7 0];  % Green for 3 mm
color6 = [0 0 1];    % Blue for 6 mm

% --- Figure 1: Raw Neon Spectra ---
figure;
hold on;
for f = 1:numFrames
    % Extract the f-th frame of raw neon data.
    currentFrame = neonData(:,:,f);
    
    % Compute the average spectrum across the specified rows.
    spectrum0 = mean(currentFrame(rows0, :), 1);
    spectrum3 = mean(currentFrame(rows3, :), 1);
    spectrum6 = mean(currentFrame(rows6, :), 1);
    
    % Plot the spectra with vertical offsets.
    plot(1:Nx, spectrum0 + offset0, 'Color', color0, 'LineWidth', 1.5);
    plot(1:Nx, spectrum3 + offset3, 'Color', color3, 'LineWidth', 1.5);
    plot(1:Nx, spectrum6 + offset6, 'Color', color6, 'LineWidth', 1.5);
end
xlabel('Pixel Column');
ylabel('Average Intensity (with offset)');
title('Raw Neon Spectra at 0 mm, 3 mm, and 6 mm (5 Frames)');
legend('0 mm','3 mm','6 mm','Location','Best');
hold off;
axis tight;

% --- Figure 2: Globally Corrected Neon Spectra ---
figure;
hold on;
for f = 1:numFrames
    % Extract the f-th frame of the globally corrected image.
    currentFrame = correctedImage(:,:,f);
    
    % Compute the average spectrum over the specified row ranges.
    spectrum0 = mean(currentFrame(rows0, :), 1);
    spectrum3 = mean(currentFrame(rows3, :), 1);
    spectrum6 = mean(currentFrame(rows6, :), 1);
    
    % Plot the spectra with the same vertical offsets.
    plot(1:Nx, spectrum0 + offset0, 'Color', color0, 'LineWidth', 1.5);
    plot(1:Nx, spectrum3 + offset3, 'Color', color3, 'LineWidth', 1.5);
    plot(1:Nx, spectrum6 + offset6, 'Color', color6, 'LineWidth', 1.5);
end
xlabel('Pixel Column');
ylabel('Average Intensity (with offset)');
title('Globally Corrected Neon Spectra at 0 mm, 3 mm, and 6 mm (5 Frames)');
legend('0 mm','3 mm','6 mm','Location','Best');
hold off;
axis tight;


%% Plot Neon Spectra at 0 mm, 3 mm, and 6 mm (Raw vs. Corrected) in One Figure

% Row ranges for each location:
rows0 = 73:93;    % 0 mm
rows3 = 1:65;     % 3 mm
rows6 = 101:252;  % 6 mm

% If neonData and correctedImage are 3D: [Ny, Nx, numFrames]
[~, Nx, numFrames] = size(neonData);

% Vertical offsets (shift the spectra up so they don't overlap)
offset0 = 0;
offset3 = 0.5 * max(neonData(:));  % e.g. +50% of max raw intensity
offset6 = 1.0 * max(neonData(:));  % e.g. +100% of max raw intensity

% Colors for raw spectra (RGB)
color0_raw = [1 0 0];    % Red   for 0 mm (raw)
color3_raw = [0 0.7 0];  % Green for 3 mm (raw)
color6_raw = [0 0 1];    % Blue  for 6 mm (raw)

% Colors for corrected spectra (KCM)
color0_corr = 'k';  % Black   for 0 mm (corrected)
color3_corr = 'c';  % Cyan    for 3 mm (corrected)
color6_corr = 'm';  % Magenta for 6 mm (corrected)

figure('Name','Neon Spectra: Raw vs. Corrected (0,3,6 mm)');
hold on;

% --- Plot Raw Spectra ---
for f = 1:numFrames
    currentFrameRaw = neonData(:,:,f);
    
    % Average across the specified row ranges
    spectrum0_raw = mean(currentFrameRaw(rows0, :), 1);
    spectrum3_raw = mean(currentFrameRaw(rows3, :), 1);
    spectrum6_raw = mean(currentFrameRaw(rows6, :), 1);
    
    % Plot with vertical offsets
    plot(1:Nx, spectrum0_raw + offset0, 'Color', color0_raw, 'LineWidth', 1.5);
    plot(1:Nx, spectrum3_raw + offset3, 'Color', color3_raw, 'LineWidth', 1.5);
    plot(1:Nx, spectrum6_raw + offset6, 'Color', color6_raw, 'LineWidth', 1.5);
end

% --- Plot Corrected Spectra ---
for f = 1:numFrames
    currentFrameCorr = correctedImage(:,:,f);
    
    spectrum0_corr = mean(currentFrameCorr(rows0, :), 1);
    spectrum3_corr = mean(currentFrameCorr(rows3, :), 1);
    spectrum6_corr = mean(currentFrameCorr(rows6, :), 1);
    
    plot(1:Nx, spectrum0_corr + offset0, 'Color', color0_corr, 'LineWidth', 1.5);
    plot(1:Nx, spectrum3_corr + offset3, 'Color', color3_corr, 'LineWidth', 1.5);
    plot(1:Nx, spectrum6_corr + offset6, 'Color', color6_corr, 'LineWidth', 1.5);
end

% Create Dummy Plot Handles for a Unified Legend
% (We plot "nan" to avoid adding extra lines to the figure.)
h0raw  = plot(nan, nan, 'Color', color0_raw,  'LineWidth', 1.5);
h3raw  = plot(nan, nan, 'Color', color3_raw,  'LineWidth', 1.5);
h6raw  = plot(nan, nan, 'Color', color6_raw,  'LineWidth', 1.5);
h0corr = plot(nan, nan, 'Color', color0_corr, 'LineWidth', 1.5);
h3corr = plot(nan, nan, 'Color', color3_corr, 'LineWidth', 1.5);
h6corr = plot(nan, nan, 'Color', color6_corr, 'LineWidth', 1.5);

legend([h0raw, h3raw, h6raw, h0corr, h3corr, h6corr], ...
       {'0 mm (raw)','3 mm (raw)','6 mm (raw)', ...
        '0 mm (corr)','3 mm (corr)','6 mm (corr)'}, ...
       'Location','Best');

xlabel('Pixel Column');
ylabel('Average Intensity (with offset)');
title('Neon Spectra: Raw vs. Corrected at 0 mm, 3 mm, and 6 mm');
axis tight;
hold off;

