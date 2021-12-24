function RES=windowed_filter_transfer_function(hd_win,N)
hd_win=circshift(fftshift(hd_win),1);
HD_win=fft(hd_win);
%RES=abs(HD_win);
%RES1=fftshift(HD_win);
RES=fftshift(HD_win);
%tmp=length(RES1);
%tmp1=ones(1,tmp);
%RES=tmp1-RES1;
%RES=RES/max(RES(:));
%figure
%t = linspace(0, N-1,N);
%stem(t,abs(RES))
%axis([0,6001,-0.1,1.2])
%title('Spectrum of windowed unit impulse response')
end

