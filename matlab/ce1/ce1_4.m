init
close all;

%% Generate input signal
Uprbs = prbs(7, 4)*.5;
N = size(Uprbs, 1);
Tend = (N-1)*Te;
t = (0:Te:Tend)';

%% Simulate System
simin.signals.values = Uprbs;
simin.time = t;

sim('ce1');
y = simout.Data;

%% Compute auto- and cross correlations
[u_corr, h] = intcor(Uprbs, Uprbs);
[yu_corr, h2] = intcor(Uprbs, y);

%% Truncate correlations
zero_index = h(end)+1;
K = 50/Te;
u_corr_trunc = u_corr(zero_index:zero_index+K-1);
yu_corr_trunc = yu_corr(zero_index:zero_index+K-1);
h_trunc = h(zero_index:zero_index+K-1);

%% Compute impulse response
g = yu_corr_trunc ./ u_corr_trunc(1);
g2 = toeplitz(u_corr_trunc, u_corr_trunc) \ yu_corr_trunc;
t_g = t(1:K);

%% Plot results
stem(h_trunc, u_corr_trunc);
title 'Autocorrelation of input signal'
grid
figure
stem(h_trunc, yu_corr_trunc);
grid
title 'Cross correlation of input and output'
figure
stairs(t_g, g)
hold on
stairs(t_g, g2)
legend('simple', 'matrix')
grid
title 'Resulting impulse response'