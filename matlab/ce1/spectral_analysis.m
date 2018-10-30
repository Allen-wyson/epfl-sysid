function [G] = spectral_analysis(in, out, window, M)
	%% in: the input signal
	%% out: the output signal
	%% window: one of ['hann', 'hamming', 'none']
	%% the final window size is: 2*M+1
	%% returns: the frequency response

	N = size(in, 1);
	if nargin<3; window='none'; end;
	if nargin<4; M=floor(N/2); end;

	cross_corr = intcor(in, out);
	auto_corr = intcor(in, in);

	w = zeros(N+1, 1);
	low = ceil(N/2)-M;
	high = ceil(N/2)+M;
	% we place in window in the middle of the 'w' vector between the
	% indices 'low' and 'high'. Note that the correlation functions are
	% symmetric around the index at half the length.
	if strcmp(window, "hann")
		w(low:high) = hann(2*M+1);
	elseif strcmp(window, "hamming")
		w(low:high) = hamming(2*M+1);
	else
		w = ones(N+1, 1);
	end

	G = fft(cross_corr.*w)./fft(auto_corr.*w);
end