%% Initialisation

clc; 
clear;
close all;


load laserbeamdataN.mat
N = size(u,1);

%% Parameter vector

phi = zeros(N,4);
phi(2,:) = [-y(1), 0, u(1), 0];
for k=3:N
    phi(k,:)= [-y(k-1),-y(k-2),u(k-1),u(k-2)];
end

% third order, 6 parameters
% phi = zeros(N,6);
% phi(2,:) = [-y(1), 0,0, u(1), 0,0];
% phi(3,:) = [-y(2),-y(1),0, u(2),u(1),0];
% for k=4:N
%    phi(k,:)= [-y(k-1),-y(k-2),-y(k-3),u(k-1),u(k-2),u(k-3)];
% end

theta = phi \ y;

%% Output and loss function

yh = phi * theta;

diff = yh-y;

J = norm(diff)^2;


%% Model with lsim

f_sampling = 1e3;
t = 0:(1/f_sampling):(N-1)*(1/f_sampling);
z = tf('z', 1/f_sampling);

sys = (theta(3)*(1/z) + theta(4)*(1/z^2)) / (1 + theta(1)*(1/z) + theta(2)*(1/z^2));

% third order, 6 parameters
% sys = (theta(4)*(1/z) + theta(5)*(1/z^2) + theta(6)*(1/z^3)) / (1 + theta(1)*(1/z) + theta(2)*(1/z^2) + theta(3)*(1/z^3));

ysim = lsim(sys, u, t);

J2 = norm(y-ysim)^2;

figure;
stairs(y,'r');
hold on;
stairs(yh,'b');
grid;
legend({'measured output y(k) ',' predicted output $\hat{y}(k)$'},'Interpreter','latex');
title('Output of the system');
xlabel('Time [ms]');


figure;
stairs(y, 'r');
hold on
stairs(ysim, 'b');
grid;
legend({'measured output y(k)', 'predicted output $y_m(k)$'},'Interpreter','latex');
title('Second order model with lsim');
% title('Third order model with lsim');


