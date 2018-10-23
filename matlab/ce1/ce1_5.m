%% 1.1 Initialisation and PRBS signal 

init; close all; clear all; clc;

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

fft_in = zeros(period_length, 1);
fft_out = zeros(period_length, 1);

for i = 2:n_periods
	fft_in = fft_in + fft(Uprbs((i-1)*period_length+1:i*period_length));
	fft_out = fft_out + fft(y((i-1)*period_length+1:i*period_length));
end

fft_in = fft_in ./ (n_periods-1);
fft_out = fft_out ./ (n_periods-1);

G = fft_out ./ fft_in;

%% 1.3 Frequency vector 

F = (0:1:(period_length-1))' .* (1/Te) / period_length;


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

figure
our = frd(G, 2*pi*F);
bode(our);
grid;


%% 1.5 Comparison 

figure
bode(our,'b',resp,'r');
grid;
axes_handles = findall(gcf, 'type', 'axes');
legend(axes_handles(2),'identified', 'ground truth', 'Location', 'NorthEast');
legend(axes_handles(3),'identified', 'ground truth', 'Location', 'NorthEast');

