close all
init

T = 250;
Te = .5;
N = T/Te;
signal = rand(N, 1)-.5;
tmp = signal;
tmp(2:N) = 0;
input = toeplitz(signal, tmp);

t = (0:Te:(N-1)*Te)';
simin.time = t;
simin.signals.values = signal;

Tend = T-Te;
sim('ce1');

output = simout.Data;
plot(t, signal)
hold on
plot(t, output)
legend('Input', 'Output')

figure
trunc = 150;
input = input(:,1:trunc);
impulse_response = input\output;
stairs(t(1:trunc), impulse_response);
grid


% For comparison
figure
sys = tf(1, [1, 0.4, 4.3, 0.85, 1]);
sys = c2d(sys, Te, 'zoh');
impulse(Te*sys)