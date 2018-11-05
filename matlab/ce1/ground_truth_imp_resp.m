Ts = 0.5; % Sampling frequency
num = [1]; % Numerator of transfer function
den = [1, 0.4, 4.3, 0.85, 1]; % Denominator of transfer function

sys = tf(num, den); % continuous system
dsys = c2d(sys, Ts, 'zoh'); % discretized system

% MATLAB computes the discrete impulse response for 1s of impulse, but
% we want it for 1 sample. Therefore, we multiply by the sampling period.
dsys = Ts*dsys; 

g = impulse(dsys, 'r');
