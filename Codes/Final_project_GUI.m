function varargout = Final_project_GUI(varargin)
% FINAL_PROJECT_GUI MATLAB code for Final_project_GUI.fig
%      FINAL_PROJECT_GUI, by itself, creates a new FINAL_PROJECT_GUI or raises the existing
%      singleton*.
%
%      H = FINAL_PROJECT_GUI returns the handle to a new FINAL_PROJECT_GUI or the handle to
%      the existing singleton*.
%
%      FINAL_PROJECT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL_PROJECT_GUI.M with the given input arguments.
%
%      FINAL_PROJECT_GUI('Property','Value',...) creates a new FINAL_PROJECT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Final_project_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Final_project_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Final_project_GUI

% Last Modified by GUIDE v2.5 01-Dec-2016 11:56:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Final_project_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Final_project_GUI_OutputFcn, ...
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


% --- Executes just before Final_project_GUI is made visible.
function Final_project_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Final_project_GUI (see VARARGIN)

% Choose default command line output for Final_project_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Final_project_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Final_project_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global STATE;

STATE.pop1 = 0;
STATE.pop2 = 16;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global STATE; 

% initialize the values for pops
set(handles.pushbutton2,'string', 'Ramblin On !!!');

set(handles.text1, 'string', 'Rupture Result Prediction:');
set(handles.text2, 'string', 'Aneurysm Result Prediction:');

%%%%%%%%%%%%%%%%%%%%% generates pop-up window for selecting image
[filename, pathname] = uigetfile({'*.*';'*.tif';'*.jpg';'*.jpeg';'*.png'},'Select an image');
imageName = [pathname,filename];
STATE.image = filename;

%%%%%%%%%%%%%%%%%%%%% reading image
STATE.rgb=imread(imageName);

%%%%%%%%%%%%%%%%%%%%% image axes
%%%%%%% selecting axes
axes(handles.axes1) ;
%%%%%%% clearing axes
cla;
%%%%%%% Displaying image
imshow(STATE.rgb);
STATE.image_number = str2num(filename(9:12));
title(['Input Image Index: '  filename(9:12)]);
set(gca,'FontSize',18)
%%%%%%% resizing axes to image size
axis([0 size(STATE.rgb,2) 0 size(STATE.rgb,1)]);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global STATE;

selected = get(handles.popupmenu1,'value');
switch selected
    case 1
        STATE.pop1 = 0; % 'Select Method';
    case 2
        STATE.pop1 = 1; % 'Supervised Method';
    case 3
        STATE.pop1 = 2; % 'Unsupervised Method';
    otherwise
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

%% For supervised method only
global STATE;

selected = get(handles.popupmenu2,'value');
switch selected
    case 1
        % Default value is 8 pixels
        STATE.pop2 = 16; %'Select Sample Size';
    case 2
        STATE.pop2 = 8; %'8 Pixels';
    case 3
        STATE.pop2 = 16; %'16 Pixels';
    case 4
        STATE.pop2 = 32; %'32 Pixels';
    otherwise
end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global STATE;

%% Determine which method is used
switch STATE.pop1
    case 0
        % Warning
        set(handles.text3, 'string', 'Error! Please Select Method!');
        set(handles.text4, 'string', 'Error! Please Select Method!');
    case 1
        % Unsupervised method
        [originalImage, segmentedImage, pseudoImage, flag_AAA, flag_rup] = kmeansImageSeg(STATE.rgb);
        flag_rup = 0;
    case 2
        % Supervised method
        block_size = STATE.pop2;
        [originalImage, segmentedImage, pseudoImage, flag_rup, flag_AAA] = supervisedImageSeg(STATE.rgb,block_size);
end

%% Output
if STATE.pop1 ~= 0
    if flag_rup == 1
        set(handles.text3, 'string', 'Ruptured');
        flag_AAA = 1;
    elseif flag_rup == 0
        set(handles.text3, 'string', 'Not Ruptured');
    end
    
    if flag_AAA == 1
        set(handles.text4, 'string', 'AAA');
    elseif flag_AAA == 0
        set(handles.text4, 'string', 'Not AAA');
    end
    
    
    % Segmented Image
    axes(handles.axes2) ;
    %%%%%%% clearing axes
    cla;
    %%%%%%% Displaying image
    imshow(segmentedImage);
    %%%%%%% resizing axes to image size
    axis([0 size(segmentedImage,2) 0 size(segmentedImage,1)]);
    title('Segmented Image');
    set(gca,'FontSize',18)
    
    
    % Pseudo Image
    
    axes(handles.axes3) ;
    %%%%%%% clearing axes
    cla;
    %%%%%%% Displaying image
    imshow(pseudoImage);
    %%%%%%% resizing axes to image size
    axis([0 size(pseudoImage,2) 0 size(pseudoImage,1)]);
    title('Pseudo Color Image');
    set(gca,'FontSize',18)

end


%% This section is for fun!
if STATE.pop1 ~= 0
    image_fun = imread('Buzz.jpg');
    title_name = 'Yes, we have made it !';
elseif STATE.pop1 == 0
    image_fun = imread('THWG.jpg');
    title_name = 'To Hell with Georgia!';
end

%%%%%%%%%%%%%%%%%%%%% image axes
%%%%%%% selecting axes
axes(handles.axes4) ;
%%%%%%% clearing axes
cla;
%%%%%%% Displaying image
imshow(image_fun);    
%%%%%%% resizing axes to image size
axis([0 size(image_fun,2) 0 size(image_fun,1)]);
title(title_name);
set(gca,'FontSize',18)
