N = 2000;
u = randi(2, N, 1) - 1.5;
init

Tend = (N-1)*Te;
t = (0:Te:Tend)'; 

simin.signals.values = u;
simin.time = t;
sim('ce1');
y = simout.Data;

G = spectral_analysis(u, y);
f = 2*pi*(0:1:N)' .* 1/(Te*N);

% Plot spectrum
p = abs(G);
loglog(f(1:N/2), p(1:N/2), 'Color', [.5 .5 .5], 'DisplayName', 'Plain');
grid
hold on

window_sizes = [20, 50, 150, 500];
linestyles = ["-.", ":", "--", "-"];
% Windowed version
for i=[window_sizes; linestyles]
	M = str2num(i(1));
	G_windowed = spectral_analysis(u, y, 'hann', M);
	power = abs(G_windowed);
	loglog(f(1:N/2), power(1:N/2), 'Color', 'b', 'DisplayName', sprintf('Windowed (hann, M=%d)', 2*M+1), 'LineStyle', i(2));
end

for i=[window_sizes; linestyles]
	M = str2num(i(1));
	G_windowed = spectral_analysis(u, y, 'hamming', M);
	power = abs(G_windowed);
	loglog(f(1:N/2), power(1:N/2), 'Color', 'r', 'DisplayName', sprintf('Windowed (hamming, M=%d)', 2*M+1), 'LineStyle', i(2));
end

legend;