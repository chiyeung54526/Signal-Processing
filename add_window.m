%Apply window function to ideal impulse response
function hd_win=add_window(hd,win,DC,Nwin,N)
hd=fftshift(hd);
hd_win=zeros(1,N);
DC_win=(Nwin-1)/2;
hd_win(DC-DC_win:DC+DC_win)=hd(DC-DC_win:DC+DC_win).*win;
%figure
%t = linspace(0, N-1,N);
%stem(t,abs(hd_win))
%title('Windowed unit impulse response')
end

