function plot_func(g,N,msg)
figure
t = linspace(0, N-1,N);
stem(t,g)
title(msg)
%axis([0,400000,-1.1,1.1])
end

