%% Init
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

K = 50/Te;

auto_corr_trunc = auto_corr(zero_index:zero_index+K-1);
cross_corr_trunc = cross_corr(zero_index:zero_index+K-1);

ha_trunc = ha(zero_index:zero_index+K-1);


%% Compute impulse response

Ruu = toeplitz(auto_corr_trunc,auto_corr_trunc);

g = estimate_impulse_response_corr(Uprbs, y, K); 
g2 = estimate_impulse_response_corr(Uprbs, y, K, 'intcor_simple');


%% Plots

t_g = t(1:K);

stem(ha, auto_corr);
title 'Autocorrelation of input signal (intcor)'
xlabel 'Time [s]'
ylabel 'Amplitude'
grid;

figure;
stem(ha, cross_corr);
title 'Cross correlation of input and output (intcor)';
xlabel 'Time [s]'
ylabel 'Amplitude'
grid;

figure;
stairs(t_g, g);
hold on;
stairs(t_g, g2);
legend('Numerical deconvolution (with R_{uu}(h-j))', 'Simplified version for white noise (with R_{uu}(0))');
grid;
title 'Resulting impulse response (intcor)';
xlabel 'Time [s]'
ylabel 'Amplitude'



%Ruu = toeplitz(u_corr(n_zero:n_zero+K-1),u_corr(n_zero:n_zero+K-1));
%g = Ruu\cross_corr(n_zero:n_zero+K-1);
%tk = t(1:1:K);


%% Auto- and cross correlation with xcorr

[auto_corr_xcorr, h] = xcorr(Uprbs, Uprbs,'biased');
[cross_corr_xcorr, h1] = xcorr(y,Uprbs,'biased');

figure;
stem(h, auto_corr_xcorr,'r');
title 'Autocorrelation with xcorr';
xlabel 'Time [s]'
ylabel 'Amplitude'
figure;
stem(h, cross_corr_xcorr);
xlabel 'Time [s]'
ylabel 'Amplitude'
title 'Crosscorrelation with xcorr';


%% Truncate xcorr

zero_index1 = h(end)+1;
h_trunc = h(zero_index1:zero_index1+K-1);

auto_corr_xcorr_trunc = auto_corr_xcorr(zero_index1:zero_index1+K-1);
cross_corr_xcorr_trunc = cross_corr_xcorr(zero_index1:zero_index1+K-1);

%% Impulse xcorr
g_xcorr = estimate_impulse_response_corr(Uprbs, y, K, 'xcorr_num_dec');
g2_xcorr = estimate_impulse_response_corr(Uprbs, y, K, 'xcorr_simple');


%% Plot xcorr

figure;
stem(h_trunc, auto_corr_xcorr_trunc);
title 'Truncated autocorrelation of input signal with xcorr'
xlabel 'Time [s]'
ylabel 'Amplitude'
grid;

figure;
stem(h_trunc, cross_corr_xcorr_trunc);
title 'Truncated cross correlation of input and output';
xlabel 'Time [s]'
ylabel 'Amplitude'
grid;

figure;
stairs(t_g, g_xcorr);
hold on;
stairs(t_g, g2_xcorr);
legend('Numerical deconvolution (with R_{uu}(h-j)) with xcorr', 'Simplified version for white noise (with R_{uu}(0)) with xcorr');
grid;
title 'Resulting impulse response (xcorr)';
xlabel 'Time [s]'
ylabel 'Amplitude'


%% Comparison 

figure;
sys = tf(1, [1, 0.4, 4.3, 0.85, 1]);
sys = c2d(sys, Te, 'zoh');
Y = impulse(Te*sys, 'r');
Y = Y(1:size(t_g));
hold on;
stairs(t_g, Y);
stairs(t_g, g);
stairs(t_g, g_xcorr);
stairs(t_g, g2);
stairs(t_g, g2_xcorr)
grid
xlabel 'Time [s]'
ylabel 'Amplitude'
legend('MATLAB', 'numerical deconvolution intcor', 'numerical deconvolution xcorr', 'simple intcor', 'simple xcorr');
title 'Comparison of the Approaches'


%% Comparison to previous approach
u = Uprbs;
Nruns = 50;
K = 50/Te;

results1 = zeros(Nruns, K);
results2 = zeros(Nruns, K);
results3 = zeros(Nruns, K);

for i=1:Nruns
	simin.signals.values = Uprbs;
	simin.time = t;

	sim('ce1');

	results1(i,:) = estimate_impulse_response_corr(u, simout.Data, K);
	results2(i,:) = estimate_impulse_response_numdec(u, simout.Data, K);
	results3(i,:) = estimate_impulse_response_corr(u, simout.Data, K, 'xcorr_simple');
end

figure
hold on
X = [t_g', fliplr(t_g')];
Y1 = [min(results1), fliplr(max(results1))];
fill(X, Y1, 'r');
Y3 = [min(results3), fliplr(max(results3))];
fill(X, Y3, 'g');
Y2 = [min(results2), fliplr(max(results2))];
fill(X, Y2, 'black');

alpha(0.25)
grid
plot(t_g, mean(results1), 'r')
plot(t_g, mean(results3), 'g')
plot(t_g, mean(results2), 'black')
legend('Correlation appraoch, intcor (1.4)', ...
	'Correlation appraoch, xcorr (1.4)', ...
	'Numerical Deconvolution (1.3)')
