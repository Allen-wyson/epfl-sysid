%% Initialisation and binary random signal

clear all;
clc;
close all;
figure;
method = 'hann';

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

%% Spectral analysis method

cross_corr = intcor(u, y);
auto_corr = intcor(u, u);

phi_yu = fft(cross_corr);
phi_uu = fft(auto_corr);
G = phi_yu ./ phi_uu;
f = 2*pi*(0:1:N)' .* (1/Te) / N;

%% Plots and Windowing

% Plot spectrum
p = abs(G);
loglog(f(1:N/2), p(1:N/2), 'color', [0.9 0.9 0.9], 'DisplayName', 'Plain');
grid
hold on

% Windowed version

for M=20:20:200

	window = zeros(N+1, 1);
	low = ceil(N/2)-M;
	up = ceil(N/2)+M;
    if strcmp(method,'hann')
	window(low:up) = hann(2*M+1);
    else
        if strcmp(method,'hamming')
        window(low:up) = hamming(2*M+1);
        else
            error('Method not valid.')
        end
    end

	cross_corr_windowed = cross_corr .* window;
	auto_corr_windowed = auto_corr .* window;

	phi_yu_windowed = fft(cross_corr_windowed);
	phi_uu_windowed = fft(auto_corr_windowed);
	G_windowed = phi_yu_windowed ./ phi_uu_windowed;
	power = abs(G_windowed);
    
    
    if strcmp(method,'hann')
	loglog(f(1:N/2), power(1:N/2), 'DisplayName', sprintf('Windowed (hann, M=%d)', 2*M+1));
    
    else
        if strcmp(method,'hamming')
        loglog(f(1:N/2), power(1:N/2), 'DisplayName', sprintf('Windowed (hamming, M=%d)', 2*M+1));
        else
            error('Method not valid.')
        end
    end
    

end

xlabel 'Frequency [rad/s]';
ylabel 'Power';
title 'Frequency response';
grid;
legend('Location','southwest');


%% Bode plot (einfach von oben kopiert)

figure;
sys = frd(G,f);
bode(sys,'k');
legendInfo{1} = ['Without window']; 
hold on;
i=2;

for M=20:20:200

	window = zeros(N+1, 1);
	low = ceil(N/2)-M;
	up = ceil(N/2)+M;
    if strcmp(method,'hann')
	window(low:up) = hann(2*M+1);
    else
        if strcmp(method,'hamming')
        window(low:up) = hamming(2*M+1);
        else
            error('Method not valid.')
        end
    end

	cross_corr_windowed = cross_corr .* window;
	auto_corr_windowed = auto_corr .* window;

	phi_yu_windowed = fft(cross_corr_windowed);
	phi_uu_windowed = fft(auto_corr_windowed);
	G_windowed = phi_yu_windowed ./ phi_uu_windowed;
	power = abs(G_windowed);
    
    
    sys_windowed = frd(G_windowed,f);
    bode(sys_windowed);
    
    if strcmp(method,'hann')
	legendInfo{i} = ['Windowed (hann, M =' num2str(2*M+1) ')']; 
    
    else
        if strcmp(method,'hamming')
        legendInfo{i} = ['Windowed (hamming, M =' num2str(2*M+1) ')']; 
        else
            error('Method not valid.')
        end
    end
    
    i= i+1;
    hold on;

end

legend(legendInfo)

axes_handles = findall(gcf, 'type', 'axes');
legend(axes_handles(2),legendInfo, 'Location', 'NorthWest');
legend(axes_handles(3),legendInfo, 'Location', 'SouthWest');



