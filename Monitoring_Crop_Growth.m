function varargout = Monitoring_Crop_Growth(varargin)
% MONITORING_CROP_GROWTH MATLAB code for Monitoring_Crop_Growth.fig
%      MONITORING_CROP_GROWTH, by itself, creates a new MONITORING_CROP_GROWTH or raises the existing
%      singleton*.
%
%      H = MONITORING_CROP_GROWTH returns the handle to a new MONITORING_CROP_GROWTH or the handle to
%      the existing singleton*.
%
%      MONITORING_CROP_GROWTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MONITORING_CROP_GROWTH.M with the given input arguments.
%
%      MONITORING_CROP_GROWTH('Property','Value',...) creates a new MONITORING_CROP_GROWTH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Monitoring_Crop_Growth_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Monitoring_Crop_Growth_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Monitoring_Crop_Growth

% Last Modified by GUIDE v2.5 26-Dec-2015 12:43:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Monitoring_Crop_Growth_OpeningFcn, ...
    'gui_OutputFcn',  @Monitoring_Crop_Growth_OutputFcn, ...
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


% --- Executes just before Monitoring_Crop_Growth is made visible.
function Monitoring_Crop_Growth_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Monitoring_Crop_Growth (see VARARGIN)

% Choose default command line output for Monitoring_Crop_Growth
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Monitoring_Crop_Growth wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Monitoring_Crop_Growth_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Filename, Pathname] = uigetfile({'*.jpg';'*.png';'*.bmp';'*.*'},'Select the test image');
try
    orig_img = imread([Pathname,'\',Filename]);
catch
    msgbox('No file selected');
    return;
end

axes(handles.oriimage);
imshow(orig_img);
title('Original Crop Image');

handles.orig_img = orig_img;
guidata(hObject,handles);


% --- Executes on button press in noiseremove.
function noiseremove_Callback(hObject, eventdata, handles)
% hObject    handle to noiseremove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
orig_img = handles.orig_img;

if ndims(orig_img) < 3
    msgbox('Image is not an RGB image');
    return;
end

h = waitbar(1/3,'Gaussian Noise Removal');
%Removing Gaussian Noise
gaussfree_img = NoiseRemoval(orig_img);

%Removing other noise using Adaptive median filtering
h = waitbar(2/3,h,'Adaptive Median Filtering');
noisefree_img = adpmedian(gaussfree_img,3);

h = waitbar(3/3,h,'Process Complete');

axes(handles.noiserem);
imshow(noisefree_img);
title('Noiseless Image');

pause(2);
close(h);

handles.noisefree_img = noisefree_img;
guidata(hObject,handles);


% --- Executes on button press in analyzeplots.
function analyzeplots_Callback(hObject, eventdata, handles)
% hObject    handle to analyzeplots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
col_mean_r = handles.col_mean_r;
col_mean_g = handles.col_mean_g;
col_mean_b =handles.col_mean_b;

figure;
plot(col_mean_r); title('Column wise mean : Red'); xlabel('Pixels'); ylabel('Pixel Value');

figure;
plot(col_mean_g); title('Column wise mean : Green'); xlabel('Pixels'); ylabel('Pixel Value');

figure;
plot(col_mean_b); title('Column wise mean : Blue'); xlabel('Pixels'); ylabel('Pixel Value');

% --- Executes on button press in colorextract.
function colorextract_Callback(hObject, eventdata, handles)
% hObject    handle to colorextract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
noisefree_img = handles.noisefree_img;

if ndims(noisefree_img) < 3
    msgbox('Image is not an RGB image');
    return;
end

[img_redchannel,img_greenchannel,img_bluechannel] = ...
    extractcolourchannels(noisefree_img);
[col_mean_r,col_mean_g,col_mean_b, mean_r,mean_g,mean_b] = ...
    calculatecolourmean(img_redchannel,img_greenchannel,img_bluechannel);

axes(handles.greenimg);
imshow(img_greenchannel);
title('Green Channel Image');

%Green percentage
per_green = (mean_g*100)/(mean_r+mean_g+mean_b);

set(handles.agetext,'Visible','on');

if per_green < 34
    set(handles.agetext,'String','Age of the crop is 18 weeks or older');
elseif per_green < 40
    set(handles.agetext,'String','Age of the crop is approximately 14 weeks');
elseif per_green < 50
    set(handles.agetext,'String','Age of the crop is approximately 10 weeks');
else
    set(handles.agetext,'String','Age of the crop is close to 6 weeks');
end

handles.col_mean_r = col_mean_r;
handles.col_mean_g = col_mean_g;
handles.col_mean_b = col_mean_b;
handles.mean_r = mean_r;
handles.mean_g = mean_g;
handles.mean_b = mean_b;
handles.per_green = per_green;
guidata(hObject,handles);

% --- Executes on button press in rgb2hsi.
function rgb2hsi_Callback(hObject, eventdata, handles)
% hObject    handle to rgb2hsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
noisefree_img = handles.noisefree_img;
[H,S,I,hsi] = rgb2hsi(noisefree_img);

handles.hue = H;
handles.sat = S;
handles.inten = I;

set(handles.infotable,'Visible','on');

mean_r = handles.mean_r;
mean_g = handles.mean_g;
mean_b = handles.mean_b;
per_green = handles.per_green;

% Merging data for the table.

info{1,1} ='Mean of Red colour present';
info{2,1} ='Mean of Green colour present';
info{3,1} ='Mean of Blue colour present';
info{4,1} ='Percentage of green colour';
info{5,1} ='Hue(H)';
info{6,1} ='Saturation(S)';
info{7,1} ='Intensity(I)';

info{1,2} = mean_r;
info{2,2} = mean_g;
info{3,2} = mean_b;
info{4,2} = [num2str(per_green),'%'];
info{5,2} = mean(mean(H));
info{6,2} = mean(mean(S));
info{7,2} = mean(mean(I));

set(handles.infotable,'Data',info);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.oriimage); cla(handles.oriimage); title('');
axes(handles.greenimg); cla(handles.greenimg); title('');
axes(handles.noiserem); cla(handles.noiserem); title('');
clear{1,1}=''; clear{1,2}='';
set(handles.infotable,'Data',clear);
set(handles.infotable,'Visible','off');
set(handles.agetext,'Visible','off');
