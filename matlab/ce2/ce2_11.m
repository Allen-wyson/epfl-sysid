%% Initialisation

clc; 
clear;
close all;


load laserbeamdataN.mat
N = size(u, 1);
m = 50;

input = u;
output = y;

%[yh,theta,sigma] = FIR_model_identification(input, output, m)
%% Parameter vector

tpl = zeros(m,1);
tpl(1,1) = input(1,1);

phi = toeplitz(input, tpl);

theta = phi \ output;


%% Output and loss function

yh = phi * theta;
J = (norm(output-yh))^2;


%% Estimate noise variance

var_est = 1/(N-m) * J;
sigma_noise = sqrt(var_est);

covar = var_est * inv(phi' * phi);
sigma = sqrt(diag(covar));

%% Plots

figure;
stairs(output,'r');
hold on;
stairs(yh,'b');
legend({' measured output y ',' predicted output $\hat{y}$'},'Interpreter','latex');
title('Output of the system');
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


figure
colormap gray;
imagesc(covar);




