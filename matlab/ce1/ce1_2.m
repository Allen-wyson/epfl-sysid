close all;
u = prbs(4, 2);
size(u)

stem(u)

[phi, h] = intcor(u, u);
size(phi)
figure
stem(h, phi)
grid