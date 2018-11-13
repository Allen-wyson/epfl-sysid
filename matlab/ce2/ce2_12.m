%% Initialisation

clc; 
clear;
close all;


load laserbeamdataN.mat
N = size(u, 1);

%% Parameter vector

fsum = zeros();
phi = zeros(N,4);

phi(2, :) = [-y(1), 0, u(1), 0];
for k=3:N
    phi(k,:)= [-y(k-1),-y(k-2),u(k-1),u(k-2)];
end

theta = phi \ y;
yh = phi * theta;

diff = yh-y;

J = norm(diff)^2;
disp(sprintf("Loss: %f", J))

figure;
plot(diff);

figure;
stairs(y,'r');
hold on;
stairs(yh,'b');