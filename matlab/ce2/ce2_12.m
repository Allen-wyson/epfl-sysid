%% Initialisation

clc; 
clear;
close all;


load laserbeamdataN.mat
N = size(u, 1);

%% Parameter vector

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

N = size(u,1);
f_sampling = 1e3;
t = 0:(1/f_sampling):(N-1)*(1/f_sampling);
z = tf('z', 1/f_sampling);
s = (theta(3)*(1/z) + theta(4)*(1/z^2)) / (1 + theta(1)*(1/z) + theta(2)*(1/z^2));
ysim = lsim(s, u, t);

figure;
stairs(y,'r');
hold on;
stairs(yh,'b');
grid;
legend('Measured Output', 'Predicted Output')

figure;
stairs(y, 'r');
hold on
stairs(ysim, 'b');
grid;
legend('Measured Output', 'Simulated Output')