function varargout = testGui(varargin)
% TESTGUI MATLAB code for testGui.fig
%      TESTGUI, by itself, creates a new TESTGUI or raises the existing
%      singleton*.
%
%      H = TESTGUI returns the handle to a new TESTGUI or the handle to
%      the existing singleton*.
%
%      TESTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTGUI.M with the given input arguments.
%
%      TESTGUI('Property','Value',...) creates a new TESTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% author     chiyeung
% Edit the above text to modify the response to help testGui

% Last Modified by GUIDE v2.5 10-Oct-2021 21:40:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testGui_OpeningFcn, ...
                   'gui_OutputFcn',  @testGui_OutputFcn, ...
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


% --- Executes just before testGui is made visible.
function testGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% author     chiyeung
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testGui (see VARARGIN)

% Choose default command line output for testGui
handles.output = hObject;
handles.videoFileName = [];
handles.videoData = [];
handles.videoOutput = [];
handles.Fs =[];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadingVideo.
function LoadingVideo_Callback(hObject, eventdata, handles)
% author     chiyeung
% hObject    handle to LoadingVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global audio_clip Fs Name
[Name, folder] = uigetfile('*.wav;*.mp3;*.ogg','Select a video clip');
filename = fullfile(folder, Name);
% clear sound;
[audio_clip,Fs] = audioread(filename);
Clip_info=audioinfo(filename);
ch=Clip_info.NumChannels;
len=Clip_info.TotalSamples;
set(handles.text4,'String',Name)
handles.Fs = Fs;
handles.videoFileName=filename;
handles.videoData = audio_clip;
% Update handles structure
guidata(hObject, handles);

% plot the input video
axes(handles.axes7);
stem(audio_clip)
title('Iutput Sound')




% --- Executes on button press in applyWindowFunc.
function applyWindowFunc_Callback(hObject, eventdata, handles)
% author     chiyeung
% hObject    handle to applyWindowFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global N fs Wp Ws TW cutoff hd_win_temp
%To begin with assume the frequency space is discretized into N samples. 
%N should be large but its value is flexible. 
N = 10001;
cutoff=(Wp+Ws)/2

%Digital frequencies associated with the digital filter obtained from
%sampling the analogue unit impulse response
Wp_n=round(Wp/(fs/N))
Ws_n=round(Ws/(fs/N))
cutoff_n=round(cutoff/(fs/N))

%On the digital frequency axis, the DC (0 Hz) is located at the midpoint of the
%frequency axis
DC=(N-1)/2+1; %Location of DC component (frequency=0)

% Step 1
%Generate the low-pass function in the digital frequency spectrum
%Gain in passband=1, phase is linear. Gain=0 at stopband
HD=zeros(1,N);
for i=DC-Wp_n:DC+Wp_n
    n=i-DC;
    f=n*2*pi/N;
    HD(i)=1;
end
t = linspace(0,N-1,N);
axes(handles.axes3);
stem(t,abs(HD))
title('Target frequency spectrum')

%Step 2
%Convert digital frequency spectrum to discrete unit impulse response
%using inverse FFT
HD=circshift(fftshift(HD),1);
hd=ifft(HD);
% t = linspace(0, N-1,N);
axes(handles.axes4);
stem(t,real(hd))
title('Target unit impulse response')

%step 3 base on which window the use has chosen left side
%Construct rectangular window function
Nwin=round(0.91*fs/TW);
value = get(handles.popupmenu1,'Value');
switch value
    case 2 % Retangular
        if mod(Nwin,2)==0
            Nwin=Nwin+1;
        end
        win=zeros(1,Nwin);
        for i=1:Nwin
            n=(i-1)-(Nwin-1)/2;
            win(i) = 1
        end
        
    case 3
        if mod(Nwin,2)==0
            Nwin=Nwin+1;
        end
        win=zeros(1,Nwin);
        for i=1:Nwin
            n=(i-1)-(Nwin-1)/2;
            win(i) = 0.5 + 0.5.* cos((2 * pi * n) / (Nwin -1));
        end
        
    case 4
        if mod(Nwin,2)==0
            Nwin=Nwin+1;
        end
        win=zeros(1,Nwin);
        for i=1:Nwin
            n=(i-1)-(Nwin-1)/2;
            win(i) = 0.54 + 0.46.* cos((2 * pi * n) / (Nwin -1));
        end
        
    case 5  %Blackman
        if mod(Nwin,2)==0
            Nwin=Nwin+1;
        end
        win=zeros(1,Nwin);
        for i=1:Nwin
            n=(i-1)-(Nwin-1)/2;
            win(i) = 0.42 + 0.5.* cos((2 * pi * n) / (Nwin -1)) +0.08.* cos((4 * pi * n) / (Nwin -1));
        end
end

%step 4 Apply window function to ideal impulse response
hd=fftshift(hd);
hd_win=zeros(1,N);
DC_win=(Nwin-1)/2;
hd_win(DC-DC_win:DC+DC_win)=hd(DC-DC_win:DC+DC_win).*win;
hd_win_temp(DC-DC_win:DC+DC_win)=hd(DC-DC_win:DC+DC_win).*win; 
% t = linspace(0, N-1,N);
axes(handles.axes5);
stem(t,abs(hd_win))
title('Windowed unit impulse response')

%Step 5 : get the frequency response of the windowed unit impulse response
hd_win=circshift(fftshift(hd_win),1);
HD_win=fft(hd_win);
%RES=abs(HD_win);
RES=fftshift(HD_win);
%RES=RES/max(RES(:));
% t = linspace(0, N-1,N);
axes(handles.axes6);
stem(t,abs(RES))
title('Spectrum of windowed unit impulse response')


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% author     ziyangOu
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global fs Wp Ws TW Nwin cutoff
fs=10000;   %Sampling frequency = 10kHz
Wp=300;                 %Pass band edge = 300Hz
Ws=400;                 %Stop band edge = 400Hz
cutoff=(Wp+Ws)/2        %Actual Pass band edge
TW=Ws-Wp                %Transition width

value = get(handles.popupmenu1,'Value');
switch value
    case 2 % Retangular
        Nwin=round(0.91*fs/TW);
        if mod(Nwin,2)==0
            Nwin=Nwin+1;
        end
        win=zeros(1,Nwin);
        for i=1:Nwin
            n=(i-1)-(Nwin-1)/2;
            win(i) = 1
        end
        t = linspace(0, Nwin-1,Nwin); 
        axes(handles.axes1);
        stem(t,win)
        title('Rectangular Window Function')
        
    case 3  %Hanning
        Nwin=round(3.32*fs/TW);
        if mod(Nwin,2)==0
            Nwin=Nwin+1;
        end
        win=zeros(1,Nwin);
        for i=1:Nwin
            n=(i-1)-(Nwin-1)/2;
            win(i) = 0.5 + 0.5.* cos((2 * pi * n) / (Nwin -1));
        end
        t = linspace(0, Nwin-1,Nwin);
        axes(handles.axes1);
        stem(t,win)
        title('Hanning Window Function')
        
    case 4 %Hamming
        Nwin=round(3.44*fs/TW);
        if mod(Nwin,2)==0
            Nwin=Nwin+1;
        end
        win=zeros(1,Nwin);
        for i=1:Nwin
            n=(i-1)-(Nwin-1)/2;
            win(i) = 0.54 + 0.46.* cos((2 * pi * n) / (Nwin -1));
        end
        t = linspace(0, Nwin-1,Nwin);
        axes(handles.axes1);
        stem(t,win)
        title('Hamming Window Function')
        
    case 5  %Blackman
        Nwin=round(5.98*fs/TW);
        if mod(Nwin,2)==0
            Nwin=Nwin+1;
        end
        win=zeros(1,Nwin);
        for i=1:Nwin
            n=(i-1)-(Nwin-1)/2;
            win(i) = 0.42 + 0.5.* cos((2 * pi * n) / (Nwin -1)) +0.08.* cos((4 * pi * n) / (Nwin -1));
        end
        t = linspace(0, Nwin-1,Nwin);
        axes(handles.axes1);
        stem(t,win)
        title('Blackman Window Function')
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% author     chiyeung
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


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


% --- Executes on button press in PlayOrigin.
function PlayOrigin_Callback(hObject, eventdata, handles)
% hObject    handle to PlayOrigin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global audio_clip Fs
sound(audio_clip,Fs)


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function filename_Callback(hObject, eventdata, handles)
global Name
% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
clear sound;
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);
cla(handles.axes5);
cla(handles.axes6);
cla(handles.axes7);
set(handles.text4,'String',[])
set(handles.popupmenu1,'Value',1)
clear all;

% --- Executes on button press in outputSound.
function outputSound_Callback(hObject, eventdata, handles)
global audio_lpf Fs
sound(audio_lpf,Fs)


% --- Executes on button press in Filtering.
function Filtering_Callback(hObject, eventdata, handles)
global hd_win_temp audio_clip audio_lpf
audio_lpf=conv(hd_win_temp,audio_clip);
% plot the output video
axes(handles.axes2);
stem(audio_lpf)
title('Output Sound')
