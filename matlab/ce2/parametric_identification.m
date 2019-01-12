load CE2.mat
N = size(u,1);
tsample = 0.03;

in = detrend(u,'constant');
out = detrend(y,'constant');

Z = iddata(out,in,tsample);

% Data partitioning
Zi = Z(1:ceil(N/2));
Zv = Z(ceil(N/2)+1:N);

% Estimated parameters from Exercise 2.2.1
na = 6; % number of parameters in the denominator 
nb = 4; % number of parameters in the nominator
nk = 2; % input-output delay 

% Arx Model 
Marx = arx(Zi,[na nb nk]);
% Instrumental variables method
Miv4 = iv4(Zi,[na nb nk]);
% Armax model
Marmax = armax(Zi,[na nb na nk]);
% Output error structur
Moe = oe(Zi,[nb na nk]);
% Box-Jenkins strucure
Mbj = bj(Zi,[nb na na na nk]);
% State-Space model 
Mn4sid = n4sid(Zi,[na]);

