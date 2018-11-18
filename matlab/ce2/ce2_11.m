%% Initialisation

clc; 
clear;
close all;


load laserbeamdataN.mat
N = size(u, 1);
m = 50;

input = u;
output = y;

[yh, theta, sigma, J] = FIR_model_identification(input, output, m);

disp(sprintf("Loss: %f", J));

figure;
stairs(output,'r');
hold on;
stairs(yh,'b');
legend({' measured output y ',' predicted output $\hat{y}$'},'Interpreter','latex');
title('Output of the system');
grid;
xlabel('Time [ms]');

figure
stem(theta,'b')
title('Vector of parameters \theta');

figure
errorbar(theta, 2*sigma, '-ob', 'MarkerSize',5,...
    'MarkerEdgeColor','red','MarkerFaceColor','red');
grid;
title('Impulse response of the system');
xlabel('Time');
ylabel('Amplitude')





