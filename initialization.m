function [DC,Wp_n,Ws_n,N,fs,TW]=initialization()
fs=10000;   %Sampling frequency = 10kHz
Wp=300;                 %Pass band edge = 300Hz
Ws=400;                 %Stop band edge = 400Hz
cutoff=(Wp+Ws)/2;        %Actual Pass band edge
TW=Ws-Wp;                %Transition width
N=6001;
Wp_n=round(Wp/(fs/N));%normalization
Ws_n=round(Ws/(fs/N));
cutoff_n=round(cutoff/(fs/N));
DC=(N-1)/2+1;
end

