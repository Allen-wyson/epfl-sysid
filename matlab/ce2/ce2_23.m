parametric_identification

addpath('../ce1')

figure;
compare(Zv,Marx,Miv4,Marmax,Moe,Mbj,Mn4sid);
grid

figure; compare(Zv,Marx);
figure; compare(Zv,Miv4);
figure; compare(Zv,Marmax);
figure; compare(Zv,Moe);
figure; compare(Zv,Mbj);
figure; compare(Zv,Mn4sid);

[Gv, fv] = spectral_analysis(Zv.u, Zv.y, 2, 'hann', 50);
validation_system = frd(Gv, fv/tsample);
validation_system.Name = 'Validation Data';

figure
bode(validation_system, '--')
hold on
bode(Marx); bode(Miv4); bode(Marmax)
bode(Moe); bode(Mbj); bode(Mn4sid)
grid; legend

figure; resid(Zv,Marx); title('ARX');
figure; resid(Zv,Miv4); title('Instrumental Variable');
figure; resid(Zv,Marmax); title('ARMAX');
figure; resid(Zv,Moe); title('Output Error');
figure; resid(Zv,Mbj); title('Box Jenkins');
figure; resid(Zv,Mn4sid); title('State Space');

