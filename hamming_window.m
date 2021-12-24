function [win Nwin]=hamming_window(fs,TW)
Nwin=round(3.44*fs/TW);
if mod(Nwin,2)==0
    Nwin=Nwin+1;
end
win=zeros(1,Nwin);

for i=1:Nwin
    n=(i-1)-(Nwin-1)/2;
    win(i)=0.54+0.46*cos(2*pi*n/(Nwin-1));
end
%figure
%t = linspace(0, Nwin-1,Nwin);
%stem(t,win)
%axis([0,Nwin,-0.1,1.1])
%title('Window Function')
end

