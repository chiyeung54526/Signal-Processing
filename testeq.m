function varargout = testeq(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testeq_OpeningFcn, ...
                   'gui_OutputFcn',  @testeq_OutputFcn, ...
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

function testeq_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;


guidata(hObject, handles);
function varargout = testeq_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function bass_Callback(hObject, eventdata, handles)
set(handles.text8,'String',get(handles.bass,'value'))

global Wp_n Ws_n hd_win_low audio_clip audio_lpf N audio_lpf_new
[DC,Wp_n,Ws_n,N,fs,TW]=initialization();
HD=lowpass_transfer_function(DC,Wp_n,N);
hd=unit_impulse_response(HD,N);             %Step 2: convert filter response to unit impulse response
[win Nwin]=hamming_window(fs,TW);%Step 3: generate hamming window function 使用汉明窗口滤波进行三段式均衡器 
hd_win_low=add_window(hd,win,DC,Nwin,N);         %Step 4: apply window function to unit impulse response
audio_lpf=conv(audio_clip,hd_win_low);
tmp1=get(handles.bass,'value');
tmp=tmp1*fft(audio_lpf);
audio_lpf_new=ifft(tmp);
function bass_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function midrange_Callback(hObject, eventdata, handles)

set(handles.text9,'String',get(handles.midrange,'value'))
global Wp_n Ws_n hd_win_band audio_clip audio_bpf N audio_bpf_new
[DC,Wp_n,Ws_n,N,fs,TW]=initialization();
HD=bandpass_transfer_function(DC,Wp_n,Ws_n,N);
hd=unit_impulse_response(HD,N);             %Step 2: convert filter response to unit impulse response
[win Nwin]=hamming_window(fs,TW);%Step 3: generate rectangular window function 
hd_win_band=add_window(hd,win,DC,Nwin,N);         %Step 4: apply window function to unit impulse response
audio_bpf=conv(audio_clip,hd_win_band);
tmp1=get(handles.midrange,'value');
tmp=tmp1*fft(audio_bpf);
audio_bpf_new=ifft(tmp);

function midrange_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function treble_Callback(hObject, eventdata, handles)

set(handles.text10,'String',get(handles.treble,'value'))

global Wp_n Ws_n hd_win_high audio_clip audio_hpf N audio_hpf_new
[DC,Wp_n,Ws_n,N,fs,TW]=initialization();
HD=highpass_transfer_function(DC,Ws_n,N);
hd=unit_impulse_response(HD,N);             %Step 2: convert filter response to unit impulse response
[win Nwin]=hamming_window(fs,TW);%Step 3: generate hamming window function 
hd_win_high=add_window(hd,win,DC,Nwin,N);         %Step 4: apply window function to unit impulse response
audio_hpf=conv(audio_clip,hd_win_high);
tmp1=get(handles.treble,'value');
tmp=tmp1.*fft(audio_hpf);
audio_hpf_new=ifft(tmp);

function treble_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function choose_file_Callback(hObject, eventdata, handles)
global audio_clip Fs Name
[Name, folder] = uigetfile('*.wav;*.mp3;*.ogg','Select a video clip');
filename = fullfile(folder, Name);
[audio_clip,Fs] = audioread(filename);
Clip_info=audioinfo(filename);
ch=Clip_info.NumChannels;
len=Clip_info.TotalSamples;
set(handles.text6,'String',Name)
handles.Fs = Fs;
handles.videoFileName=filename;
handles.videoData = audio_clip;
guidata(hObject, handles);
axes(handles.axes1);
stem(audio_clip)

function stop_reset_Callback(hObject, eventdata, handles)

clear sound;
set(handles.text6,'String',[])
cla(handles.axes1);

function play_output_sound_Callback(hObject, eventdata, handles)
global audio_hpf_new audio_lpf_new audio_bpf_new Fs
clear sound
cla(handles.axes1);
audio=audio_hpf_new+audio_lpf_new+audio_bpf_new;
sound(audio,Fs)
axes(handles.axes1);
stem(audio)




function play_original_sound_Callback(hObject, eventdata, handles)

global audio_clip Fs
sound(audio_clip,Fs)



function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text8_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
