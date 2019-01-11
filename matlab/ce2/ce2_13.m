close all;

load laserbeamdataN.mat

[A, B, C, D] = ss_identification(u, y);
sys = ss(A,B,C,D,1e-3);
[y_sys, t_sys, x_sys] = lsim(sys, u);

figure
plot(t_sys, y_sys);
hold on
stairs(0:1e-3:(size(y,1)-1)*1e-3, y, 'r')
legend("simulated", "input data")
grid

figure
plot(t_sys, x_sys);
grid;
legend("x_1", "x_2", "x_3")

