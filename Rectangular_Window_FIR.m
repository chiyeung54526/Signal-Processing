function Rectangular_Window_FIR()
close all
%方窗滤波 （替换窗口函数即可完成其他窗口的滤波）
%Analogue frequencies associated with the analogue filter
fs=10000;   %Sampling frequency = 10kHz
Wp=500;                 %Pass band edge = 300Hz【We can change these WPandWS to achieve advanced outcome a)】
Ws=600;                 %Stop band edge = 400Hz 【TA please attention here!】
cutoff=(Wp+Ws)/2        %Actual Pass band edge实际通带边缘
TW=Ws-Wp                %Transition width 传输带宽
%{
%or just cancel the "NOTE"of"%{"just be OK to change 修改此处注释
并注释掉上面部分来改变带通和带阻参数，推荐Wp=200 Ws=300
%Analogue frequencies associated with the analogue filter
fs=10000;   %Sampling frequency = 10kHz
Wp=300;                 %Pass band edge = 300Hz
Ws=400;                 %Stop band edge = 400Hz
cutoff=(Wp+Ws)/2        %Actual Pass band edge实际通带边缘
TW=Ws-Wp                %Transition width 传输带宽
%}
%To begin with assume the frequency space is discretized into N samples. 
%N should be large but its value is flexible. 定义空间长度
N=6001;

%Digital frequencies associated with the digital filter obtained from
%sampling the analogue unit impulse response (通过单位冲激响应法得到）模拟单位冲激响应 的相关 数字滤波器 的相关参数
Wp_n=round(Wp/(fs/N))
Ws_n=round(Ws/(fs/N))
cutoff_n=round(cutoff/(fs/N))%数字滤波器的通带  阻带  截止边缘

%On the digital frequency axis, the DC (0 Hz) is located at the midpoint of the
%frequency axis （数字）频域轴上的中心频率
DC=(N-1)/2+1; %Location of DC component (frequency=0)

%=============================================================================================================================
%Five steps to build the discrete unit impulse response of a low-pass
%filter 单位脉冲响应 制作 低通滤波器 五步法
HD=lowpass_transfer_function(DC,Wp_n,N);    %Step 1: define ideal lowpass filter response 确定单位冲激响应（模拟） 低通转换函数（转换前为HD 带通部分）
hd=unit_impulse_response(HD,N);             %Step 2: convert filter response to unit impulse response 转化为对应数字滤波器单位响应
[win Nwin]=rectangular_window(fs,TW);       %Step 3: generate rectangular window function 利用窗函数截取频域上所需的信号（低通则截取低通）
hd_win=add_window(hd,win,DC,Nwin,N)         %Step 4: apply window function to unit impulse response 加窗函数 应用单位冲激响应（测试对应的 apply4种窗口加窗情况）
RES=windowed_filter_transfer_function(hd_win,N);    %tep 5: get the frequency response of the windowed unit impulse response窗口过滤函数 得到该窗口下 频域部分的单位冲击响应
%=============================================================================================================================

%Get maximum sidelobe magnitude得到旁瓣幅值
%The maximum sidelobe can be found in the windowed filter transfer
%function最大旁瓣
RES=abs(RES);
PG=RES(DC)%用RES函数把 中心频率移到0处得到主瓣幅值
PS=RES(3366);%同理频率3366处的旁瓣幅值
A=20*log10(PS/PG)%算出 对于主瓣的旁瓣衰减

[audio_in,Fs,ch,len]=read_file();
Fi=Fs/len;    %Frequency interval 频域间隔 
Ts=1/Fs;    %Sampling interval 采样间隔Ts
audio_lpf=conv(hd_win,audio_in);
sound(audio_lpf,Fs)

end





%======================Supporting functions================================
function HD=lowpass_transfer_function(DC,Wp_n,N)
%Generate the low-pass function in the digital frequency
%spectrum生成数字低通函数 频谱.中心频带
%Gain in passband=1, phase is linear. Gain=0 at stopband 通带为1 阻带为0 相位线性
HD=zeros(1,N);%提前生成0数组以备存储数据 HD转hd 模拟转离散数字
for i=DC-Wp_n:DC+Wp_n
    n=i-DC;
    f=n*2*pi/N;
    HD(i)=1;
end
%采样频率为步进长度在中心频率两侧通带领域设置带通为1
figure
t = linspace(0,N-1,N);
stem(t,abs(HD))%显示幅值
title('Target frequency spectrum')
%频谱画图
end

%Convert digital frequency spectrum to discrete unit impulse response
%using inverse FFT 用FFT转换成频域上离散
function hd=unit_impulse_response(HD,N)
HD=circshift(fftshift(HD),1);%步进为1的离散
hd=ifft(HD);%快速傅里叶fft转为离散数字
figure
t = linspace(0, N-1,N);
stem(t,real(hd))
title('Target unit impulse response')
end
%%
%%modifypart
%Construct rectangular window function 构件方窗！！！imp！！1此处替换窗口函数即可完成基础部分
function [win Nwin]=rectangular_window(fs,TW)
Nwin=round(0.91*fs/TW);%四舍五入采样频段为整数
if mod(Nwin,2)==0
    Nwin=Nwin+1;%偶数频段转为奇数
end
win=zeros(1,Nwin);%创建0数组方便后续数据存储

for i=1:Nwin
    n=(i-1)-(Nwin-1)/2;
    win(i)=1;%窗口幅值为1
end
figure%画图
t = linspace(0, Nwin-1,Nwin);
stem(t,win)
title('rectangular Window Function')
end
%{
function [win Nwin]=hanning_window(fs,TW)
%汉ning窗口构建
Nwin=round(0.91*fs/TW);
if mod(Nwin,2)==0
            Nwin=Nwin+1;
        end
        win=zeros(1,Nwin);
        for i=1:Nwin
            n=(i-1)-(Nwin-1)/2;
            win(i) = 0.5 + 0.5.* cos((2 * pi * n) / (Nwin -1));
        end
figure
t = linspace(0, Nwin-1,Nwin);
stem(t,win)
axis([0,Nwin,-0.1,1.1])
title('hanning Window Function')
end
%}
       
%{
function [win Nwin]=hamming_window(fs,TW)
%汉明窗口构建
Nwin=round(0.91*fs/TW);
if mod(Nwin,2)==0
    Nwin=Nwin+1;
end
win=zeros(1,Nwin);

for i=1:Nwin
    n=(i-1)-(Nwin-1)/2;
    win(i)=0.54+0.46*cos(2*pi*n/(Nwin-1));
end
figure
t = linspace(0, Nwin-1,Nwin);
stem(t,win)
axis([0,Nwin,-0.1,1.1])
title('hamming Window Function')
end
%}
%{
function [win Nwin]=blackman_window(fs,TW)
%布莱克曼窗口构建
Nwin=round(3.44*fs/TW);
if mod(Nwin,2)==0
    Nwin=Nwin+1;
end
win=zeros(1,Nwin);

for i=1:Nwin
    n=(i-1)-(Nwin-1)/2;
    win(i)=0.54+0.46*cos(2*pi*n/(Nwin-1));
end
figure
t = linspace(0, Nwin-1,Nwin);
stem(t,win)
axis([0,Nwin,-0.1,1.1])
title('hanning Window Function')
end
%}

%%
%Apply window function to ideal impulse response！！！imp！！应用不同窗口函数对单位冲激响应取窗
function hd_win=add_window(hd,win,DC,Nwin,N)%
hd=fftshift(hd);
hd_win=zeros(1,N);
DC_win=(Nwin-1)/2;
hd_win(DC-DC_win:DC+DC_win)=hd(DC-DC_win:DC+DC_win).*win;
figure
t = linspace(0, N-1,N);
stem(t,abs(hd_win))
title('Windowed unit impulse response')
end


function RES=windowed_filter_transfer_function(hd_win,N)%单位冲激被窗口截取后的响应
hd_win=circshift(fftshift(hd_win),1);
HD_win=fft(hd_win);
%RES=abs(HD_win);
RES=fftshift(HD_win);
%RES=RES/max(RES(:));
figure
t = linspace(0, N-1,N);
stem(t,abs(RES))
title('Spectrum of windowed unit impulse response')
end

function [audio_clip,Fs,ch,T]=read_file()%音频片段  读取所需音频
[Name, folder] = uigetfile('*.wav;*.mp3;*.ogg');
filename = fullfile(folder, Name);
clear sound;
[audio_clip,Fs] = audioread(filename);
Clip_info=audioinfo(filename);
ch=Clip_info.NumChannels;
T=Clip_info.TotalSamples;
end