close all;
a = prbs(6, 1);
size(a)

stem(a)

[phi, h] = intcor(a, a);
size(phi)
figure
stem(h, phi)
grid