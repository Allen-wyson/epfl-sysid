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

K = 60/Te;
%K = ceil(N/2);

auto_corr_trunc = auto_corr(zero_index:zero_index+K-1);
cross_corr_trunc = cross_corr(zero_index:zero_index+K-1);

ha_trunc = ha(zero_index:zero_index+K-1);


%% Compute impulse response

Ruu = toeplitz(auto_corr_trunc,auto_corr_trunc);

g = estimate_impulse_response_corr(Uprbs, y, K); 
g2 = estimate_impulse_response_corr(Uprbs, y, K, 'intcor_simple');


%% Plots

t_g = t(1:K);

plot(t, Uprbs);
title 'PRBS signal'
xlabel 'Time [s]'
ylabel 'Amplitude'
grid;

figure
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

%% Both correlation signals
figure;
hold on
stem(h, auto_corr_xcorr, 'b');
stem(ha, auto_corr, 'r')
ylabel 'Time [s]'
xlabel 'Amplitude'
grid
legend('intcor', 'xcorr')

figure;
hold on
stem(h, cross_corr_xcorr)
stem(ha, cross_corr, 'r');
ylabel 'Time [s]'
xlabel 'Amplitude'
grid
legend('intcor', 'xcorr')

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


%% Previous result: 
old = estimate_impulse_response_numdec(Uprbs, y, K);

%% Comparison 

figure;
sys = tf(1, [1, 0.4, 4.3, 0.85, 1]);
sys = c2d(sys, Te, 'zoh');
Y = Te*impulse(sys);
hold on;
if size(t_g,1) < size(Y,1)
	stairs(t_g, Y(1:size(t_g,1)));
else
	stairs(t_g(1:size(Y,1)), Y);
end
stairs(t_g, g);
stairs(t_g, g_xcorr);
%stairs(t_g, g2);
%stairs(t_g, g2_xcorr)
stairs(t_g, old);
grid
xlabel 'Time [s]'
ylabel 'Amplitude'
legend('MATLAB (ground truth)', ...
	'intcor', ...
	'xcorr', ...
	'numdec');
	%'simple intcor', ...
	%'simple xcorr');
title 'Comparison of the Approaches'



%% 2-norms of errors
if size(Y,1) < K
	Y_complete = zeros(K, 1);
	Y_complete(1:size(Y,1)) = Y;
	Y = Y_complete;
else
	Y = Y(1:K);
end
disp(sprintf("L2 norm of error for numdec intcor: %.2f", norm(Y-g)))
disp(sprintf("L2 norm of error for simple intcor: %.2f", norm(Y-g2)))
disp(sprintf("L2 norm of error for numdec xcorr: %.2f", norm(Y-g_xcorr)))
disp(sprintf("L2 norm of error for simple xcorr: %.2f", norm(Y-g2_xcorr)))
disp(sprintf("L2 norm of error for old aproach: %.2f", norm(Y-old)))

