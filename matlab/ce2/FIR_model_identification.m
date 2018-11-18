function [yh,theta,sigma, J] = FIR_model_identification(input, output, m) 
    % input: input signal
    % output: output signal
    % m: number of parameters
    % yh: predictor for output
    % theta: parameter vector
    % sigma: standard deviation of the parameter estimates

    %% Paramter vector
    
    tpl = zeros(m,1);
    tpl(1,1) = input(1,1);

    phi = toeplitz(input, tpl); % Toeplitz matrix phi
    theta = phi \ output; % backslash operator uses Moore-Penrose pseudo inverse

    %% Predicted output and loss function

    yh = phi * theta; 
    J = (norm(output-yh))^2;

    %% Estimate noise variance

    N = size(input, 1);
    var_est = 1/(N-m) * J;
    
    %% Standard deviation

    covar = var_est * inv(phi' * phi);
    sigma = sqrt(diag(covar));

end