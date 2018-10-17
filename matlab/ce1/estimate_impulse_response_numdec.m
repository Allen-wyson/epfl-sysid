function resp = estimate_impulse_response_numerial_deconvolution(u, y, K) 
	%% u: input signal
	%% y: output signal
	%% K: FIR length

	%% Input Toeplitz matrix
	tmp = zeros(size(u,1),1);
	tmp(1,1) = u(1,1);
	input = toeplitz(u, tmp);

	input = input(:,1:K); % truncate input matrix

	resp = input \ y; % backslash operator uses Moore-Penrose pseudo inverse
end