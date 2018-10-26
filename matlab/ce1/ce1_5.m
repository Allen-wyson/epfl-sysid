%% 1.1 Initialization and PRBS signal 
init
close all; 

n= 8;
n_periods = 8;
Te = 0.5;
Uprbs = prbs(n, n_periods)*.5;
N = size(Uprbs,1);
Tend = (N-1)*Te;
t = (0:Te:Tend)'; 

%Simulation
simin.signals.values = Uprbs;
simin.time = t;
sim('ce1');
y = simout.Data;

%% 1.2 Compute Fourier transform (not using the first period)

period_length = 2^n - 1;
[sys, F] = estimate_frequency_response(period_length, n_periods, Uprbs, y, Te);


%% 1.4 Compute MATLAB frd frequency response

sys = tf(1, [1, 0.4, 4.3, 0.85, 1]);
sys = c2d(sys, Te, 'zoh');
resp = frd(sys, 2*pi*F); % pi*F
bode(resp);
figure;

%% Plot spectrum

trunc = ceil(period_length/2);
f_trunc = F(1:trunc)*2*pi; % pi*F
loglog(f_trunc, abs(fft_in(1:trunc)), 'b');
hold on
loglog(f_trunc, abs(fft_out(1:trunc)), 'r');
loglog(f_trunc, abs(G(1:trunc)), 'g');
legend('fft of the input', 'fft of the output', 'fft of the transfer function');
xlabel 'Frequency [rad/s]';
ylabel 'Power';
title 'Fourier transformations';
grid;

%% 1.5 Comparison 

figure
hold on 
bode(our, {0, 2*pi}, 'b')
bode(resp, {0, 2*pi}, 'r')
grid;
axes_handles = findall(gcf, 'type', 'axes');
legend(axes_handles(2),'identified', 'ground truth', 'Location', 'NorthEast');
%legend(axes_handles(3),'identified', 'ground truth', 'Location', 'NorthEast');

disp(sprintf("Signal length: %d", N))