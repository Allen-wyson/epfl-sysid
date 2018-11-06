clc; 
clear all;
close all;


load laserbeamdataN.mat
N = size(u, 1);
m = 50;

input = u;
output = y;
tpl = zeros(m,1);
tpl(1,1) = input(1,1);


phi = toeplitz(input, tpl);

theta = phi \ output;
yh = phi * theta;

%% Estimate noise variance
J = norm(yh - output)
var_est = 1/(N-m) * J;
sigma = sqrt(var_est);

cov = var_est * inv(phi' * phi);

stairs(output,'r');
hold on;
stairs(yh,'b');
legend('measured','predicted');

figure
stem(theta)

figure
errorbar(theta, 2*sqrt(diag(cov)), '-o', 'MarkerSize',5,...
    'MarkerEdgeColor','red','MarkerFaceColor','red');
grid;

figure
colormap gray;
imagesc(cov);


