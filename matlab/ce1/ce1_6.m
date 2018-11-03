%% Initialisation and binary random signal
close all;

N = 2000;
u = randi(2, N, 1) - 1.5;
init

Tend = (N-1)*Te;
t = (0:Te:Tend)'; 

%% Simulation

simin.signals.values = u;
simin.time = t;
sim('ce1');
y = simout.Data;

% setting = window, window_width, color, linestyle, samples_per_group
settings = {
			"none", N, "[.6, .6, .6]", "-", 1;
			"none", N, "g", "-", 2;
			"none", N, "b", "-", 3;
			"none", N, "g", "-", 4;
			"hann", 20, "b", "-.", 1;
			"hann", 50, "b", ":", 1;
			"hann", 150, "b", "-", 1;
			"hann", 150, "b", "--", 2;
			"hann", 500, "b", "-", 1;
			"hamming", 20, "r", "-.", 1;
			"hamming", 50, "r", ":", 1;
			"hamming", 150, "r", "-", 1;
			"hamming", 500, "r", "-", 1
			};

plot_titles = {};
for i=1:size(settings,1)
	plot_titles{i} = sprintf("%s, M=%d, m=%d", settings{i,1}, 2*settings{i,2}+1, settings{i,5});
end

G = {};
f = {};

for i=1:size(settings, 1)
	M = settings{i,2};
	[G{i}, fi] = spectral_analysis(u, y, settings{i,5}, settings{i,1}, M);
	f{i} = fi/Te;
end

% Plot spectrum
for i=1:size(settings,1)
	p = abs(G{i});
	loglog(f{i}, p, 'Color', settings{i,3}, 'DisplayName', plot_titles{i}, 'LineStyle', settings{i,4});
	hold on;
end

xlabel 'Frequency [rad/s]';
ylabel 'Power';
title 'Frequency response';
grid;
legend('Location','southwest');

figure
sys = {};
sys_true = tf(1, [1, 0.4, 4.3, 0.85, 1]);
sys_true = c2d(sys_true, Te, 'zoh');
resp = frd(sys_true, f{i}); % pi*F
bode(resp)
hold on
for i=1:size(settings,1)
	sys{i} = frd(G{i}, f{i});
end
bode(sys{:})
legend('ground truth', plot_titles{:});
grid;