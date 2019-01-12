parametric_identification

addpath('../ce1')

[Gv, fv] = spectral_analysis(Zv.u, Zv.y, 2, 'hann', 50);
validation_system = frd(Gv, fv/tsample);
validation_system.Name = 'Validation Data';

figure
bode(validation_system, '--')
hold on
bode(Marx)
bode(Miv4)
bode(Marmax)
bode(Moe)
bode(Mbj)
bode(Mn4sid)
grid
legend

