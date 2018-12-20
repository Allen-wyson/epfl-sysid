load CE2.mat

in = detrend(u,'constant');
out = detrend(y,'constant');

Z = iddata(out,in,0.03);

m = 40;

%% FIR Model for estimating the delay with 
% Output error model nb = m, na = 0 and nk = 1 (or d = 0) 

FIR = oe(Z,[m 0 1]);

figure;
stairs(0:m,FIR.b);
title('FIR model with m = 40');
figure;
title('Paramters and their confidence interval');
errorbar(FIR.b(1:6), 2*FIR.db(1:6));
