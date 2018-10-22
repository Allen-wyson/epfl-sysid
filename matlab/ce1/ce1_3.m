clear all;
clc;
close all;
init;
%% Input signal: random signal

T = 200;
Te = 0.5;
Tend = T-Te;
N = T/Te;
signal = rand(N,1)-0.5;

%% Input Toeplitz matrix
tmp = zeros(size(signal,1),1);
tmp(1,1) = signal(1,1);
input = toeplitz(signal, tmp);

%% Simulation and original impulse response

t = (0:Te:(N-1)*Te)'; 

simin.signals.values = signal;
simin.time = t;

sim('ce1');

output = simout.Data;

impulse_response1 = inv(input)* output;


%% Reducing the number of equations

% original number of equations:
% trunc = 500; 
trunc = floor(50/Te);
input = input(:,1:trunc);

impulse_response = estimate_impulse_response_numdec(signal, output, trunc);
%% Plots 

stairs(t, signal, 'r');
hold on;
stairs(t, output, 'b');
legend('Input','Output');
title('Signal/Input and Output');
xlabel('Time (seconds)');
grid;

t_trunc = t(1:trunc);
% original impulse response
figure;
stairs(t, impulse_response1, 'b');
grid;
hold on; 
sys = tf(1, [1, 0.4, 4.3, 0.85, 1]);
sys = c2d(sys, Te, 'zoh');
g = impulse(Te*sys, 'r');
stairs(t(1:size(g,1)), g, 'r');
title('Erroneous result due to num. instability');
legend('impulse response by deconvolution method', 'True impulse response');

% impulse response
figure;
stairs(t_trunc, impulse_response, 'b');
grid;
hold on; 
g_trunc = g(1:trunc);
stairs(t_trunc, g_trunc, 'r');
title('Impulse response');
legend('Impulse response by deconvolution method', 'True impulse response');

size(g_trunc)
err = norm(g_trunc - impulse_response);
disp(sprintf("L2 norm of error: %.2f", err))

