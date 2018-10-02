close all;
clear all;
clc;

%% Calculation

%u = prbs(4, 2);
x = [0:0.1:2*pi]';
u = sin(x);

[phi, h] = intcor(u, u);


%% Plot

figure('Name','Exercise CE-1 1.2 Autocorrelation Function','NumberTitle','off')

subplot(2,1,1);
stem(u,'b');
hold on;
ylim([-1.2 1.2]);
title('Sinusoidal signal');

subplot(2,1,2);
stem(h, phi,'b');
hold on;
%ylim([-inf inf]);
title('Autocorrelation of sinusoidal signal');

grid
