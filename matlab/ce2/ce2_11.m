clc; 
clear all;
close all;


load laserbeamdataN.mat
m = 50;

input = u(2:end);
output = y(2:end);
tpl = zeros(m,1);
tpl(1,1) = input(1,1);


phi = toeplitz(input, tpl);

tetah = inv(phi' * phi) * (phi' * output);

yh = phi * tetah;

plot(output,'r');
hold on;
plot(yh,'b');
legend('original','model');



