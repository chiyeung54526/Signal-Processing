function [win Nwin]=rectangular_window(fs,TW)
Nwin=round(0.91*fs/TW);
if mod(Nwin,2)==0
    Nwin=Nwin+1;
end
win=zeros(1,Nwin);

for i=1:Nwin
    n=(i-1)-(Nwin-1)/2;
    win(i)=1;
end
%figure
%t = linspace(0, Nwin-1,Nwin);
%stem(t,win)
%title('Window Function')
end
