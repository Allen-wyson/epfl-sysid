%% Initialisation

clc; 
clear;
close all;


load laserbeamdataN.mat
N = size(u,1);

[yh, ysim, theta, sys, J, J_tf] = ARX_model_identification(u, y, 1);

disp(sprintf("Prediction loss: %f", J));
disp(sprintf("Transfer function model loss: %f", J_tf));

[yh_iv, ysim_iv, theta_iv, sys_iv, J_iv, J_tf_iv] = ARX_model_identification(u, y, 100);

disp(sprintf("Transfer function model loss (IV): %f", J_tf_iv));

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


figure;
stairs(y, 'r');
hold on
stairs(ysim, 'g');
stairs(ysim_iv, 'b');
grid;
legend({'measured output y(k)', 'predicted output $y_m(k)$','predicted output $y_{m,iv}(k)$'},'Interpreter','latex');
title('Second order model with lsim');
