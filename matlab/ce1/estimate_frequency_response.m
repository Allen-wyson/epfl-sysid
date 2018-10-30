function [sys, f] = estimate_frequency_response(period_len, n_periods, in, out, Te) 
	% period len: the length of one period
	% n_periods: the number of periods present in the signal
	% in: the input signal applied to the system to be identified
	% out: response of the signal
	% Te: the sampling interval
	% returns: sys: a MATLAB frequency model, f: a vector of frequencies

	fft_in = zeros(period_len, 1);
	fft_out = zeros(period_len, 1);

	% Skip first period --> we want stationary behavior 
	for i = 2:n_periods
		fft_in = fft_in + fft(in((i-1)*period_len+1:i*period_len)) ./ period_len;
		fft_out = fft_out + fft(out((i-1)*period_len+1:i*period_len)) ./ period_len;
	end

	fft_in = fft_in ./ (n_periods-1);
	fft_out = fft_out ./ (n_periods-1);

	g = fft_out ./ fft_in; 
	f = 2*pi*(0:1:(period_len-1))' .* (1/Te) / period_len;
	sys = frd(g, f);
end