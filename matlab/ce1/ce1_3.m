clear all;
clc;
close all;
init;

%% Input signal: random signal

T = 250;
Te = 0.5;
Tend = T-Te;
N = T/Te;
signal = rand(N,1)-0.5;


%% Input Toeplitz matrix

tmp = zeros(size(signal,1),1);
tmp(1,1) = signal(1,1);

input = toeplitz(signal, tmp);


%% Simulation 

t = (0:Te:(N-1)*Te)'; 

simin.signals.values = signal;
simin.time = t;

%sim('ce1_1');
sim('ce1');

output = simout.Data;


%% Reducing the number of equations

% original number of equations:
% trunc = 500; 
trunc = 150;
input = input(:,1:trunc);

impulse_response = pinv(input) * output;


%% Plots 

plot(t, signal, 'r');
hold on;
plot(t, output, 'b');
legend('Input','Output');
title('Signal/Input and Output');
xlabel('Time (seconds)');


figure;
stairs(t(1:trunc), impulse_response(1:trunc), 'b');
%hold on;
%plot(t(1:trunc), impulse_response(1:trunc), 'g');
grid;

hold on; 
sys = tf(1, [1, 0.4, 4.3, 0.85, 1]);
sys = c2d(sys, Te, 'zoh');
impulse(Te*sys, 'r');

title('Impulse response');
legend('Impulse response by deconvolution method', 'True impulse response');





