close all;
u = prbs(4, 2);
size(u)

stem(u)

[phi, h] = intcor(u, u);
size(phi)
figure
stem(h, phi)
grid

figure
x= (0:0.1:2*pi)';
y = sin(x-pi/2);
stem(y);
grid
[phi, h] = intcor(y, y);
figure
stem(h, phi)
grid