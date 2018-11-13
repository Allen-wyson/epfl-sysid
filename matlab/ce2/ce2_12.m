%% Initialisation

clc; 
clear;
close all;


load laserbeamdataN.mat
N = size(u, 1);



%[yh,theta,sigma] = FIR_model_identification(input, output, m)
%% Parameter vector

fsum = zeros();
phi2= zeros(N,4);

for k=3:N
    phi = [-y(k-1);-y(k-2);u(k-1);u(k-2)];
   
    phi2(k,:)= phi;
    
    
end

theta = phi2 \ y;


yh = phi2 * theta;

diff = yh-y;

figure;
plot(diff);

figure;
stairs(y,'r');
hold on;
stairs(yh,'b');