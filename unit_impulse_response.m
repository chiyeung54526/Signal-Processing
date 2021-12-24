%Convert digital frequency spectrum to discrete unit impulse response
%using inverse FFT

function hd=unit_impulse_response(HD,N)
HD=circshift(fftshift(HD),1);
hd=ifft(HD);
%figure
%t = linspace(0, N-1,N);
%stem(t,real(hd))
%stem(t,hd)
%title('Target unit impulse response')
end

