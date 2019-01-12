parametric_identification

addpath('../ce1')

[Gv, fv] = spectral_analysis(Zv.u, Zv.y, 1, 'hann', 50);
Gv1 = abs(Gv);
[Gv, fv] = spectral_analysis(Zv.u, Zv.y, 1, 'hann', 100);
Gv2 = abs(Gv);
[Gv, fv] = spectral_analysis(Zv.u, Zv.y, 1, 'hann', 150);
Gv3 = abs(Gv);

figure
loglog(fv, Gv1)
hold on
loglog(fv, Gv2)
loglog(fv, Gv3)
legend('50', '100', '150')
grid