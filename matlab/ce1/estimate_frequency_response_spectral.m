function [sys_windowed, sys, G_windowed, G, F] = estimate_frequency_response_spectral(u, y, Te, N, M, method)
	% in: the input signal applied to the system to be identified
	% out: response of the signal
	% Te: the sampling interval
    % Numer
	% returns:  sys_windowed: a windowed MATLAB frequency model, 
    %           sys: a MATLAB frequency model, 
    %           G_windowed: a windowed freqency response, 
    %           G: a  freqency response, 
    %           F: vector of frequencies

    F = 2*pi*(0:1:N)' .* (1/Te) / N;
    cross_corr = intcor(u, y);
    auto_corr = intcor(u, u);
    
    
    %% Analysis without window
    
    phi_yu = fft(cross_corr);
    phi_uu = fft(auto_corr);
    G = phi_yu ./ phi_uu;
    sys = frd(G, F);
    
    %% Windowing
    window = zeros(N+1,1);

    low = ceil(N/2)-M;
    up = ceil(N/2)+M;

    if strcmp(method,'hann') % selecting hann or hamming windos
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

    sys_windowed = frd(G_windowed, F);

   
end