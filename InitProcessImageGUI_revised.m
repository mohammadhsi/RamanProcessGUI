function varargout = InitProcessImageGUI_revised(varargin)
% INITPROCESSIMAGEGUI_REVISED M-file for InitProcessImageGUI_revised.fig
%      INITPROCESSIMAGEGUI_REVISED, by itself, creates a new INITPROCESSIMAGEGUI_REVISED or raises the existing
%      singleton*.
%
%      H = INITPROCESSIMAGEGUI_REVISED returns the handle to a new INITPROCESSIMAGEGUI_REVISED or the handle to
%      the existing singleton*.

%
%      INITPROCESSIMAGEGUI_REVISED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INITPROCESSIMAGEGUI_REVISED.M with the given input arguments.
%
%      INITPROCESSIMAGEGUI_REVISED('Property','Value',...) creates a new INITPROCESSIMAGEGUI_REVISED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InitProcessImageGUI_revised_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InitProcessImageGUI_revised_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% using Microsoft VS Code to do the commmits... ajb 2024.08.03
% adding one more line just to check

% Edit the above text to modify the response to help InitProcessImageGUI_revised

% This branch is trying to revise the darkspec approach -- instead of a
% single experimental dark measurement with the same settings as the data 
% measurement, we will instead characterize the CCD dark response via two
% constants: 
%   ReadoutOffset: the average bias due to readout at each pixel (which
%   might wind up being a global constant)
%   
%   ThermalFactor: factor to calculate the thermal counts as a function of
%   time -- ThermalFactor x time = thermal counts
%
% These factors will be determined by averaging over many frames (>25) and
% perhaps averaging over neighboring pixels.
%
% Once we have these factors, we can subtract off the non-photon counts
% mathematically. The "ExposureTime" field, which is automatically recorded
% in the data measurement, is the only other parameter needed, ideally.
%
% - ajb 2024.07.24


% Last Modified by GUIDE v2.5 20-Sep-2016 09:46:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @InitProcessImageGUI_revised_OpeningFcn, ...
    'gui_OutputFcn',  @InitProcessImageGUI_revised_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before InitProcessImageGUI_revised is made visible.
function InitProcessImageGUI_revised_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InitProcessImageGUI_revised (see VARARGIN)

clear global

% Choose default command line output for InitProcessImageGUI_revised
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes InitProcessImageGUI_revised wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InitProcessImageGUI_revised_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Process.
function Process_Callback(hObject, eventdata, handles)
% hObject    handle to Process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in FileList.
function FileList_Callback(hObject, eventdata, handles)
% hObject    handle to FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns FileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileList


% --- Executes during object creation, after setting all properties.
function FileList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Throughput.
function Throughput_Callback(hObject, eventdata, handles)
% hObject    handle to Throughput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in FiberBasisSet.
function FiberBasisSet_Callback(hObject, eventdata, handles)
% hObject    handle to FiberBasisSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.mat', 'Fiber Basis Set File');
if strcmp(num2str(filename),'0')==0
    set(hObject,'string',[pathname filename]);
else
    set(hObject,'string','-');
end


% --- Executes on button press in CalibrationFile.
function CalibrationFile_Callback(hObject, eventdata, handles)
% hObject    handle to CalibrationFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.mat', 'Wavelength/Wavenumber Calibration File');
if strcmp(num2str(filename),'0')==0
    set(hObject,'string',[pathname filename]);
else
    set(hObject,'string','-');
end


% --- Executes on button press in initprocessdirectory.
function initprocessdirectory_Callback(hObject, eventdata, handles)
% hObject    handle to initprocessdirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.initprocessdirectory,'string',uigetdir('/Users/chishu/Desktop/data processing', 'Select File Directory'))

% --- Executes on selection change in FileList.
function listbox17_Callback(hObject, eventdata, handles)
% hObject    handle to FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileList


% --- Executes during object creation, after setting all properties.
function listbox17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddSpec.
function pushbutton97_Callback(hObject, eventdata, handles)
% hObject    handle to AddSpec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in initialprocess.
function initialprocess_Callback(hObject, eventdata, handles)
% hObject    handle to initialprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This code runs when the initialprocess callback button runs!

close all

%% Aberration correction, June 2025 - AJB

% Sadia Afrin (SA) developed code to correct aberrations in raw 2D images. This followed past work
% by Francis Esmonde-White (Mike Morris group at UMich) and Jason Maher. Neither Francis's paper nor
% Jason's thesis laid this out in sufficient detail for us to use as-is. (In Jason's case, it is
% likely that his approach worked correctly at one time but was subsequently altered in some way,
% perhaps during Christie Massie's time in our group.)

% As in Jason's version, we use the interp2 function to convert raw images into ideal images. In the
% current case, we use white light to define the raw "horizontal" guidelines from single fibers and
% neon spots from different fibers to define the raw "vertical" guidelines for chosen neon
% wavelengths.


%% Main goals

% Check whether Sadia's code can all be put in one place.
% - Two goals: 
%   (1) Do the spatial aberration correction to get all calibrated neon "lines" to line up horizontally.
%   (2) Use a more stable method of calibrating wavelength and wavenumber .

% Prior calibration method depended upon determining the "largest" N peaks of neon/tylenol. At the
% bottom of the list, this was unstable--the list would change. This required effort to maintain
% lists of the calibration locations.

% Using a 2D image approach, we can avoid the issue of relative peak heights. Now we instead will
% assign each calibrated neon line the appropriate literature wavelength value in the "ideal image"
% space.

%% Order of operations

% ACTUAL (RAW) data space

% 1. Fixed pattern correction (thermal lamp) - does not change the size of the file (does not need
% to be done first)

% ABERRATION CORRECTION - conversion from RAW to IDEAL space

% 2. Using neon as control, converts from raw image into ideal image (vertical stacks of
% same-wavelength neon spots). 
% 2a. Check that white light, tylenol, and cadaver data also look well-aligned vertically.

% Raw file is sub-pixel interpolated to enable more precise mapping for the conversion.

% To do: resample the data to be linear in WAVELENGTH rather than PIXEL - ajb 2025.06.21

% IDEALIZED DATA SPACE

% 3. Vertically sum each leg region. Result is three spectra corresponding to 0, 3, and 6 mm spatial
% offsets. [This is already done in the previous code.]

% 4. Apply throughput correction using green glass (same for all legs). [This is already done in the
% previous code. Same for all other post-processing steps such as cosmic ray removal, smoothing, and
% number of iterations for the Anita algorithm.]

%% Implement the aberrration code here

%% ========================================================================
% STEP 1: LOAD RAW DATA
% Load white lamp and neon lamp spectral data 
% ========================================================================
% dataDir = 'C:\Users\Sadia\Desktop\Data Files\Neonasdata\polyorderneon = 3';


% using a dialog popup - ajb
dataDir = uigetdir('C:\Users\ajber\Box\research\BergerLabBoneProject\Data\Cadaver\2025_06_12');
% dataDir =  'C:\Users\ajber\Box\research\BergerLabBoneProject\Data\Cadaver\2025_06_12';

whiteLampFile = fullfile(dataDir, 'whitelamp.mat');
neonFile = fullfile(dataDir, 'neon.mat');

% Load white lamp data and extract the spectrum.
load(whiteLampFile, 'RawData'); 
whiteLampData = RawData.Spectrum;

% Load neon lamp data and extract the spectrum.
load(neonFile, 'RawData'); 
neonData = RawData.Spectrum; 

% Restrict to the first 256 rows.
%  ? is this about using only the first frame rather than all frames? - ajb 2025.06.16
% and eventually we should use *all five frames* for cosmic ray reasons
Range = 256;
whiteLampImage = whiteLampData(1:Range, :); 
neonImage = neonData(1:Range, :);

% Quick visualization of the raw neon image.
figure(1)
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
figure(2);
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
%  -ajb 2025.06.22 : this gets us the process.wavelength structure that currently is generated by
%  the *old* initprocess method (via the GUI, mapping from pixel spacing to wavelength spacing)

% === ajb: Commenting this out, replacing with different approach
% load(fullfile(dataDir, 'initprocess', 'WV24041682_E_D2P1_MD05.mat'), 'process');
% wavelengths = process.wavelength;  % Reference wavelength scale.

% -ajb : the process.wavelength values are not spaced linearly. The command >> plot(wavelengths)
% makes this visually clear: the x axis is pixels, and the data plot is not a straight line (y
% spacings get smaller at the larger pixel values)

% -ajb 2025.06.23 : New idea is to stay in PIXEL mode for all of the aberration correct

% Define the expected neon wavelengths (in nm).
npeaklambda = [849.54, 859.13, 865.44, 878.06, 885.39, 886.55, 891.95, 914.87, 920.18, 930.09, 932.65, 942.54, 953.42, 954.74, 966.54]';
pixelPositions = zeros(size(npeaklambda));  % Preallocate for pixel columns

% === ajb: all aberration will now be done before doing wavelength calibration
% For each expected wavelength, find the closest match in the wavelength array.
% for i = 1:length(npeaklambda)
%     [~, idx] = min(abs(wavelengths - npeaklambda(i)));
%     pixelPositions(i) = idx;
% end

% Display the neon image with vertical markers.
figure(3);
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
figure(4)
 
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
%       c. Save the candidate row value (Y) and the computed X centroid.

  % ajb 2025.06.21: By wavelenth definition from literature, the Y value is assigned. How fine do we
  % make the X grid for defining this? 
  

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
            % ajb 2025.06.21: could this be refined to get a Gaussian fit (for instance) to get a
            % sub-pixel value for the Y?
            
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

        % ajb - why is refined Y taken as an integer while X is sub-pixel? - 2025.06.21
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

%% ===================================================
% SANITY CHECKS: RAW VS. GLOBALLY CORRECTED for Tylenol (peaks) and WhiteLamp (straightness)
% ====================================================

%% Tylenol check

% Load neon lamp data and extract the spectrum.
tylenolFile = fullfile(dataDir, 'tylenol.mat');
load(tylenolFile, 'RawData'); 
tylenolData = RawData.Spectrum; 
tylenolImage = tylenolData(1:Range,:);

TcorrectedImage = interp2(1:Nx, 1:Ny, double(tylenolImage), ...
            X_corrected_global, Y_corrected_global, 'spline', 0);

figure('Name', 'Raw vs. Globally Corrected Tylenol Images');
 
% Subplot 1: Raw Tylenol Image.
subplot(2,1,1);
imagesc(tylenolImage);
axis image;
title('Raw Tylenol Image');
xlabel('X (pixels)');
ylabel('Y (pixels)');
colorbar;

% Subplot 2: Globally Corrected Tylenol Image.
subplot(2,1,2);
imagesc(TcorrectedImage);
axis image;
title('Globally Corrected Tylenol Image');
xlabel('X (pixels)');
ylabel('Y (pixels)');
colorbar;

%% WhiteLamp check
figure('Name', 'Raw vs. Globally Corrected WhiteLamp Images');

WcorrectedImage = interp2(1:Nx, 1:Ny, double(whiteLampImage), ...
            X_corrected_global, Y_corrected_global, 'spline', 0);

% Subplot 1: Raw White Lamp Image.
subplot(2,1,1);
imagesc(whiteLampImage);
axis image;
title('Raw White Lamp Image');
xlabel('X (pixels)');
ylabel('Y (pixels)');
colorbar;

% Subplot 2: Globally Corrected White Lamp Image.
subplot(2,1,2);
imagesc(WcorrectedImage);
axis image;
title('Globally Corrected White Lamp Image');
xlabel('X (pixels)');
ylabel('Y (pixels)');
colorbar;

%% biological data check
figure('Name', 'Raw vs. Globally Corrected Data Image');

% choose a file from the dataDir;
[ChosenFile,dataDir] = uigetfile('C:\Users\ajber\Box\research\BergerLabBoneProject\Data\Cadaver\2025_06_12');
myFile = fullfile(dataDir, ChosenFile);
load(myFile, 'RawData'); 
myData = RawData.Spectrum; 
myImage = myData(1:Range,:);

McorrectedImage = interp2(1:Nx, 1:Ny, double(myImage), ...
            X_corrected_global, Y_corrected_global, 'spline', 0);

% Subplot 1: Raw bone image data.
% Currently MM00 from 
subplot(2,1,1);
imagesc(myImage);
axis image;
title('Raw Biological Data Image');
xlabel('X (pixels)');
ylabel('Y (pixels)');
colorbar;

% Subplot 2: Globally Corrected bone image data.
subplot(2,1,2);
imagesc(McorrectedImage);
axis image;
title('Globally Corrected Biological Data Image');
xlabel('X (pixels)');
ylabel('Y (pixels)');
colorbar;

% end of new block of aberration correction




%% Options

% Darkspec Filtering
window = -6:6; winsig = 10;

% CCD Image Size
px = 1024; py = 256;%Keren change it to 255 for microscope system

% Aberration Correction
polyorderaberration = 2;
xpixeldrift = 6;
ypixeldrift = 2;

% Throughput Properties
% 2024.02.06 ajb: for current system w/ 3 separate fiber bundles, it is
% probably not necessary to identify each fiber separately anymore.
fibernum = 40; % Number of fibers to use in fit
thpeakstripwindow = 3;
thedgedist = 4;

% Neon Properties

%npeaklambda = [849.54 859.13 NaN 865.44 NaN 878.06 885.39 886.55 891.95 914.87 920.18 NaN 930.09 NaN 932.65 NaN 942.54 NaN NaN 953.42 954.74 966.54].';
%npeaklambda = [849.54 859.13 NaN 865.44 NaN 870.41 878.06 885.39 891.95	898.86 914.87 920.18 NaN NaN 930.09 932.65 NaN 942.54 NaN NaN 953.42 966.54].';

% npeaklambda = [849.54        859.13           NaN        865.44           NaN        878.06        885.39	886.55        891.95        914.87        920.18           NaN      930.09    NaN        932.65           NaN        942.54           NaN           NaN        953.42	954.74        966.54].';
% Created on January 26, 2024, using ImprovedRelativePeakLocations


% % Created on 2024.02.17
%npeaklambda = [849.54 859.13 NaN 865.44 NaN 870.41 878.06 885.39 891.95 898.86 914.87 920.18 NaN 930.09 932.65 NaN 942.54 NaN NaN 953.42 966.54]';

% April 3 2024
%npeaklambda = [849.54        859.13           NaN        865.44           NaN        870.41        878.06        885.39        891.95        914.87        920.18           NaN        930.09        932.65           NaN        942.54           NaN           NaN        953.42    954.74        966.54]';

%July 15, 2024
%npeaklambda = [849.54        859.13           NaN        865.44           NaN        878.06        885.39        886.55        891.95        914.87        920.18        NaN        930.09        NaN        932.65        NaN        942.54        NaN        953.42        954.74        966.54]';

%Using February 26 calibration data on May 29 data, updated on July 19
npeaklambda = [849.54        859.13           NaN        865.44           NaN        870.41        878.06        885.39        891.95        898.86        914.87        920.18           NaN        930.09        932.65           NaN        942.54           NaN           NaN        953.42        966.54]';



% number of peaks calculated directly from the values above
npeaknum = length(npeaklambda);

polyorderneon = 3;

npeakstripwindow = 4;

% Tylenol Properties


%typeakwavenum = [NaN 329.2 390.9 465.1 NaN NaN 651.6 710.8 797.2 NaN 857.9 NaN 1168.5 1236.8 NaN 1278.5 1329.9 1371.5 1561.6 NaN 1648.4].';
%typeakwavenum = [329.2 NaN NaN NaN NaN 390.9 NaN 465.1 651.6 797.2 857.9 1168.5 1236.8 NaN 1278.5 1329.9 1371.5 1561.6 NaN 1648.4 NaN].';
%typeakwavenum = [329.2 390.9 465.1 651.6 710.8 797.2 857.9 NaN NaN NaN 1168.5 1236.8 NaN 1278.5 1329.9 1371.5 NaN 1561.6 NaN 1648.4 NaN].';

%typeakwavenum = [329.2 390.9 465.1 504 NaN 651.6 710.8 797.2 NaN 857.9 NaN 1168.5 1236.8 NaN 1278.5 1329.9 1371.5 1561.6 NaN 1648.4 NaN].'; %--Latest January 16

typeakwavenum = [329.2 390.9 465.1 NaN NaN 651.6 710.8 797.2 NaN 857.9 NaN 1168.5 1236.8 NaN 1278.5 1329.9 1371.5 1561.6 NaN 1648.4 NaN].'; 
% created January 26, using ImprovedRelativePeakLocations

typeaknum = length(typeakwavenum);
typeakstripwindow = 15;
tyedgedist = 21;

%% Get Files to Process
set(handles.initprocessstatus,'string','Status: Initializing...'); pause(1E-6)
filedir = get(handles.FileDirectory,'string');
s = what(filedir); allfiles = s.mat;
specind = logical(1 - ((1-cellfun('isempty', regexp(allfiles,'throughput'))) + ...
    (1-cellfun('isempty', regexp(allfiles,'neon'))) + ...
    (1-cellfun('isempty', regexp(allfiles,'tylenol'))) + ...
    (1-cellfun('isempty', regexp(allfiles,'whitelamp'))) + ...
    (1-cellfun('isempty', regexp(allfiles,'darkspec')))));
list = allfiles(specind);

%% Load Dark Spectrum
set(handles.initprocessstatus,'string','Status: Calculating Dark Spectrum...'); pause(1E-6)

% the file darkspec_calib.mat (which for a long time has simply been a copy
% of darkspec.mat), when initially loaded, is the raw measurement acquired,
% which is a 2D matrix (all frames are stored as a single image, which in
% the case of 5 frames gives dimension of 1280x1024).
darkspec = load([filedir '/darkspec_cali.mat']);
% This next line turns the data into a 3D matrix, giving each of the 
% frames its own, smaller matrix - for a 5-frame acquisition, the output
% matrix is now 5x256x1024.
darkspec = squeeze(double(permute(reshape(darkspec.RawData.Spectrum.',px,py, ...
    str2double(darkspec.RawData.NumofKin)),[3 2 1])./...
    str2double(darkspec.RawData.NumofAcu)));
% "mad" is "mean absolute deviation", acting along the first dimension,
% which is the number of frames -- this produce essentially a 2D matrix,
% but the first (frame) dimension still exists even though the index only
% goes to 1.
% Using "squeeze" eliminates this dimension, producing a truly 2D matrix.
darkspecmad = squeeze(mad(darkspec,1));
darkspecmed = squeeze(median(darkspec,1));

% 2024.07.28, AJB: 
% It looks like this is rejecting values that exceed a certain distance from
% the median (darkspecmed), setting them to nan.
darkspec(darkspec > permute(repmat(darkspecmed+5.*darkspecmad,[1 1 size(darkspec,1)]),[3 1 2])) = nan;
darkspec(darkspec < permute(repmat(darkspecmed-5.*darkspecmad,[1 1 size(darkspec,1)]),[3 1 2])) = nan;
% "nanmean" simply takes a mean that ignores NaN values.
darkspec = squeeze(nanmean(darkspec));
% It is this line above that creates an averaged single frame from the
% original multiframe darkspec.

% Remove bad pixels%%%Keren: we do not have bad pixels on new CCD
% 07/14/2020
% darkspec(82:256,185) = mean(darkspec(82:256,[184 186]),2);
% darkspec(115:256,308) = mean(darkspec(115:256,[307 309]),2);
% darkspec(113,501) = mean(darkspec(113,[500 502]),2);

% Filter Dark Spectrum
% (the window and winsig values are at the start of the 'options' section
% above)

% AJB note 2024.07.28: the gausskernel is only in the horizontal direction,
% I believe. That's why the darkspec2 spectrum smears only in the
% horizontal.
gausskernel = exp(-(window.^2)./(2.*winsig.^2));
gausskernel = gausskernel./sum(gausskernel(:));
% smooth out the 2D data in the single-frame image
darkspec2 = conv2(darkspec,gausskernel,'same');
mxwindow = max(window);
% These next two lines replace the outer boundaries of the convolved
% image (darspec2) with the original values. I'm not surprised that the
% edge regions of the convolution might be affected in a way we don't want,
% e.g. averaging in zeros.
darkspec2(1:mxwindow,:) = darkspec(1:mxwindow,:); darkspec2((py-mxwindow+1):py,:) = darkspec((py-mxwindow+1):py,:);
darkspec2(:,1:mxwindow) = darkspec(:,1:mxwindow); darkspec2(:,(px-mxwindow+1):px) = darkspec(:,(px-mxwindow+1):px);

% After all of this processing, what we have is a smoothed version of a
% single frame. Extreme pixel values have been rejected, using mad and median
% functions to define extremes ad hoc.
% Data were then averaged over all frames. 
% That average frame was conv2-ed by a Gaussian kernel. And
% finally the edge values were restored to non-convolved data to avoid
% convolution effects in that zone.

% AJB 2024.07.28:
% I do not see anywhere that the smoothed darkspec2 has been used to create
% a new darkspec value. 

% I've left this here in case we want to change the kernel and want to plot
% the before and after

    % figure; 
    % subplot(211)
    % imagesc(darkspec); colormap gray; crange = [900, 1050]; clim(crange);
    % axis equal; axis tight; colorbar; 
    % title('darkspec')
    % subplot(212)
    % % darkspec = darkspec2; clear darkspec2; %CM comment 12/11/2021
    % imagesc(darkspec2); colormap gray; clim(crange);
    % axis equal; axis tight; colorbar; 
    % title('darkspec2')

% Without setting darkspec = darkspec2 (which we haven't been doing), 
% I think the darkspec image being used below
% is just a lightly-corrected (for extreme values) average frame, without
% any smoothing.


% But I want to move to a time-flexible model, so all of the
% above is really the OLD idea for correcting the dark counts. 

%% Determine Wavelength Calibration
set(handles.initprocessstatus,'string','Status: Determining Wavelength Calibration...'); pause(1E-6)

neon = load([filedir '/neon.mat']);
accum = str2double(neon.RawData.NumofAcu);
neon = permute(reshape(neon.RawData.Spectrum.',px,py,str2double(neon.RawData.NumofKin)),[2 1 3]);
neon = double(neon);
neon = median(neon,3);
% provide a summed version that is a vector; this will be used later on for
% aberration correction, since neon (unlike tylenol) can provide roughly
% equal light levels for all three fiber bundles -- ajb 2024.02.18
sneon = sum(neon,1).';   

% neon = neon-darkspec.*accum;   
% !! darkspec removal not needed for this task - ajb 2024.01.10

% % Remove bad pixels %We do not have bad pixels in new CCD %Keren
% neon(82:256,185) = mean(neon(82:256,[184 186]),2);
% neon(115:256,308) = mean(neon(115:256,[307 309]),2);
% neon(113,501) = mean(neon(113,[500 502]),2);

%[npeakpixels,npeakheight] = PeakLocationsJ([],sum(neon,1).',npeaknum,npeakstripwindow);

%[npeakpixels,npeakheight] = ImprovedRelativePeakLocations_V1([],sum(neon,1).',npeaknum,10,300);


%% settings to automatically label a reasonable number of neon peaks
% 2/1/2024 ---smh

minPeakProminence = 0.01 * max(sum(neon,1).');
minPeakHeight = 0.01 * max(sum(neon,1).');
minPeakDistance = 1;  % Adjust based on the spacing of peaks in your spectrum
threshold = 0.0001 * max(sum(neon,1).');
windowSize = 2;

% finding neon peaks

%[npeakpixels,npeakheight] = ImprovedRelativePeakLocations_V2([], sum(neon,1).', npeaknum, windowSize, minPeakProminence, minPeakHeight, minPeakDistance, threshold);

% V2 was complicated and not efficient, so replaced by V1
[npeakpixels,npeakheight] = ImprovedRelativePeakLocations_V1([],sum(neon,1).',npeaknum,windowSize,minPeakProminence);

% function ..V2 reports the number of peaks and the corresponding heights
%   if this returns a different number of peaks than expected from the 
%   hardwired list of neon peaks, then set the expected number to be 
%   'npeakpixels'; these two values have to be equal in order to make the 
%   calibration GUI code run
NumberOfNeonPeaksToLabel = min(length(npeaklambda), length(npeakpixels));

if length(npeaklambda) ~= length(npeakpixels)
    % change the length of the npeaklambda vector (what was expected) 
    % to match the number that was actually found from the V2 function
    npeaklambda = npeaklambda(1:NumberOfNeonPeaksToLabel);
end

% create a vector for the number of peaks we are going to label - as seen
% just above, this can be a number less than that of the previous
% calibration
npeaklambdaold = zeros(NumberOfNeonPeaksToLabel,1);

while(sum((npeaklambdaold==npeaklambda) + floor((isnan(npeaklambdaold)+isnan(npeaklambda))./2))<NumberOfNeonPeaksToLabel)
% this line checks whether the previous and current assignments match (I
% haven't checked this fully, but it is working as I expected it to) - ajb
% 2024.02.17

    % assign 'lambdaold' to be the existing (old) list of peak assignments
    % (truncated to elements 1:NumberOfNeonPeaksToLabel already)
    npeaklambdaold = npeaklambda;

    % set up plots
    axes(handles.currentstep); cla; plot(sum(neon,1).'); hold on;
    text(npeakpixels,npeakheight,num2str(npeaklambda),'rotation',90);
    axis tight; set(gca,'ytick',[]); box on;
    ylabel('intensity / a.u.'); xlabel('pixel number');    
    axes(handles.previousstep); cla;

    % find the neon.fig file wherever it is first found - use is 
    % responsible for it being in the pwd or else in the Matlab path
    neonfig = which('neon.fig');
    figure_handle = openfig(neonfig); % figure is opened

    %figure_handle = openfig('C:\processingcode\Calibration\neon.fig');  %
    %  - just legacy

    %%
    axes_handle = findobj(figure_handle, 'Type', 'Axes'); % find handle to axes in figure
    axes_children_handle = get(axes_handle, 'Children');
    copyobj(axes_children_handle, handles.previousstep); % children of original axes are copied to new axes
    close(figure_handle);
    axes(handles.previousstep);
    axis tight; set(gca,'ytick',[]); box on;
    ylabel('intensity / a.u.'); xlabel('pixel number');
    
    prompt={'Enter the peak wavelength values'};
     
    name='Neon Spectrum';
    numlines=1;

    % provide the value of what was done the last time - i.e. use lambdaold
    defaultanswer={num2str(npeaklambdaold.')};
    % defaultanswer={num2str(npeaklambda.')};

    % now build a new npeaklambda by having the user type in values
    cellans = inputdlg(prompt,name,numlines,defaultanswer);
    % convert to numbers
    npeaklambda=str2num(cellans{1}).';  % 
       
     % Dwight Fairchild
    % This while loop reprompts if the input matrix dimensions do not match
    % the sample's matrix dimensions
    while( ~isequal(size(npeaklambda) ,size(npeaklambdaold)));
        
       prompt={'Enter the peak wavelength values'};
       name='Neon Spectrum';
       numlines=1;
       defaultanswer={num2str(npeaklambda.')};
       
       cellans = inputdlg(prompt,name,numlines,defaultanswer);
       npeaklambda=str2num(cellans{1}).'; 
    end
   
   
end % of while loop 

npeaklambda = npeaklambdaold;

ind = logical(1-isnan(npeaklambda));
npeakpixels = npeakpixels(ind); npeaklambda = npeaklambda(ind); npeakheight = npeakheight(ind);

process.wavelength = polyval(polyfit(npeakpixels,npeaklambda,polyorderneon),1:size(neon,2)).';

%% Load Throughput
throughput = load([filedir '/throughput.mat']);
throughput = double(permute(reshape(throughput.RawData.Spectrum.',px,py, ...
    str2double(throughput.RawData.NumofKin)),[3 2 1])./...
    str2double(throughput.RawData.NumofAcu));
if size(throughput,1) > 1
    throughputmad = squeeze(mad(throughput,1));
else
    throughputmad = squeeze(zeros(size(throughput)));
end
throughputmed = squeeze(median(throughput,1));
throughput(throughput > permute(repmat(throughputmed+10.*throughputmad,[1 1 size(throughput,1)]),[3 1 2])) = nan;
throughput(throughput < permute(repmat(throughputmed-10.*throughputmad,[1 1 size(throughput,1)]),[3 1 2])) = nan;
if size(throughput,1) > 1
    throughput = squeeze(nanmean(throughput));
else
    throughput = squeeze(throughput);
end
throughput = throughput-darkspec;  
% -- maybe not needed for this task   ajb
% 2024.01.10

% % Remove bad pixels  %We do not have bad pixels in new CCD %Keren
% throughput(82:256,185) = mean(throughput(82:256,[184 186]),2);
% throughput(115:256,308) = mean(throughput(115:256,[307 309]),2);
% throughput(113,501) = mean(throughput(113,[500 502]),2);

% See NIST ISRM 2241 certificate for polynomial coefficients
A = [1.15596E-17 -9.77171E-14 2.16023E-10 -5.86762E-8 2.28325E-4 9.71937E-2]; % A5 A4 A3 A2 A1 A0
wavenumtemp = (1./785-1./process.wavelength).*10.^7;
ISRM = polyval(A,wavenumtemp);

%% Load Whitelamp 
whitelamp = load([filedir '/whitelamp.mat']);
whitelamp = double(permute(reshape(whitelamp.RawData.Spectrum.',px,py, ...
    str2double(whitelamp.RawData.NumofKin)),[3 2 1])./...
    str2double(whitelamp.RawData.NumofAcu));
if size(whitelamp,1) > 1
    whitelampmad = squeeze(mad(whitelamp,1));
else
    whitelampmad = squeeze(zeros(size(whitelamp)));
end
whitelampmed = squeeze(median(whitelamp,1));
whitelamp(whitelamp > permute(repmat(whitelampmed+10.*whitelampmad,[1 1 size(whitelamp,1)]),[3 1 2])) = nan;
whitelamp(whitelamp < permute(repmat(whitelampmed-10.*whitelampmad,[1 1 size(whitelamp,1)]),[3 1 2])) = nan;
if size(whitelamp,1) > 1
    whitelamp = squeeze(nanmean(whitelamp));
else
    whitelamp = squeeze(whitelamp);
end
whitelamp = whitelamp-darkspec;

%% Detection system calibration steps

% Break the throughput calibration into two separate parts: high-frequency
% fixed pattern and broad spectral throughput. 

% The old version did the two steps together with green glass, but we can't do 
% that with the three-fiber-bundle approach because the GG only gives
% significant signal at the 0 mm location -- ajb 2024.02.12

%%  Fixed pattern

% If we were doing single-row fixed pattern correction, we would use the
% following approach with a thermal lamp data to determine high-frequency
% fixed pattern correction factors on a pixel-by-pixel level on each row:

% FixedPattern = whitelamp ./ smooth(whitelamp(:,1))

% We do see clear rippling for white light.  
% But we have found that our 5-minute integrations for exposed and
% transcutaneous bone measurements have significant shot noise relative to
% the fixed pattern (which has ripple amplitude at the single row level of
% +/- 2% at most).  So we cannot currently correct for fixed pattern at the
% row level.  Sanity check: plot the same row for each of the five frames.
% If FP-limited, they should overlap closely.  We do not see that.  - ajb

% Following Christie
% Massie's approach, we will instead sum over entire fiber legs.  This
% requires us to do aberration correction first, so that the summing
% doesn't blur out peaks (the raw image data has some curvature).  

% As a result, there is no fixed pattern correction performed at the raw
% level.  We will do aberration correction first on the full frame level,
% followed by fixed pattern at the leg level and finally spectral
% throughput correction with green glass fluorescence at the vector level
% (same correction for all rows because the GG does not illuminate all
% fibers in the current 3-bundle approach).  

% legacy line:
% throughput = throughput./repmat(ISRM.',256,1);%change from 256 to 255  Keren




%% Determine Wavenumber Calibration
set(handles.initprocessstatus,'string','Status: Determining Wavenumber Calibration...'); pause(1E-6)
tylenol = load([filedir '/tylenol.mat']);
accum = str2double(tylenol.RawData.NumofAcu);
tylenol = permute(reshape(tylenol.RawData.Spectrum.',px,py,str2double(tylenol.RawData.NumofKin)),[2 1 3]);
tylenol = double(tylenol);
tylenol = median(tylenol,3);

% tylenol = tylenol-darkspec.*accum;
%    taking this out to avoid negative values in calibration step - ajb
%    2024.01.10


% % Remove bad pixels  %We do not have bad pixels in new CCD %Keren
% tylenol(82:256,185) = mean(tylenol(82:256,[184 186]),2);
% tylenol(115:256,308) = mean(tylenol(115:256,[307 309]),2);
% tylenol(113,501) = mean(tylenol(113,[500 502]),2);

% tylenol = tylenol./repmat(ISRM.',256,1);%Keren from 256
% tylenol = double(tylenol)./(repmat(sum(throughput,1),256,1));
% maybe we can avoid using these altogether? - ajb 2024.01.10

stylenol = sum(tylenol,1).';
pixels = (1:px).'; pixels = (pixels-mean(pixels))./std(pixels);
stylenol = stylenol-polyval(polyfit(pixels,stylenol,5),pixels);

% add extra value to make all values positive
stylenol = stylenol - min(stylenol) + 1;

%[typeakwavelength2,typeakheight2] = PeakLocationsJ(process.wavelength,stylenol,typeaknum,typeakstripwindow,tyedgedist,0,2);
% size(typeakwavenum)
% typeakwavenumold= zeros(size(typeakwavenum));

%[typeakwavelength1,typeakheight1] = ImprovedPeakLocations(process.wavelength,stylenol,typeaknum,10,1,1);

%% settings to automatically lable a reasonable number of tylenol peaks
% taken from Gamma-AJB-B
minPeakProminence = 0.01 * max(stylenol);
minPeakHeight = 0.00001 * max(stylenol);
minPeakDistance = 1;  % Adjust based on the spacing of peaks in your spectrum
%threshold = 0.000001 * max(stylenol);
threshold = 0;
windowSize = 2;

%[typeakwavelength,typeakheight] = ImprovedRelativePeakLocations_V2(process.wavelength,stylenol, typeaknum, windowSize, minPeakProminence, minPeakHeight, minPeakDistance, threshold);
[typeakwavelength,typeakheight] = ImprovedRelativePeakLocations_V1(process.wavelength,stylenol,typeaknum,windowSize,minPeakProminence);

% NumberOfTylenolPeaksToLabel = min(length(npeaklambda), length(npeakpixels));


% Figure out which is smaller: the number of peaks found by the ..V2 algorithm
% above, or the number of peaks expected from the hardwired values at the
% start 
NumberOfTylenolPeaksToLabel = min( length(typeakwavelength), length(typeakwavenum) );

if length(typeakwavelength) ~= length(typeakwavenum)
    % change the length of the typeakwavenum vector (what was expected) 
    % to match the number that was actually found from the V2 function
    typeakwavenum = typeakwavenum(1:NumberOfTylenolPeaksToLabel);
end

% define a vector to hold the hardwired wavenum values
typeakwavenumold= zeros(size(typeakwavenum));

while(sum((typeakwavenumold==typeakwavenum) + floor((isnan(typeakwavenumold)+isnan(typeakwavenum))./2))<typeaknum)
    typeakwavenumold = typeakwavenum;
    axes(handles.currentstep); cla; plot(process.wavelength,stylenol); hold on;
    text(typeakwavelength,typeakheight,num2str(typeakwavenum),'rotation',90);
    axis tight; set(gca,'ytick',[]); box on; xt = xlim;
    ylabel('intensity / a.u.'); xlabel('wavelength / nm');
    
    axes(handles.previousstep); cla;
    
    %% tylenol figure
    % find the tylenol.fig file wherever it is first found - user is 
    % responsible for it being in the pwd or else in the Matlab path
    tylenolfig = which('tylenol.fig');
    figure_handle = openfig(tylenolfig); % figure is opened

    %%
    axes_handle = findobj(figure_handle, 'Type', 'Axes'); % find handle to axes in figure
    axes_children_handle = get(axes_handle, 'Children');
    copyobj(axes_children_handle, handles.previousstep); % children of original axes are copied to new axes
    close(figure_handle);
    axes(handles.previousstep);
    axis tight; set(gca,'ytick',[]); box on; xlim(xt);
    ylabel('intensity / a.u.'); xlabel('wavelength / nm');
    
    prompt = {'Enter the peak wavenumber values'};
    name = 'Tylenol Spectrum';
    numlines =1 ;
    defaultanswer = {num2str(typeakwavenum.')};
    cellans = inputdlg(prompt,name,numlines,defaultanswer);
    typeakwavenum = str2num(cellans{1}).';
    
    % Dwight Fairchild
    % This while loop reprompts if the input matrix dimensions do not match
    % the sample's matrix dimensions
     while( ~isequal(size(typeakwavenum) ,size(typeakwavenumold)));
        
        prompt={'Enter the peak wavelength values'};
        name='Neon Spectrum';
        numlines=1;
        defaultanswer={num2str(typeakwavenum.')};
       
      cellans = inputdlg(prompt,name,numlines,defaultanswer);
       typeakwavenum=str2num(cellans{1}).';  
    end
end

ind = logical(1-isnan(typeakwavenum));
typeakwavelength = typeakwavelength(ind); typeakwavenum = typeakwavenum(ind);

process.laserwavelength = mean(((typeakwavenum*10^-7) + 1./typeakwavelength).^-1);
process.wavenum = (1./process.laserwavelength - 1./process.wavelength)*10^7;

%% Determine Aberration Correction
set(handles.initprocessstatus,'string','Status: Determining Aberration Correction...'); pause(1E-6)


%% Calculate y positions -- adjusts CCD columns so that the fiber stripes 
% are horizontal

% 2024.02.18 --ajb 
% This should be done using illumination of the full CCD as
% brightly as possible in order to get best data
%   Using the 3 fiber bundles, it is *possible* to get 40 peaks detected,
% but white light is better, as it lights up all fibers nearly equally.  
[idealycps,peakheight] = PeakLocationsJ([],sum(whitelamp,2),fibernum,thpeakstripwindow,thedgedist);

% [idealycps,peakheight] = PeakLocationsJ([],sum(throughput,2),fibernum,thpeakstripwindow,thedgedist);

% 1/2/2024 ---smh
%startsmh

% epsilon = 1e-3;
% offset_p = abs(min(min(sum(throughput,2)), 0)) + epsilon;  % epsilon can be a small value like 1e-3 to avoid zero values
% adjustedSpectrum = sum(throughput,2) + offset_p;
% 
% minPeakProminence = 0.000000001 * max(sum(neon,1).');
% minPeakHeight = 0.000000001 * max(sum(neon,1).');
% minPeakDistance = 1;  % Adjust based on the spacing of peaks in your spectrum
% %threshold = 0.0001 * max(sum(neon,1).');
% threshold = 0;
% windowSize = 2;

% [idealycps_smh,peakheight_smh] = ImprovedRelativePeakLocations_V2([],adjustedSpectrum, fibernum, windowSize, minPeakProminence, minPeakHeight, minPeakDistance, threshold);
% 
% [idealycps_smh2,peakheight_smh2] = ImprovedRelativePeakLocations_V1([],adjustedSpectrum,fibernum,2,minPeakProminence);

%endsmh

ridealycps = round(idealycps);  % this rounds to the nearest integer for the y-heights of the ideal stripes

for ijk = 1:fibernum
    % use whitelamp because throughput (GG) doesn't light up all fibers
    % strongly
    [a,measuredycps(ijk,:)] = max(whitelamp( (-ypixeldrift:ypixeldrift) + ridealycps(ijk),:));
%    [a,measuredycps(ijk,:)] = max(throughput( (-ypixeldrift:ypixeldrift) + ridealycps(ijk),:));
end
    measuredycps = measuredycps+repmat(ridealycps,1,px)-(ypixeldrift+1);

pixels = (1:px).'; pixels = (pixels-mean(pixels))./std(pixels); 
% centered at 0; scaled to not be huge numbers when raised to powers

% Initialize polynomial matrix
polynom = zeros(length(pixels),polyorderaberration+1);
% Values range from 1 to 2^order
for j=0:1:polyorderaberration
    polynom(:,j+1)=pixels.^j;
end

% figure; imagesc(throughput); colormap('gray'); hold on; plot(measuredycps.','r','linewidth',1)
[a,measuredycps] = OLSJ(measuredycps.',polynom); measuredycps = measuredycps.'; % replace with polyval and polyfit
% figure; imagesc(throughput); colormap('gray'); hold on; plot(measuredycps.','r','linewidth',1)

for ijk = 1:px
    Yi(:,ijk) = polyval(polyfit(idealycps,measuredycps(:,ijk),polyorderaberration),1:py);
end

% Similarly, now calculate ideal x positions - this lines up the peaks of
% all rows for calibrated peaks
%   As with green glass, we no longer have equally strong stripes for
%   tylenol.  It would be better to use neon to do the horizontal
%   adjustments.  

% for now, keep using PeakLocationsJ (could switch to Mohammad's V2 later)
nedgedist = tyedgedist;   % neon has no peaks near the far edge; maybe a problem at near edge?

idealxcps = PeakLocationsJ([],sneon,npeaknum,npeakstripwindow,tyedgedist,0,2);
% idealxcps = PeakLocationsJ([],stylenol,typeaknum,typeakstripwindow,tyedgedist,0,2);
ridealxcps = round(idealxcps);

%for ijk = 1:typeaknum
for ijk = 1:npeaknum
    [a,measuredxcps(ijk,:)] = max(neon(:, (-xpixeldrift:xpixeldrift) + ridealxcps(ijk)),[],2);
end
measuredxcps = measuredxcps+repmat(ridealxcps,1,py)-(xpixeldrift+1);

pixels = (1:py).'; pixels = (pixels-mean(pixels))./std(pixels);
% Initialize polynomial matrix
polynom = zeros(length(pixels),polyorderaberration+1);
% Values range from 1 to 2^order
for j=0:1:polyorderaberration
    polynom(:,j+1)=pixels.^j;
end

% switching to using neon for x calibration
% figure; imagesc(tylenol); colormap('gray'); hold on; 
% figure; imagesc(neon); colormap('gray'); hold on; 
% plot(measuredxcps.',1:py,'r','linewidth',1)
[a,measuredxcps] = OLSJ(measuredxcps.',polynom); measuredxcps = measuredxcps.'; % replace with polyval and polyfit
% figure; imagesc(tylenol); colormap('gray'); hold on; 
% figure; imagesc(neon); colormap('gray'); hold on; 
% plot(measuredxcps.',1:py,'r','linewidth',1)

for ijk = 1:py
    Xi(ijk,:) = polyval(polyfit(idealxcps,measuredxcps(:,ijk),polyorderaberration),1:px);
end

%% Determine crop pixels
ind = sum(Xi>=1); mx = max(ind);
cpx1 = find(ind==mx,1,'first');
ind = sum(Xi<=1024); mx = max(ind);
cpx2 = find(ind==mx,1,'last');
ind = sum(Yi>=1,2); mx = max(ind);
cpy1 = find(ind==mx,1,'first');
ind = sum(Yi<=256,2); mx = max(ind);
cpy2 = find(ind==mx,1,'last');
cpx = cpx2-cpx1+1;
cpy = cpy2-cpy1+1;
process.wavenum = process.wavenum(cpx1:cpx2);
process.wavelength = process.wavelength(cpx1:cpx2);

%% Determine Fiber Basis   %No longer doing this CM 12/11/2021
% set(handles.initprocessstatus,'string','Status: Determining Fiber Basis...'); pause(1E-6)
% throughput = throughput.*repmat(ISRM.',256,1); % Return to uncorrected throughput
% ISRM = ISRM(cpx1:cpx2);
% throughput = interp2(throughput,Xi,Yi,'spline'); % Apply aberration correction
% throughput = throughput(cpy1:cpy2,cpx1:cpx2)./repmat(ISRM.',cpy,1); % Crop spectrum and correct for throughput
% sthroughput = sum(throughput,2);
% [peaklocs,peakheight] = PeakLocationsJ([],sthroughput,fibernum,thpeakstripwindow,thedgedist-py+cpy2);
% [~,~,~,~,fiberbasistot] = GFitFiberBasisJ((1:cpy).',sthroughput,fibernum,peaklocs,peakheight);
% 
% % TolX = 1e-16; % 1e-6 by default
% % options = optimset('TolX',TolX);
% for ijk = 1:size(throughput,2)
%     %     c = lsqnonneg(fiberbasistot,throughput(:,ijk),options);
%     %     fiberbasis{ijk} = fiberbasistot.*repmat(c.',cpy,1);
%     [~,~,fiberbasis(ijk)] = OLSJ(throughput(:,ijk),fiberbasistot);
% end
% for kkk=1:40
%     fiberbasis2(:,kkk)=fiberbasis{1}(:,kkk)./max(fiberbasis{1}(:,kkk)).*max(fiberbasis{1}(:,1));
% end
% 
%% Clear unused variables
%clearvars -except hObject eventdata handles process filedir fiberbasis2 list darkspec Xi Yi fiberbasis px py cpx1 cpx2 cpy1 cpy2 cpx cpy
clearvars -except hObject eventdata handles process filedir list darkspec Xi Yi px py cpx1 cpx2 cpy1 cpy2 cpx cpy throughput ISRM whitelamp

%% Process Data
window = -6:6; winsig = 10;
set(handles.initprocessstatus,'string','Status: Calculating Dark Spectrum...'); pause(1E-6)
darkspec = load([filedir '/darkspec.mat']);
darkspec = squeeze(double(permute(reshape(darkspec.RawData.Spectrum.',px,py, ...
    str2double(darkspec.RawData.NumofKin)),[3 2 1])./...
    str2double(darkspec.RawData.NumofAcu)));
darkspecmad = squeeze(mad(darkspec,1));
darkspecmed = squeeze(median(darkspec,1));
darkspec(darkspec > permute(repmat(darkspecmed+5.*darkspecmad,[1 1 size(darkspec,1)]),[3 1 2])) = nan;
darkspec(darkspec < permute(repmat(darkspecmed-5.*darkspecmad,[1 1 size(darkspec,1)]),[3 1 2])) = nan;
darkspec = squeeze(nanmean(darkspec));

% % Remove bad pixels %We do not have bad pixels in new CCD %Keren
% darkspec(82:256,185) = mean(darkspec(82:256,[184 186]),2);
% darkspec(115:256,308) = mean(darkspec(115:256,[307 309]),2);
% darkspec(113,501) = mean(darkspec(113,[500 502]),2);

% Filter Dark Spectrum
gausskernel = exp(-(window.^2)./(2.*winsig.^2));
gausskernel = gausskernel./sum(gausskernel(:));
darkspec2 = conv2(darkspec,gausskernel,'same');
mxwindow = max(window);
darkspec2(1:mxwindow,:) = darkspec(1:mxwindow,:); darkspec2((py-mxwindow+1):py,:) = darkspec((py-mxwindow+1):py,:);
darkspec2(:,1:mxwindow) = darkspec(:,1:mxwindow); darkspec2(:,(px-mxwindow+1):px) = darkspec(:,(px-mxwindow+1):px);
% figure; imagesc(darkspec); ct = caxis;
%darkspec = darkspec2; clear darkspec2; %CM 12/11/2021

%-----------Ab. correct and crop calibration samples white lamp and green glass  %CM
%12/11/2021
whitelamp = interp2(whitelamp,Xi,Yi,'spline'); 
whitelamp = whitelamp(cpy1:cpy2,cpx1:cpx2); %cpx1 => 10 CM 12/12/2021

throughput = interp2(throughput,Xi,Yi,'spline'); 
throughput = throughput(cpy1:cpy2,cpx1:cpx2); %cpx1 => 10 CM 12/12/2021
ISRM2 = ISRM(cpx1:cpx2); 



set(handles.initprocessstatus,'string','Status: Processing Data...'); pause(1E-6)
if isempty(list) == 0  % i.e. if there are 1 or more files to process
    if isdir([filedir '/initprocess/']) == 0
        mkdir(filedir,'initprocess');
    end
    process.location = []; process.framenum = []; process.exptime = [];
    process.spec = []; process.shotnoise = []; process.accumnum = [];
    process.saturated = [];
    process = orderfields(process);
    
    totiter = length(list);
    curriter = 1;
    tic
    for ijk = 1:length(list) % For each data file (i.e. a measurement)
        savefilename = [filedir '/initprocess/' list{ijk}];
        if exist(savefilename,'file')~=2
            % read data file
            process.location = [filedir '/' list{ijk}];
            load(process.location);
            
            process.framenum = str2double(RawData.NumofKin);
            process.exptime = str2double(RawData.ExposureTime);
            process.accumnum = str2double(RawData.NumofAcu);
            process.spec = [];
            process.shotnoise = [];
            
            
            if sum(RawData.Spectrum(:) == 65535) > 60  % if more than 60 saturated pixels, don't use the file
                process.saturated = 1;
                disp([process.location ' image saturated!']);
            else  % this is the start of processing the file
                process.saturated = 0;
                Z = permute(reshape(RawData.Spectrum.',px,py,str2double(RawData.NumofKin)),[2 1 3]);%keren just a mark, I forgot why
                clear RawData
                Z = double(Z);
                Z = Z-repmat(darkspec,[1 1 size(Z,3)]).*process.accumnum; % Subtract dark spectrum
                Z = Z.*7; % Convert to photoelectrons
                
                
%-----------manual set the rows for each leg CM 12/11/2021 not doing
%fiberbasis to get fiber spectrum
        leg{1} = [67:95];  %0mm offset (4 fibers)              
        leg{2} = [1:66];   %3mm offset (12 fibers)
        leg{3} = [96:252]; %6mm offset (26 fibers)
%-----------manual set the rows for each leg CM 12/11/2021

        for klm = 1:size(Z,3)    % looping over the number of *frames* - typically 5 frames, stored separately?
                    
%                     % Remove bad pixels  %Keren
%                     Z(82:256,185,klm) = mean(Z(82:256,[184 186],klm),2);
%                     Z(115:256,308,klm) = mean(Z(115:256,[307 309],klm),2);
%                     Z(113,501,klm) = mean(Z(113,[500 502],klm),2);
                    
%% Aberration Correction
        ZCt = interp2(Z(:,:,klm),Xi,Yi,'spline');

%%
        % Crop image
        ZC = ZCt(cpy1:cpy2,cpx1:cpx2); 
        process.image(:,:,klm)=ZC;
        
        % in the future: apply row-level correction first?


        %% apply fixed pattern and spectral throughput changes next
        SmoothNum = 50;  % used for both high and low freq; nothing magical about this value

        ZeroMMLeg = 1;      % reminder in case one forgets which is first
        % always use first leg for throughput correction; others don't have much signal
        
        SummedThroughput = (sum(throughput(leg{ZeroMMLeg},:)))';
        SmoothedThroughput = smooth(SummedThroughput,SmoothNum);
        Throughput_Multiplier = ISRM2./SmoothedThroughput;
        
        % loop over the three legs
        for i = 1:size(leg,2)
           
        % Part 1: high-frequency fixed pattern correction
        
        % get whitelamp "ripple" function for this leg
        whitelamp_leg(:,i) = sum(whitelamp(leg{i},:));  %get whitelamp leg 12/11/2021
        s = smooth(whitelamp_leg(:,i),SmoothNum); %CM
       
        % Being explicit: the FP term on the next line will be
        % *multiplicative* upon data, hence the WL ripples are in
        % the denominator term
        FP_multiplier = s./whitelamp_leg(:,i);  
        % Sanity check: FP_multiplier is a vector averaged at
        % 1, with structure due to high-frequency fixed pattern

        % calculate corresponding leg spectrum
        ZC_leg(:,i) = sum(ZC(leg{i},:));
        % apply FP correction to the corresponding summed data
        ZC_leg_FP(:,i) = ZC_leg(:,i) .* FP_multiplier;

        pause(0.1);

        % Part 2: apply universal spectral throughput
        % correction (same for all legs because the green glass
        % only provides strong spectral data for the 0 mm leg)

        % apply the throughput correction
        ZC_leg_FP_thru(:,i) = ZC_leg_FP(:,i) .* Throughput_Multiplier;

        % for tylenol at 0 mm at least, this seems to work!
                    

                        % throughput_leg(:,i) = sum(throughput(leg{i},:)); %get throughput leg CM 12/11/2021
                        % throughput_leg_s(:,i) = smooth(throughput_leg(:,i),100); %smooth to calculate spectral response CM 12/11/2021
                        % throughput_leg_s(:,i) = throughput_leg_s(:,i)./ISRM2; %calculate spectral response from smooth green glass and NIST standard CM 12/11/2021
                        % 
                        % ZC_leg(:,i) = sum(ZC(leg{i},:)); %get data leg CM 12/11/2021
                        % ZC_leg_thru(:,i) = ZC_leg(:,i)./throughput_leg_s(:,i);  %correct for spectral throughput CM 12/11/2021
                        % 
                        % whitelamp_leg(:,i) = sum(whitelamp(leg{i},:));  %get whitelamp leg 12/11/2021
                        % s = smooth(whitelamp_leg(:,i),50); %CM
                        % fp = whitelamp_leg(:,i)./s; %low pass filter to get fixed pattern CM 12/11/2021
%                         
                        
                        % ZC_2(:,i) = ZC_leg_thru(:,i)./(fp); %
                        %ZC_2(:,i) = ZC_leg_thru(:,i); 
        
        end % of loop over legs
        
        % this becomes the data for the klm-th experimental measurement
        ZC_3(:,:,klm) = ZC_leg_FP_thru; 
            
                    
                    %-----No longer extracting fiber spectra CM 12/11/2021
%                     % Extract spectrum from each fiber
%                     for jkl = 1:cpx
%                         [process.spec(jkl,:,klm)] = ...
%                             OLSJ(ZC(:,jkl),[fiberbasis{jkl}]);
%                         
%                         % Covariance matrix of noise (assuming measurement noise is uncorrelated)
%                         % See Determination of uncertainty in parameters extracted
%                         % from single spectroscopic measurements, equation (4)
%                         Cw = diag(ZC(:,jkl));
%                         variance = diag(inv(fiberbasis{jkl}'/Cw*fiberbasis{jkl}));
%                         variance(variance<0) = 0; variance(isnan(variance)) = 0;
%                         
%                         process.shotnoise(jkl,:,klm) = sqrt(variance);
%                         
%                         % Add readout noise?
%                         
%                     end
                    
                    %-------scaling factor from using fiberbasis => no
                    %longer needed I think CM 12/11/2021
%                     normfac = repmat(mean(process.shotnoise(:,:,klm)),size(process.shotnoise,1),1);
%                     process.spec(:,:,klm) = process.spec(:,:,klm)./normfac;%filt shot noise
%                     meansig = repmat(mean(process.spec(:,:,klm)),size(process.spec,1),1);%mean spectrum
%                     process.spec(:,:,klm) = process.spec(:,:,klm).*meansig;
%                     process.shotnoise(:,:,klm) = process.shotnoise(:,:,klm)./normfac.*meansig;
                end
            process.spec = ZC_3;
            end
            
            % Save Data
            save(savefilename,'process')
            
            % Display remaining time
            [hours,minutes,seconds] = RemainingTimeJ(curriter,totiter);
            minutes = minutes+hours.*60;
            set(handles.initprocessstatus,'string',['Status: Processing Data... ' ...
                num2str(minutes) ' min ' num2str(seconds) ' sec remaining']); pause(1E-6)
            curriter = curriter+1;
        else
            totiter = totiter-1;
            tic
        end
    end
    
    set(handles.initprocessstatus,'string','Status: Ready');
else
    errordlg('No Data Files', 'Error');
end


% --- Executes on button press in FiberBasisSet.
function pushbutton84_Callback(hObject, eventdata, handles)
% hObject    handle to FiberBasisSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in CalibrationFile.
function wavenumbercal_Callback(hObject, eventdata, handles)
% hObject    handle to CalibrationFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in svgsmoothonoff.
function svgsmoothonoff_Callback(hObject, eventdata, handles)
% hObject    handle to svgsmoothonoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value') == 1
    set(handles.smoothpolyorder,'enable','on'); set(handles.smoothwindowsize,'enable','on');
else
    set(handles.smoothpolyorder,'enable','off'); set(handles.smoothwindowsize,'enable','off');
end

% Hint: get(hObject,'Value') returns toggle state of svgsmoothonoff


function bkgdpolyorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polyorderaberration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of polyorderaberration as text
%        str2double(get(hObject,'String')) returns contents of polyorderaberration as a double


function polyorderaberration_Callback(hObject, eventdata, handles)
% hObject    handle to polyorderaberration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of polyorderaberration as text
%        str2double(get(hObject,'String')) returns contents of polyorderaberration as a double


% --- Executes during object creation, after setting all properties.
function polyorderaberration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polyorderaberration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c1_Callback(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c1 as text
%        str2double(get(hObject,'String')) returns contents of c1 as a double


% --- Executes during object creation, after setting all properties.
function c1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c2_Callback(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c2 as text
%        str2double(get(hObject,'String')) returns contents of c2 as a double


% --- Executes during object creation, after setting all properties.
function c2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c1t_Callback(hObject, eventdata, handles)
% hObject    handle to c1t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c1t as text
%        str2double(get(hObject,'String')) returns contents of c1t as a double


% --- Executes during object creation, after setting all properties.
function c1t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c1t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c2t_Callback(hObject, eventdata, handles)
% hObject    handle to c2t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c2t as text
%        str2double(get(hObject,'String')) returns contents of c2t as a double


% --- Executes during object creation, after setting all properties.
function c2t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c2t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function crrmad_Callback(hObject, eventdata, handles)
% hObject    handle to crrmad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of crrmad as text
%        str2double(get(hObject,'String')) returns contents of crrmad as a double


% --- Executes during object creation, after setting all properties.
function crrmad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to crrmad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tempprocess.
function finalprocess_Callback(hObject, eventdata, handles)
% hObject    handle to tempprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

process.filedirectory = get(handles.initprocessdirectory,'string');
s = what(process.filedirectory ); process.list = s.mat;
[process.list] = sort_nat(process.list).';

% Wavenumber regions

% the extra-large wavenumber values (i.e. overflow for the polynomial fit)
c1 = str2double(get(handles.c1,'string')); c2 = str2double(get(handles.c2,'string'));
% the spectral wavenumber values desired
c1t = str2double(get(handles.c1t,'string')); c2t = str2double(get(handles.c2t,'string'));
% optional spectral range for normalization (we haven't been using it)
c1n = str2double(get(handles.c1n,'string')); c2n = str2double(get(handles.c2n,'string'));
% read all of these into 'process'
process.processoptions.c1 = c1; process.processoptions.c2 = c2;
process.processoptions.c1t = c1t; process.processoptions.c2t = c2t;
process.wavenum = (process.processoptions.c1:2:process.processoptions.c2).';

normflag = get(handles.normonoff,'value');
if normflag == 1
    process.processoptions.c1n = c1n; process.processoptions.c2n = c2n;
    c1n = find(process.wavenum==c1n); c2n = find(process.wavenum==c2n);
end
c1t = find(process.wavenum==c1t); c2t = find(process.wavenum==c2t);
c1 = find(process.wavenum==c1); c2 = find(process.wavenum==c2);

if strcmp(get(handles.addlb,'string'),'-')==1
    addlb = [];
else
    addlb = load(get(handles.addlb,'string'));
    addlb = addlb.basis;
end

% fill out other 'process' values
process.processoptions.polyorder = str2double(get(handles.bkgdpolyorder,'string'));
process.processoptions.iter = str2double(get(handles.iter,'string'));
%process.processoptions.iter = 100; %CM 4/19

% cosmic ray value using mean absolute deviation
%  (ajb: not sure what this term means without further diving)
process.processoptions.crrmad = str2double(get(handles.crrmad,'string'));
process.processoptions.convergepercent = str2double(get(handles.convergepercent,'string'));
process.processoptions.peakremovalflag = get(handles.peakremovalflag,'value');
process.processoptions.noisefac = str2double(get(handles.noisefac,'string'));
process.processoptions.noisecalc = get(handles.noisecalc,'value');

tic
for jkl = 1:size(process.list,2)
    initprocess = load([process.filedirectory '/' process.list{jkl}]);
    process.laserwavelength{jkl} = initprocess.process.laserwavelength;
    process.wavelength{jkl} = (1./process.laserwavelength{jkl} - process.wavenum.*1E-7).^-1;
    %process.image{jkl}=initprocess.process.image;Keren image
    
    if isfield(initprocess.process,'saturated') == 1
        process.saturated(jkl) = initprocess.process.saturated;
    else
        process.saturated(jkl) = 0;
    end
    
    if process.saturated(jkl) == 0
        spec = interp1(initprocess.process.wavelength,initprocess.process.spec,process.wavelength{jkl},'spline');
        %-CM comment 12/13/2021
        %shotnoise = interp1(initprocess.process.wavelength,initprocess.process.shotnoise,process.wavelength{jkl},'spline');
        
% %-------------no longer using shot noise CM 12/13/2021
%         [process.spec(jkl),process.shotnoise(jkl),process.empiricalnoise(jkl)] = ...
%             CRRPolyFit(process.wavenum,spec,shotnoise ,...
%             process.processoptions.polyorder,c1,c2, ...
%             process.processoptions.crrmad,addlb);
%-------------------------- CM 12/13/2021
        [process.spec(jkl)] = ...
            CRRPolyFit(process.wavenum,spec,...
            process.processoptions.polyorder,c1,c2, ...
            process.processoptions.crrmad,addlb);
        
        
        
        if get(handles.svgsmoothonoff,'value') == 1 % Smoothing
            process.processoptions.SVGsmooth = 'on';
            process.processoptions.SVGsmoothpolyorder = ...
                str2double(get(handles.smoothpolyorder,'string')); % Polynomial Order;
            process.processoptions.SVGsmoothwindowsize = ...
                str2double(get(handles.smoothwindowsize,'string')); % Window Size;
            for nop = 1:size(process.spec{jkl},2)
                process.spec{jkl}(:,nop) = SvgSmoothJ( ...
                    process.processoptions.SVGsmoothpolyorder, ...
                    process.processoptions.SVGsmoothwindowsize, ...
                    process.spec{jkl}(:,nop));
                    
            end
        else
            process.processoptions.SVGsmooth = 'off';
            process.processoptions.SVGsmoothpolyorder = [];
            process.processoptions.SVGsmoothwindowsize = [];
        end
    else
        process.spec{jkl} = nan([length(process.wavelength{jkl}),40]);
        process.shotnoise{jkl} = process.spec{jkl}; %unsure CM 12/13
        process.empiricalnoise{jkl} = process.spec{jkl}; %unsure CM 12/13
    end
    
    %-not needed already have legs for offsets CM 12/13/2021
%     [process.specradii{jkl},process.shotnoiseradii{jkl},process.empiricalnoiseradii{jkl}] = ...
%         ConvertFiberDataRadii(process.spec{jkl},process.shotnoise{jkl},process.empiricalnoise{jkl});
%     
    if process.processoptions.noisecalc == 1
        [process.anitaspec{jkl}] = IanitaJ(process.wavenum, ...
            process.spec{jkl},process.processoptions.polyorder, ...
            c1,c2,process.processoptions.iter,addlb, ...
            process.processoptions.convergepercent, ...
            process.processoptions.peakremovalflag, ...
            process.processoptions.noisefac);
        
        %-not needed CM 12/13/2021
%         [process.anitaspecradii{jkl}] = IanitaJ(process.wavenum, ...
%             process.specradii{jkl},process.processoptions.polyorder, ...
%             c1,c2,process.processoptions.iter,addlb, ...
%             process.processoptions.convergepercent, ...
%             process.processoptions.peakremovalflag, ...
%             process.processoptions.noisefac);
    else
        
        %no shot noise CM 12/13/2021
%         [process.anitaspec{jkl}] = IanitaJ(process.wavenum, ...
%             process.spec{jkl},process.processoptions.polyorder, ...
%             c1,c2,process.processoptions.iter,addlb, ...
%             process.processoptions.convergepercent, ...
%             process.processoptions.peakremovalflag, ...
%             process.processoptions.noisefac, ...
%             process.shotnoise{jkl});
        
            % anita processing
            [process.anitaspec{jkl}] = IanitaJ(process.wavenum, ...
            process.spec{jkl},process.processoptions.polyorder, ...
            c1,c2,process.processoptions.iter,addlb, ...
            process.processoptions.convergepercent, ...
            process.processoptions.peakremovalflag, ...
            process.processoptions.noisefac); %CM 12/13/2021
        
        %not needed CM 12/13/2021
%         [process.anitaspecradii{jkl}] = IanitaJ(process.wavenum, ...
%             process.specradii{jkl},process.processoptions.polyorder, ...
%             c1,c2,process.processoptions.iter,addlb, ...
%             process.processoptions.convergepercent, ...
%             process.processoptions.peakremovalflag, ...
%             process.processoptions.noisefac, ...
%             process.shotnoiseradii{jkl});
    end
    
    % Normalization
    if normflag == 1
        process.processoptions.normalization = 'not yet operational';
    else
        process.processoptions.normalization = 'off';
    end
    [hours, minutes, seconds] = RemainingTimeJ(jkl,size(process.list,2));
    minutes = minutes+hours.*60;
    set(handles.finalprocessstatus,'string',['Status: Processing Data... ' ...
        num2str(minutes) ' min ' num2str(seconds) ' sec remaining']); pause(1E-6)
end

% tempprocess = process;
% fields{1} = 'spec'; fields{2} = 'shotnoise'; fields{3} = 'wavenum';
% fields{4} = 'wavelength'; fields{5} = 'list'; fields{6} = 'anitaspec';
% fields{7} = 'specradii'; fields{8} = 'anitaspecradii'; fields{9} = 'empiricalnoise';
% process = rmfield(process,fields);

clearvars -except handles process c1 c2 c1t c2t addlb

% Calculate mean spectrum and shotnoise

process.meanspec = cell2mat(cellfun(@mean,process.spec, ...
    num2cell(ones(size(process.spec)).*2),'uniformoutput',0));

%---------CM 12/13/2021
% %specnum = cell2mat(cellfun(@size,process.shotnoise, ...
%     num2cell(ones(size(process.shotnoise)).*2),'uniformoutput',0));
% 
%     process.meanshotnoise = cellfun(@power,process.shotnoise, ...
%     num2cell(ones(size(process.shotnoise)).*2),'uniformoutput',0);
% process.meanshotnoise = cell2mat(cellfun(@sum,process.meanshotnoise, ...
%     num2cell(ones(size(process.meanshotnoise)).*2),'uniformoutput',0));
% process.meanshotnoise = repmat(1./specnum,size(process.meanshotnoise,1),1).*sqrt(process.meanshotnoise);
% 
% process.meanempiricalnoise = cellfun(@power,process.empiricalnoise, ...
%     num2cell(ones(size(process.empiricalnoise)).*2),'uniformoutput',0);
% process.meanempiricalnoise = cell2mat(cellfun(@sum,process.meanempiricalnoise, ...
%     num2cell(ones(size(process.meanempiricalnoise)).*2),'uniformoutput',0));
% process.meanempiricalnoise = repmat(1./specnum,size(process.meanempiricalnoise,1),1).*sqrt(process.meanempiricalnoise);
%--------CM 12/13/2021

if process.processoptions.noisecalc == 1
    [process.meananitaspec] = IanitaJ(process.wavenum, ...
        process.meanspec,process.processoptions.polyorder, ...
        c1,c2,process.processoptions.iter,addlb, ...
        process.processoptions.convergepercent, ...
        process.processoptions.peakremovalflag, ...
        process.processoptions.noisefac);
else
    %---CM 12/13/2021
%     [process.meananitaspec] = IanitaJ(process.wavenum, ...
%         process.meanspec,process.processoptions.polyorder, ...
%         c1,c2,process.processoptions.iter,addlb, ...
%         process.processoptions.convergepercent, ...
%         process.processoptions.peakremovalflag, ...
%         process.processoptions.noisefac, ...
%         process.meanshotnoise);

        [process.meananitaspec] = IanitaJ(process.wavenum, ...
        process.meanspec,process.processoptions.polyorder, ...
        c1,c2,process.processoptions.iter,addlb, ...
        process.processoptions.convergepercent, ...
        process.processoptions.peakremovalflag, ...
        process.processoptions.noisefac); %CM 12/13/2021
end

% Cropping
for jkl = 1:length(process.list)
    process.spec{jkl} = process.spec{jkl}(c1t:c2t,:);
    %process.specradii{jkl} = process.specradii{jkl}(c1t:c2t,:);   %CM
    %12/13/2021
    
    process.anitaspec{jkl} = process.anitaspec{jkl}(c1t:c2t,:);
    %process.anitaspecradii{jkl} = process.anitaspecradii{jkl}(c1t:c2t,:);
    %CM 12/13/2021
    
    %process.shotnoise{jkl} = process.shotnoise{jkl}(c1t:c2t,:); %CM
    %12/13/2021
    
    %process.empiricalnoise{jkl} = process.empiricalnoise{jkl}(c1t:c2t,:);
    %CM 12/13/2021
    %process.shotnoiseradii{jkl} = process.shotnoiseradii{jkl}(c1t:c2t,:);
    %CM 12/13/2021
    
    %process.empiricalnoiseradii{jkl} =
    %process.empiricalnoiseradii{jkl}(c1t:c2t,:); %CM 12/13/2021
    process.wavelength{jkl} = process.wavelength{jkl}(c1t:c2t);
end
process.meanspec = process.meanspec(c1t:c2t,:);
%process.meanshotnoise = process.meanshotnoise(c1t:c2t,:); %CM 12/13/2021
%process.meanempiricalnoise = process.meanempiricalnoise(c1t:c2t,:); %CM
%12/13/2021
process.meananitaspec = process.meananitaspec(c1t:c2t,:);
process.wavenum = process.wavenum(c1t:c2t);
process.list = process.list;

axes(handles.previousstep); cla;
plotR(process.wavenum,process.meanspec./ ...
    repmat(sum(process.meanspec),size(process.meanspec,1),1));
axes(handles.currentstep); cla;
plotR(process.wavenum,process.meananitaspec./ ...
    repmat(mad(process.meananitaspec),size(process.meananitaspec,1),1));

prompt={'Comment:'};
name='Comment';
defaultanswer={'none'};
comment=inputdlg(prompt,name,1,defaultanswer);
process.comment = comment;
process = orderfields(process);
process.processoptions = orderfields(process.processoptions);
uisave('process')

set(handles.finalprocessstatus,'string','Status: Ready');


function [specout,shotnoiseout,empiricalnoiseout] = ...
    ConvertFiberDataRadii(specin,shotnoisein,empiricalnoisein)

% 5 radii
% % % ind{1} = 19;
% % % ind{2} = [1 2 4 8 16 17];
% % % ind{3} = [3 5 6 7 9 10 11 12 13 14 15 18];
% % % ind{4} = [20 24 27 29 31 32 33 37 38 40];
% % % ind{5} = [21 22 23 25 26 28 30 34 35 36 39];

% 3 radii
ind{1} = [1 2 4 8 16 17 19];
ind{2} = [3 5 6 7 9 10 11 12 13 14 15 18];
ind{3} = 20:40;

% % % 3 radii
% % % ind{1} = 19;
% % % ind{2} = [1:19 20 24 27 29 31 32 33 37 38 40];
% % % ind{3} = [21 22 23 25 26 28 30 34 35 36 39];

% % % 3 radii
% % % ind{1} = 19;
% % % ind{2} = 1:18;
% % % ind{3} = 20:40;

% % % 2 radii
% ind{1} = [1 2 4 8 16 17 19];
% ind{2} = [3 5 6 7 9 10 11 12 13 14 15 18 20:40];

specout = zeros(size(specin,1),size(ind,2));
shotnoiseout = zeros(size(specin,1),size(ind,2));
empiricalnoiseout = zeros(size(specin,1),size(ind,2));

for ijk = 1:size(ind,2)
    normfac = size(specin(:,ind{ijk}),2);
    specout(:,ijk) = sum(specin(:,ind{ijk}),2)./normfac;
    shotnoiseout(:,ijk) = sqrt(sum(shotnoisein(:,ind{ijk}).^2,2))./normfac;
    empiricalnoiseout(:,ijk) = sqrt(sum(empiricalnoisein(:,ind{ijk}).^2,2))./normfac;
end

% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in normonoff.
function normonoff_Callback(hObject, eventdata, handles)
% hObject    handle to normonoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value') == 1
    set(handles.c1n,'enable','on'); set(handles.c2n,'enable','on');
else
    set(handles.c1n,'enable','off'); set(handles.c2n,'enable','off');
end
% Hint: get(hObject,'Value') returns toggle state of normonoff



function c1n_Callback(hObject, eventdata, handles)
% hObject    handle to c1n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c1n as text
%        str2double(get(hObject,'String')) returns contents of c1n as a double


% --- Executes during object creation, after setting all properties.
function c1n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c1n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c2n_Callback(hObject, eventdata, handles)
% hObject    handle to c2n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c2n as text
%        str2double(get(hObject,'String')) returns contents of c2n as a double


% --- Executes during object creation, after setting all properties.
function c2n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c2n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in removeoutlierspeconoff.
function removeoutlierspeconoff_Callback(hObject, eventdata, handles)
% hObject    handle to removeoutlierspeconoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of removeoutlierspeconoff



function smoothwindowsize_Callback(hObject, eventdata, handles)
% hObject    handle to smoothwindowsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothwindowsize as text
%        str2double(get(hObject,'String')) returns contents of smoothwindowsize as a double


% --- Executes during object creation, after setting all properties.
function smoothwindowsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothwindowsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function compilespecregexp_Callback(hObject, eventdata, handles)
% hObject    handle to compilespecregexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of compilespecregexp as text
%        str2double(get(hObject,'String')) returns contents of compilespecregexp as a double


% --- Executes during object creation, after setting all properties.
function compilespecregexp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compilespecregexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function convergepercent_Callback(hObject, eventdata, handles)
% hObject    handle to convergepercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of convergepercent as text
%        str2double(get(hObject,'String')) returns contents of convergepercent as a double


% --- Executes during object creation, after setting all properties.
function convergepercent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to convergepercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in peakremovalflag.
function peakremovalflag_Callback(hObject, eventdata, handles)
% hObject    handle to peakremovalflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of peakremovalflag



function iter_Callback(hObject, eventdata, handles)
% hObject    handle to iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iter as text
%        str2double(get(hObject,'String')) returns contents of iter as a double


% --- Executes during object creation, after setting all properties.
function iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noisefac_Callback(hObject, eventdata, handles)
% hObject    handle to noisefac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noisefac as text
%        str2double(get(hObject,'String')) returns contents of noisefac as a double


% --- Executes during object creation, after setting all properties.
function noisefac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noisefac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in noisecalc.
function noisecalc_Callback(hObject, eventdata, handles)
% hObject    handle to noisecalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns noisecalc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from noisecalc


% --- Executes during object creation, after setting all properties.
function noisecalc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noisecalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addlb.
function addlb_Callback(hObject, eventdata, handles)
% hObject    handle to addlb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.mat', 'Additional Library File');
if strcmp(num2str(filename),'0')==0
    set(hObject,'string',[pathname filename]);
else
    set(hObject,'string','-');
end

% --- Executes on button press in process.filedirectory.
function FileDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to process.filedirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.FileDirectory,'string',uigetdir('C:/Jason/Data', 'Select File Directory'))


% --- Executes during object creation, after setting all properties.
function initprocessstatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initprocessstatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%no longer using shot noise CM 12/13/2021
%bookmark CM 12/13/2021
%function [outspec,outnoise,outempnoise,cosray] = CRRPolyFit(wavelength,spec,shotnoise,order,c1,c2,mediandeviations,addlb)
function [outspec,outempnoise,cosray] = CRRPolyFit(wavelength,spec,order,c1,c2,mediandeviations,addlb)

% Initialize variables
if iscell(spec) == 0
    spect = spec; clear spec;
    spec{1} = spect; clear spect;
    
    %shotnoiset = shotnoise; clear shotnoise; %CM 12/13/2021
    %shotnoise{1} = shotnoiset; clear shotnoiset; %CM 12/13/2021
end
outspec = cell(size(spec)); outnoise = outspec;

for ijk = 1:size(spec,2)
    for jkl = 1:size(spec{ijk},2)
        rawspect = squeeze(spec{ijk}(:,jkl,:));
        %shott = squeeze(shotnoise{ijk}(:,jkl,:)); %CM 12/13/2021
        [spect] = IanitaJ(wavelength,rawspect,order,c1,c2,1,addlb);
        
        bkgd = rawspect-spect;
        mspec = repmat(median(spect,2),1,size(spect,2));
        medad = repmat(median(abs(spect-mspec),2),1,size(spect,2));
        cutoff = mspec+mediandeviations.*medad;
        
        % Determine indices of cosmic rays
        ind = spect>cutoff;
        ind(1:c1,:) = 0; ind(c2:end,:) = 0;
        
        cosray(ijk,jkl) = sum(ind(:));
        
        % Set cosmic rays to NaN
        spect(ind) = nan; %shott(ind) = nan; %CM 12/13/2021
        
        % sum frames
        outspect = size(spect,2).*nanmean(spect,2);
        outspec{ijk}(:,jkl) = outspect + sum(bkgd,2);
        %outnoise{ijk}(:,jkl) = sqrt(size(spect,2).*nanmean(shott.^2,2));
        %CM 12/13/2021
        
        outempnoise{ijk}(:,jkl) = sqrt(size(spect,2).*nanvar(spect,[],2));
    end
end



function bkgdpolyorder_Callback(hObject, eventdata, handles)
% hObject    handle to bkgdpolyorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bkgdpolyorder as text
%        str2double(get(hObject,'String')) returns contents of bkgdpolyorder as a double



function smoothpolyorder_Callback(hObject, eventdata, handles)
% hObject    handle to smoothpolyorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothpolyorder as text
%        str2double(get(hObject,'String')) returns contents of smoothpolyorder as a double

% --- Executes during object creation, after setting all properties.
function smoothpolyorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothpolyorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [peakind,peakheight] = PeakLocationsJ(xaxis,spec,peaknum,peakstripwindow,edgedist1,fitflag,dwin)
% function [peakind,peakheight] = PeakLocationsJ(xaxis,spec,peaknum,peakstripwindow,edgedist,fitflag)
% Pass empty xaxis to simply use pixel number.  peakstripwindow and
% edgedist are always in PIXELS independent of xaxis.
% Modified by Guanping Feng 03/12/2016
if exist('dwin','var') == 0 
    dwin = 1;
end
if exist('edgedist1','var') == 0 || peakstripwindow>edgedist1
    edgedist1 = peakstripwindow;
end
if exist('fitflag','var') == 0
    fitflag = 1;
end
if isempty(xaxis) == 1
    xaxis = (1:size(spec,1)).';
elseif size(xaxis,1) ~= size(spec,1)
    warning('xaxis is not the same size as the length of spec.  Setting xaxis equal to pixel number...')
    xaxis = 1:size(spec,1);
end
relzero = min(spec);

edgedist2 = (size(spec,1)-edgedist1);
ijk = 0; peakind = zeros(peaknum,1); peakheight = peakind;
while ijk<=peaknum-1
    ijk
    [~,peakindt] = max(spec);
    if peakindt <= edgedist1 || peakindt >= edgedist2
        spec(peakindt) = relzero;
    else
        peakwindow = (peakindt + (-peakstripwindow:peakstripwindow)).';
        if fitflag == 1
            [coeff,a,goodness] = GLFitJ(xaxis(peakwindow),spec(peakwindow),1); %%Find peaks with Guassian fitting
            ijk=ijk+1;
            peakind(ijk) = coeff.x01;
            peakheight(ijk) = coeff.H1;
            [~,tind]=max(spec(peakwindow));
            peakpos=peakwindow(tind);
        else
            [pkh,tind] = max(spec(peakwindow));  %%Find peaks with maxima Seeking
            peakpos=peakwindow(tind);
            if  pkh>spec(peakpos-2)&&pkh>spec(peakpos+2)
                ijk=ijk+1;
                if ijk>peaknum
                    break
                end
                peakheight(ijk)=pkh;
                peakind(ijk) = xaxis(peakwindow(tind));
            end
        end
        %Remove old peak which has been already found
        for iii=peakpos :length(spec)-1
            if  iii+dwin>=length(spec)
                spec(iii:end)=relzero;
                break
            elseif spec(iii)-spec(iii+dwin)>0
                spec(iii)=relzero;
            else
                break
            end
        end
        for iii=peakpos-1:-1:2
            if  iii-dwin<=1
                spec(1:iii)=relzero;
                break
            elseif spec(iii)-spec(iii-dwin)>0
                spec(iii)=relzero;
            else
                break           
            end
        end
    end
end
[peakind,ind] = sort(peakind);
peakheight = peakheight(ind);





function [c,OLSfit,components,residual] = OLSJ(spec,basis)
% function [c,OLSfit,components,residual] = OLSJ(spec,basis)
% Perform an ordinary least squares fit to a set of spectra with a matrix
% composed of the basis spectra for the fit.  The fit coefficients are
% returned in the matrix c.  OLSfit is the fit to each spectrum, and
% components is a cell array with each cell containing a matrix of the
% component spectra that make up the total fit.  All spectra are defined as
% COLUMN vectors.

% Not sure why I can't use basis instead of bT' below, but I get
% strange results when fitting small spectral regions if basis is used
bT = basis';
c = (bT*(bT'))\(bT*spec); % The fit coefficients
% c = basis\spec;
OLSfit = basis*c; % The computed fit
components = cell(1,size(c,2)); % Components that make up the fit
for ijk = 1:size(c,2)
    components{ijk} = basis*diag(c(:,ijk));
end
residual = spec-OLSfit; % Residual

function [specfit,area,areai] = GLEvalJ(x,coeff)
% Evaluate the Gaussian Lorentzian function with coefficients in coeff at
% the locations given in the vector x.  Also returns tbe area under the
% Gaussian Lorentzian curve.

tval = coeffvalues(coeff);
npeaks = round(length(tval)./4);

H = repmat(tval(1:npeaks),length(x),1);
M = repmat(tval(npeaks+1:2*npeaks),length(x),1);
w = repmat(tval(2*npeaks+1:3*npeaks),length(x),1);
x0 = repmat(tval(3*npeaks+1:4*npeaks),length(x),1);
x = repmat(x,1,npeaks);
specfit = (1-M).*H.*exp(-((x-x0)./w).^2.*4.*log(2)) + ...
    M.*H./(4.*((x-x0)./w).^2 + 1);

areas = sprintf(['(1-M(1,%d)).*H(1,%d).*4.*sqrt(pi).*w(1,%d).*log(2) + '...
    'M(1,%d).*H(1,%d).*pi.*w(1,%d)./2'],ones(1,6));
areai = zeros(npeaks,1); % Preallocate
areai(1) = eval(areas);
for ijk = 2:npeaks
    areas = ([areas sprintf([' + (1-M(1,%d)).*H(1,%d).*4.*sqrt(pi).*w(1,%d).*log(2) + '...
        'M(1,%d).*H(1,%d).*pi.*w(1,%d)./2'],ones(1,6).*ijk)]);
    areai(ijk) = eval(sprintf([' + (1-M(1,%d)).*H(1,%d).*4.*sqrt(pi).*w(1,%d).*log(2) + '...
        'M(1,%d).*H(1,%d).*pi.*w(1,%d)./2'],ones(1,6).*ijk));
end

area = eval(areas);

function [coeff,area,goodness,output] = GLFitJ(x,spec,npeaks)
% Performs a mixed Gaussian/Lorentzian Fit of a spectral region.  The
% Gaussian/Lorentzian fit is returned as a funciton of x, the spectral
% region to fit is spec, and the number of peaks used in the fit is npeaks.

% M = mixture (% Lorentzian) between 0 and 1
maxeval = 600E2; % 600 by default
functiontol = 1e-8; % 1e-6 by default
coeftol = 1e-8; % 1e-6 by default

% maxeval = 600; % 600 by default
% functiontol = 1e-6; % 1e-6 by default
% coeftol = 1e-6; % 1e-6 by default

stepsize = floor(length(x)./npeaks);
[he] = max(spec); ce = (x(1:stepsize:length(x))).'; ce = ce(1:npeaks);
wi = x(end)-x(1); Ms = 0.5; he = he./npeaks;

t = ones(1,npeaks);
fitinit = [t.*he t.*Ms t.*wi./2 t.*ce];
lower = [t.*0 t.*0 t.*0 t.*x(1)];
upper = [t.*3.*he.*npeaks t.*1 t.*wi t.*x(end)];

% Mixed Gaussian/Lorentzian Function (as defined by Thermo Scientific)
fn = sprintf(['(1-M%d).*H%d.*exp(-((x-x0%d)./w%d).^2.*4.*log(2)) + '...
    'M%d.*H%d./(4.*((x-x0%d)./w%d).^2 + 1)'],ones(1,8));
for ijk = 2:npeaks
    fn = ([fn ' + ' sprintf(['(1-M%d).*H%d.*exp(-((x-x0%d)./w%d).^2.*4.*log(2)) + '...
        'M%d.*H%d./(4.*((x-x0%d)./w%d).^2 + 1)'],ones(1,8).*ijk)]);
end

fitopt = fitoptions('Method','NonlinearLeastSquares','Startpoint',fitinit,...
    'Lower',lower,'Upper',upper,'MaxFunEvals',maxeval,'TolFun',functiontol,...
    'TolX',coeftol);
f = fittype(fn,'options',fitopt);
% Perform the Non Linear Least Squares Fit
[coeff,goodness,output] = fit(x,spec,f);
[specfit,area] = GLEvalJ(x,coeff);

% Optional Plotting Section
ploton = 0;
if ploton == 1
    figure(99); clf; hold on
    plot(x,spec)
    plot(coeff)
    plot(x,specfit,'k:')
    title(['Rsquared = ' num2str(goodness.rsquare) ...
        '  ::  Area under curve: ' num2str(area)])
    legend('Data','Total Fit','Fit Components')
    pause;
end


function [coeff,area,goodness,output,basis] = GFitFiberBasisJ(x,spec,npeaks,ce,he)
% Performs a Gaussian Lorentzian Fit of a spectral region.  The
% Gaussian fit is returned as a funciton of x, the spectral
% region to fit is spec, and the number of peaks used in the fit is npeaks.

% M = mixture (% Lorentzian) between 0 and 1
maxeval = 10000; % 600 by default
functiontol = 1e-11; % 1e-6 by default
coeftol = 1e-11; % 1e-6 by default

maxeval = 600; % 600 by default
functiontol = 1e-6; % 1e-6 by default
coeftol = 1e-6; % 1e-6 by default


% Temporary
ce = ce.'; he = he.';
t = ones(1,npeaks);
fitinit = [t.*he t.*3.5 t.*ce];
lower = [t.*0 t.*2.5 t.*(ce-1)];
upper = [t.*3.*he t.*6 t.*(ce+1)];

% Note: Never chooses Lorentzian if I do mixed Gaussian Lorentzian
% Gaussian Function
fn = sprintf('H%d.*exp(-((x-x0%d)./w%d).^2.*4.*log(2))',ones(1,3));
for ijk = 2:npeaks
    fn = ([fn ' + ' sprintf('H%d.*exp(-((x-x0%d)./w%d).^2.*4.*log(2))',ones(1,3).*ijk)]);
end

fitopt = fitoptions('Method','NonlinearLeastSquares','Startpoint',fitinit,...
    'Lower',lower,'Upper',upper,'MaxFunEvals',maxeval,'TolFun',functiontol,...
    'TolX',coeftol);
f = fittype(fn,'options',fitopt);
% Perform the Non Linear Least Squares Fit
[coeff,goodness,output] = fit(x,spec,f);
[basis,area,areai] = GEvalJ(x,coeff);
basis = fliplr(basis);

% Optional Plotting Section
ploton = 0;
if ploton == 1
    figure(99); clf; hold on
    plot(x,spec)
    plot(coeff)
    plot(x,basis','k:')
    title(['R^{2} = ' num2str(goodness.rsquare) ...
        '  ::  Area under curve: ' num2str(area)])
    legend('Data','Total Fit','Fit Components')
    pause;
end

function [specfit,area,areai] = GEvalJ(x,coeff)
% Evaluate the Gaussian function with coefficients in coeff at
% the locations given in the vector x.  Also returns tbe area under the
% Gaussian curve.  areai is the area of each individual peak.

tval = coeffvalues(coeff);
npeaks = round(length(tval)./3);

H = repmat(tval(1:npeaks),length(x),1);
w = repmat(tval(1*npeaks+1:2*npeaks),length(x),1);
x0 = repmat(tval(2*npeaks+1:3*npeaks),length(x),1);
x = repmat(x,1,npeaks);
specfit = H.*exp(-((x-x0)./w).^2.*4.*log(2));

areas = sprintf('H(1,%d).*4.*sqrt(pi).*w(1,%d).*log(2)',ones(1,2));
areai = zeros(npeaks,1); % Preallocate
areai(1) = eval(areas);
for ijk = 2:npeaks
    areas = ([areas sprintf(' + H(1,%d).*4.*sqrt(pi).*w(1,%d).*log(2)',ones(1,2).*ijk)]);
    areai(ijk) = eval(sprintf('H(1,%d).*4.*sqrt(pi).*w(1,%d).*log(2)',ones(1,2).*ijk));
end

area = eval(areas);


function [hours, minutes, seconds] = RemainingTimeJ(curriter,totiter)
t = toc;
remainiter = totiter-curriter;
t = t.*remainiter./curriter;
hours = floor(t./3600); t = t-hours.*3600;
minutes = floor(t./60); t = t-minutes.*60;
seconds = round(t);
fprintf([num2str(curriter) ' of ' num2str(totiter) ' - Remaining Time: ' num2str(hours) ' hours ' ...
    num2str(minutes) ' minutes ' num2str(seconds) ...
    ' seconds\n']);


function [spec,components] = IanitaJ(wavelength,spec,order,c1,c2,iter,addlb,convergepercent,peakremovalflag,noisefac,noise)
% Improved automated fluorescence subtraction from Raman spectra
%
% [fitspec,components] = IanitaJ(wavelength,spec,order,c1,c2,iter)
% fitspec: spectrum after fluorescence background subtraction;
% wavelength: wavelength values of measured spectrum; spec: input spectrum;
% order: polynomial order for the fit; c1, c2: fitting region;
% iter: maximum number of iterations
%
% [fitspec,components] = IanitaJ(wavelength,spec,order,c1,c2,iter,addlb)
% addlb: additional spectra to include in the basis set for the fit, use []
% for no additional spectra
%
% [fitspec,components] = IanitaJ(wavelength,spec,order,c1,c2,iter,addlb,convergepercent,peakremovalflag,noisefac,noise)
% convergepercent: stops iterating if percent change in standard deviation
% of residual is less than converge percent; peakremovalflag: set to 1 in
% order to attempt removal of Raman peaks before fitting; noisefac: number
% of standard deviations in noise to permit below zero intensity
% noise: noise at each pixel (same dimension as spec), if noise is not
% passed, IanitaJ makes an estimate of the noise based upon the
% standard deviation of the residual of the fit
%
% Defaults: addlb = []; convergepercent = 5E-4; peakremovalflag = 0; noisefac = 0;
%
% Modeled after 'Automated Autofluorescence Background Subtraction Algorithm
% for Biomedical Raman Spectroscopy' by Zhao et al.
% JRM 11/19/10

% Number of standard deviations in noise to permit below zero intensity
if exist('noisefac','var') == 0
    noisefac = 0; % noisefac = 0 performs a conventional ANITA fit
end
if exist('peakremovalflag','var')==0
    peakremovalflag = 0; % peakremovalflag = 1 attempts to remove Raman peaks before fitting
end
% Convergence Condition
if exist('convergepercent','var') == 0
    convergepercent = 5E-4;
end
if exist('noise','var') == 1
    noiseflag = 1;
else
    noiseflag = 0;
end

% Create Polynomials to Use in Basis
px = (wavelength-mean(wavelength))./std(wavelength);
% Initialize polynomial matrix
polyb = zeros(size(spec,1),order+1);
% Values range from 1 to 2^order
for j=0:1:order
    polyb(:,j+1)=px.^j;
end

% Add additional Basis Vectors
if exist('addlb','var') == 1
    basis = [polyb addlb];
else
    basis = polyb;
end

% For each spectrum
for jkl = 1:size(spec,2)
    putin = spec(c1:c2,jkl); reducedbasis = basis(c1:c2,:);
    
    % Perform the Ordinary Least Squares Fit Between c1 and c2
    [~,putout,~,residual] = OLSJ(putin,reducedbasis);
    DEV = std(residual);
    
    % Raman peak removal
    if noiseflag == 1
        noisecorrection = noise(c1:c2,jkl);
        if peakremovalflag == 1
            noremoval = (putin<(putout+3.*noisecorrection));
            noisecorrection = noisecorrection(noremoval);
        end
    elseif peakremovalflag == 1
        noremoval = (putin<(putout+3.*DEV));
    end
    if peakremovalflag == 1
        reducedbasis = reducedbasis(noremoval,:);
        putin = putin(noremoval);
        if isreal(putin) == 0
            pause;
        end
    end
    
    % 1st iteration
    % Perform the Ordinary Least Squares Fit Between c1 and c2
    [c,~,components,residual] = OLSJ(putin,reducedbasis);
    DEVlast = std(residual);
    
    if noiseflag ~= 1 % Estimate noise as DEV
        noisecorrection = DEVlast;
    end
    
    % Reasign fit values that would result in negative spectral
    % intensity
    residualcorrection = residual-noisefac.*noisecorrection;
    cutoff = (residualcorrection+abs(residualcorrection))./2;
    
    putin = putin - cutoff;
    
    for ijk = 2:iter % For each iteration
        % Perform the Ordinary Least Squares Fit Between c1 and c2
        [c,~,components,residual] = OLSJ(putin,reducedbasis);
        
        % Calculate the standard deviation of the residual
        DEV = std(residual);
        
        differ = abs((DEV-DEVlast)./DEV);
        % If the difference is small break from the loop
        if differ < convergepercent
            break
        end
        DEVlast = DEV;
        
        if noiseflag ~= 1 % Estimate noise as DEV
            noisecorrection = DEV;
        end
        
        % Reasign fit values that would result in negative spectral
        % intensity
        residualcorrection = residual-noisefac.*noisecorrection;
        cutoff = (residualcorrection+abs(residualcorrection))./2;
        
        putin = putin - cutoff;
    end % of for each iteration
    
    % Subtract estimated fluorescence lineshape
    spec(:,jkl) = spec(:,jkl) - basis*c;
end % of for each spectrum


function Smooth = SvgSmoothJ(M,n,Spec)
% Author: Jeff Rice
% Date: 7-17-02
% Smooth a given spectrum using a Sovitsky-Golay filter
% This function accepts an input spectrum and applies a Sovitsky-Golay filter to it,
% returning the smoothed spectrum
% "M" is the order of the Savitsky-Golay filter
% "n" is the number of data points fit on each side of the point of interest
% i.e. the total number of points fit is 2n+1


Spec = Spec'; %JRM

A1 = [-n:n];                % create a row vector with values -n,-n+1,....n
%     A1 = A1./std(A1); normalize as well??
A = ones(M+1,2*n+1);        % actually it's A transpose.

for j = 1:M,
    A(j+1,:) = A(j,:).*A1;  % fill the second row of A with A1*A1 or A1^2, etc.
end

P = A*A';                   % If A is A(but not its transpose), here it should be P = A'*A;
Inv = inv(P);

% c= zeros(1,n);
C = zeros(1,2*n+1);         % form C, a row vector to store coefficients

for I = 1:n;                % form I, a vector of n^m where m = 0,1,...M
    K = ones(M+1,1);
    
    for J = 1:M,
        K(J+1) = K(J)*I;
    end
    
    %     c(I) = Inv(1,:)*K;
    c = Inv(1,:)*K;
    C(n+1+I) = c;
    C(n+1-I) = c;
end

C(n+1) = Inv(1,1);

Spec1 = [zeros(1,n)+Spec(1) Spec zeros(1,n)+Spec(end)];
Smooth = conv(Spec1,C);
Smooth = Smooth(2*n+1:(end-2*n));
Smooth = Smooth'; %JRM


function [cs,index] = sort_nat(c)
%sort_nat: Natural order sort of cell array of strings.
% usage:  [S,INDEX] = sort_nat(C)
%
% where,
%    C is a cell array (vector) of strings to be sorted.
%    S is C, sorted in natural order.
%    INDEX is the sort order such that S = C(INDEX);
%
% Natural order sorting sorts strings containing digits in a way such that
% the numerical value of the digits is taken into account.  It is
% especially useful for sorting file names containing index numbers with
% different numbers of digits.  Often, people will use leading zeros to get
% the right sort order, but with this function you don't have to do that.
% For example, if C = {'file1.txt','file2.txt','file10.txt'}, a normal sort
% will give you
%
%       {'file1.txt'  'file10.txt'  'file2.txt'}
%
% whereas, sort_nat will give you
%
%       {'file1.txt'  'file2.txt'  'file10.txt'}
%
% See also: sort

% Version: 1.2, 5 November 2008
% Author:  Douglas M. Schwarz
% Email:   dmschwarz=ieee*org, dmschwarz=urgrad*rochester*edu
% Real_email = regexprep(Email,{'=','*'},{'@','.'})


% Replace runs of digits with '0'.
c2 = regexprep(c,'\d+','0');

% Compute char version of c2 and locations of zeros.
s1 = char(c2);
z = s1 == '0';

% Extract the runs of digits and their start and end indices.
[digruns,first,last] = regexp(c,'\d+','match','start','end');

% Create matrix of numerical values of runs of digits and a matrix of the
% number of digits in each run.
num_str = length(c);
max_len = size(s1,2);
num_val = NaN(num_str,max_len);
num_dig = NaN(num_str,max_len);
for i = 1:num_str
    num_val(i,z(i,:)) = sscanf(sprintf('%s ',digruns{i}{:}),'%f');
    num_dig(i,z(i,:)) = last{i} - first{i} + 1;
end

% Find columns that have at least one non-NaN.  Make sure activecols is a
% 1-by-n vector even if n = 0.
activecols = reshape(find(~all(isnan(num_val))),1,[]);
n = length(activecols);

% Compute which columns in the composite matrix get the numbers.
numcols = activecols + (1:2:2*n);

% Compute which columns in the composite matrix get the number of digits.
ndigcols = numcols + 1;

% Compute which columns in the composite matrix get chars.
charcols = true(1,max_len + 2*n);
charcols(numcols) = false;
charcols(ndigcols) = false;

% Create and fill composite matrix, comp.
comp = zeros(num_str,max_len + 2*n);
comp(:,charcols) = double(s1);
comp(:,numcols) = num_val(:,activecols);
comp(:,ndigcols) = num_dig(:,activecols);

% Sort rows of composite matrix and use index to sort c.
[unused,index] = sortrows(comp);
cs = c(index);


function h = plotR(x,y,errorpatch,varargin)
% function plotR(x,y,errorpatch,varargin)
% Plots a Raman spectrum with common labels

% Defaults
fontsizelabel = 8;
fontsizeaxis = 8;
fontweight = 'bold';

h = plot(x,y,varargin{:},'DisplayName','y');
if exist('errorpatch','var') == 1
    if isempty(errorpatch) == 0
        if size(errorpatch,3)>1
            errorpatchL = squeeze(errorpatch(:,:,1));
            errorpatchU = squeeze(errorpatch(:,:,2));
        else
            errorpatchL = errorpatch;
            errorpatchU = errorpatch;
        end
        
        xp = [x; flipud(x)];
        for ijk = 1:size(h,1)
            linecol = get(h(ijk),'color');
            
            delete(h(ijk));
            yp = [y(:,ijk) + errorpatchU(:,ijk); flipud(y(:,ijk) - errorpatchL(:,ijk))];
            
            linecol = linecol+0.75; linecol(linecol>1) = 1;
            patch(xp,yp,linecol,'EdgeColor','none'); hold on;
            
            %             patch(xp,yp,linecol,'EdgeColor','none'); hold on
        end
        h = plot(x,y,varargin{:},'DisplayName','y');
    end
    
end
xlabel('Raman shift / cm^{-1}','fontsize',fontsizelabel,'fontweight',fontweight)
ylabel('Raman intensity / a.u.','fontsize',fontsizelabel,'fontweight',fontweight)
set(gca,'Ytick',[],'fontsize',fontsizeaxis,'layer','top','linewidth',0.75)
axis tight; box off;
yt = ylim; yrange = range(yt);
yt(1) = yt(1)-yrange.*0.05; yt(2) = yt(2)+yrange.*0.05; ylim(yt);








