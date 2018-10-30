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
[our, F] = estimate_frequency_response(period_length, n_periods, Uprbs, y, Te);


%% 1.4 Compute MATLAB frd frequency response

sys = tf(1, [1, 0.4, 4.3, 0.85, 1]);
sys = c2d(sys, Te, 'zoh');
resp = frd(sys, 2*pi*F); % pi*F

%% 1.5 Comparison 

figure
hold on 
bode(our, {0, 2*pi}, 'bx')
bode(resp, {0, 2*pi}, 'r')
grid;
axes_handles = findall(gcf, 'type', 'axes');
legend(axes_handles(2),'identified', 'ground truth', 'Location', 'NorthEast');
%legend(axes_handles(3),'identified', 'ground truth', 'Location', 'NorthEast');

disp(sprintf("Signal length: %d", N))

%% Simulate system without input signal
Uzero = zeros(size(Uprbs));
simin.signals.values = Uzero;
simin.time = t;
sim('ce1');
yzero = simout.Data;

%% Show spectra compare with only noise
fft_out = zeros(period_length, 1);
fft_in = zeros(period_length, 1);
fft_zero = zeros(period_length, 1);
for i = 2:n_periods
	fft_out = fft_out + fft(y((i-1)*period_length+1:i*period_length)) ./ period_length;
	fft_in = fft_in + fft(Uprbs((i-1)*period_length+1:i*period_length)) ./ period_length;
	fft_zero = fft_zero + fft(yzero((i-1)*period_length+1:i*period_length)) ./ period_length;
end
fft_out = abs(fft_out ./ (n_periods - 1));
fft_in = abs(fft_in ./ (n_periods -1));
fft_zero = abs(fft_zero ./ (n_periods - 1));
g = fft_out ./ fft_in;
f = 2*pi*(0:1:(period_length-1))' .* (1/Te) / period_length;
nmax = floor(period_length/2);

figure
loglog(f(1:nmax), fft_out(1:nmax), 'r')
hold on
loglog(f(1:nmax), fft_in(1:nmax), 'g')
loglog(f(1:nmax), g(1:nmax), 'black')
legend('output', 'input', 'transfer function')
title 'Spectra of Signals'
xlabel 'Frequency [rad/s]'
ylabel 'Magnitude'
grid

figure
loglog(f(1:nmax), fft_out(1:nmax), 'b');
hold on
loglog(f(1:nmax), fft_zero(1:nmax), 'r');
legend('output for PRBS input', 'output for zero input')
title 'Signal and Noise'
xlabel 'Frequency [rad/s]'
ylabel 'Magnitude'
grid
