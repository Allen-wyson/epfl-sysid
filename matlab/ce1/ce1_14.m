%% Init

clear all; 
clc;
close all;

init;


%% Input signal

Uprbs = prbs(7,4)*.5;
N = size(Uprbs,1);
Tend = (N-1)*Te;
t = (0:Te:Tend)'; 


%% Simulation

simin.signals.values = Uprbs;
simin.time = t;

sim('ce1');
y = simout.Data;

%% Compute auto- and cross correlation 

[auto_corr, ha] = intcor(Uprbs, Uprbs);
[cross_corr, hc] = intcor(Uprbs,y);

%% Truncate correlations

zero_index = ha(end)+1;
%n_zero = ceil(size(hc,1)/2);

K = 50/Te;

auto_corr_trunc = auto_corr(zero_index:zero_index+K-1);
cross_corr_trunc = cross_corr(zero_index:zero_index+K-1);

ha_trunc = ha(zero_index:zero_index+K-1);


%% Compute impulse response

Ruu = toeplitz(auto_corr_trunc,auto_corr_trunc);

g = Ruu \ cross_corr_trunc;
g2 = cross_corr_trunc ./ auto_corr_trunc(1);


%% Plots

t_g = t(1:K);

stem(ha_trunc, auto_corr_trunc);
title 'Autocorrelation of input signal'
grid;

figure;
stem(ha_trunc, cross_corr_trunc);
title 'Cross correlation of input and output';
grid;

figure;
stairs(t_g, g);
hold on;
stairs(t_g, g2);
legend('Numerical deconvolution (with R_{uu}(h-j))', 'Simplified version for white noise (with R_{uu}(0))');
grid;
title 'Resulting impulse response';



%Ruu = toeplitz(u_corr(n_zero:n_zero+K-1),u_corr(n_zero:n_zero+K-1));
%g = Ruu\cross_corr(n_zero:n_zero+K-1);
%tk = t(1:1:K);


%% Impulse response with xcorr

[auto_corr_xcorr, h] = xcorr(Uprbs, Uprbs,'biased');
[cross_corr_xcorr, h1] = xcorr(y,Uprbs,'biased');

figure;
stem(h, auto_corr_xcorr,'r');
title 'Autocorrelation with xcorr';
figure;
stem(h, cross_corr_xcorr);
title 'Crosscorrelation with xcorr';


%% Truncate xcorr
zero_index1 = h(end)+1;
h_trunc = h(zero_index1:zero_index1+K-1);

auto_corr_xcorr_trunc = auto_corr_xcorr(zero_index1:zero_index1+K-1);
cross_corr_xcorr_trunc = cross_corr_xcorr(zero_index1:zero_index1+K-1);

%% Impulse xcorr

Ruu = toeplitz(auto_corr_xcorr_trunc,auto_corr_xcorr_trunc);

g_xcorr = Ruu \ cross_corr_xcorr_trunc;
g2_xcorr = cross_corr_xcorr_trunc ./ auto_corr_xcorr_trunc(1);


%% Plot xcorr

figure;
stem(h_trunc, auto_corr_xcorr_trunc);
title 'Truncated autocorrelation of input signal with xcorr'
grid;

figure;
stem(h_trunc, cross_corr_xcorr_trunc);
title 'Truncated cross correlation of input and output';
grid;

figure;
stairs(t_g, g_xcorr);
hold on;
stairs(t_g, g2_xcorr);
legend('Numerical deconvolution (with R_{uu}(h-j)) with xcorr', 'Simplified version for white noise (with R_{uu}(0)) with xcorr');
grid;
title 'Resulting impulse response';


%% Comparison 

figure;
stairs(t_g, g_xcorr);
hold on;
stairs(t_g, g);
legend('Intcorr', 'xcorr');

