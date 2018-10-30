function [G, f] = spectral_analysis(in, out, m, window, M)
	%% in: the input signal
	%% out: the output signal
	%% m: amount of groups (for a single group set m=1)
	%% window: one of ['hann', 'hamming', 'none']
	%% the final window size is: 2*M+1
	%% returns: G: the frequency response G
	%% returns: f: a normalized frequency vector at unit sample rate

	N = size(in, 1);
	if nargin<4; window='none'; end
	if nargin<5; M=floor(N/2); end

	n = floor(size(in,1)/m); % samples per group
    cor_len = 2*ceil(n/2)+1;
	G = zeros(cor_len, 1);

	% we place in window in the middle of the 'w' vector between the
	% indices 'low' and 'high'. Note that the correlation functions are
	% symmetric around the index at half the length.
	w = zeros(cor_len, 1);
	low = ceil(cor_len/2)-M;
	high = ceil(cor_len/2)+M;
	if strcmp(window, "hann")
		w(low:high) = hann(2*M+1);
	elseif strcmp(window, "hamming")
		w(low:high) = hamming(2*M+1);
	else
		w = ones(cor_len, 1);
	end

	for i=1:m
		u = in((i-1)*n+1:i*n);
		y = out((i-1)*n+1:i*n);
		cross_corr = intcor(u, y);
		auto_corr = intcor(u, u);
		G = G + fft(cross_corr.*w)./fft(auto_corr.*w);
	end
	G = G ./ m;
	f = 2*pi*(0:1:cor_len-1)' ./ cor_len;
end