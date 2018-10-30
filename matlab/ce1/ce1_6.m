N = 2000;
u = randi(2, N, 1) - 1.5;
init

Tend = (N-1)*Te;
t = (0:Te:Tend)'; 

simin.signals.values = u;
simin.time = t;
sim('ce1');
y = simout.Data;


cross_corr = intcor(u, y);
auto_corr = intcor(u, u);

phi_yu = fft(cross_corr);
phi_uu = fft(auto_corr);
G = phi_yu ./ phi_uu;
f = 2*pi*(0:1:N)' .* (1/Te) / N;

% Plot spectrum
p = abs(G);
loglog(f(1:N/2), p(1:N/2), 'yellow', 'DisplayName', 'Plain');
grid
hold on

% Windowed version

for i=20:20:100

	window = zeros(N+1, 1);
	M = i;
	low = ceil(N/2)-M;
	up = ceil(N/2)+M;
	window(low:up) = hann(2*M+1);

	cross_corr_windowed = cross_corr .* window;
	auto_corr_windowed = auto_corr .* window;

	phi_yu_windowed = fft(cross_corr_windowed);
	phi_uu_windowed = fft(auto_corr_windowed);
	G_windowed = phi_yu_windowed ./ phi_uu_windowed;
	power = abs(G_windowed);
	loglog(f(1:N/2), power(1:N/2), 'DisplayName', sprintf('Windowed (hann, M=%d)', 2*i+1));
end

legend;