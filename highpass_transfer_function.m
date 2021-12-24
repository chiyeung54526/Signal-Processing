function HD=highpass_transfer_function(DC,Wp_n,N)
%Generate the low-pass function in the digital frequency spectrum
%Gain in passband=1, phase is linear. Gain=0 at stopband
HD=ones(1,N);
for i=DC-Wp_n:DC+Wp_n
    n=i-DC;
    f=n*2*pi/N;
    HD(i)=0;
end
%figure
%t = linspace(0,N-1,N);
%stem(t,abs(HD))
%axis([0,6001,-0.1,1.1])
%title('Target frequency spectrum')
end



