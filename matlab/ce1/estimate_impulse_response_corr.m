function resp = estimate_impulse_response_corr(u, y, K, method)
	% u: input signal
	% y: output signal
	% FIR length
	% method: one of ['intcor_num_dec', 'intcor_simple', 
	%     'xcorr_num_dec', 'xcorr_simple']
	if nargin<4; method = 'intcor_num_dec'; end

	%% Compute auto- and cross correlation 
	if startsWith(method, 'intcor')
		[auto_corr, ha] = intcor(u, u);
		[cross_corr, hc] = intcor(u,y);
	elseif startsWith(method, 'xcorr')
		[auto_corr, ha] = xcorr(u, u,'biased');
		[cross_corr, hc] = xcorr(y,u,'biased');
	else
		error('Method not valid.')
	end

	zero_index = ha(end)+1;
	auto_corr_trunc = auto_corr(zero_index:zero_index+K-1);
	cross_corr_trunc = cross_corr(zero_index:zero_index+K-1);
	h_trunc = ha(zero_index:zero_index+K-1);

	%% Compute impulse response
	if endsWith(method, 'num_dec')
		Ruu = toeplitz(auto_corr_trunc,auto_corr_trunc);
		resp = Ruu \ cross_corr_trunc;
	elseif endsWith(method, 'simple')
		resp = cross_corr_trunc ./ auto_corr_trunc(1);
	else
		error('Method not valid.');
	end
end