load CE2.mat

t_sample = 0.03

in = detrend(u,'constant');
out = detrend(y,'constant');

Z = iddata(out,in,t_sample);

m = 40; % Number of parameters

%% FIR Model for estimating the delay with 
% Output error model nb = m, na = 0 and nk = 1 (or d = 0) 

FIR = oe(Z,[m 0 1]);

figure;
stairs(0:m,FIR.b); grid;
title('FIR model with m = 40');
figure;
title('Paramters and their confidence interval');
errorbar(FIR.b(1:7), 2*FIR.db(1:7)); grid;
