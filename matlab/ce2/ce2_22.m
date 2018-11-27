close all;
clear all;

load CE2.mat
N = size(u,1);

in = detrend(u,'constant');
out = detrend(y,'constant');

Z = iddata(out,in,0.03);

Zi = Z(1:1022);
Zv = Z(1023:N);

na = 7;
nb = 5;
nk = 2;

Marx = arx(Zi,[na nb nk]);
figure;
resid(Zv,Marx);
title('arx');


Miv4 = iv4(Zi,[na nb nk]);
figure;
resid(Zv,Miv4);
title('Instrumental Variable');

Marmax = armax(Zi,[na nb na nk]);
figure;
resid(Zv,Marmax);
title('armax');

Moe = oe(Zi,[nb na nk]);
figure;
resid(Zv,Moe);
title('Output error');

Mbj = bj(Zi,[nb na na na nk]);
figure;
resid(Zv,Mbj);
title('box jenkins');

Mn4sid = n4sid(Zi,[7]);
figure;
resid(Zv,Mn4sid);
title('state space');


