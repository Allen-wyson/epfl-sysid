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

settings = {"none", N, "[.6, .6, .6]", "-";
			"hann", 20, "b", "-.";
			"hann", 50, "b", ":";
			"hann", 150, "b", "--";
			"hann", 500, "b", "-";
			"hamming", 20, "r", "-.";
			"hamming", 50, "r", ":";
			"hamming", 150, "r", "--";
			"hamming", 500, "r", "-"};

plot_titles = ['No window'];
for i=2:size(settings,1)
	plot_titles = [plot_titles, sprintf("Windowed (%s, M=%d)", settings{i,1}, 2*settings{i,2}+1)];
end

G = zeros(2*ceil(N/2)+1,size(settings, 1));
f = 2*pi*(0:1:N)' .* 1/(Te*N);

for i=1:size(settings, 1)
	M = settings{i,2};
	G(:,i) = spectral_analysis(u, y, settings{i,1}, M);
end

% Plot spectrum
for i=1:size(settings,1)
	p = abs(G(:,i));
	loglog(f(1:N/2), p(1:N/2), 'Color', settings{i,3}, 'DisplayName', plot_titles{i}, 'LineStyle', settings{i,4});
	hold on;
end

xlabel 'Frequency [rad/s]';
ylabel 'Power';
title 'Frequency response';
grid;
legend('Location','southwest');

sys = {};
figure
for i=1:size(settings,1)
	sys{i} = frd(G(:,i), f);
end
bode(sys{:})
legend(plot_titles);
grid;