Te = 0.5;
saturation_limit = 0.5;
Tend = 100;
Tstep = 1;

in.signals.values = [zeros(1,Tstep/Te) saturation_limit*ones(1,1+(Tend-Tstep)/Te)]';
in.time = (0:Te:Tend)';

sim('ce1');

subplot(2,1,1)
plot(out.Time, out.Data)
hold on
plot(in.time, in.signals.values);
grid
title('Step Response')
xlabel 'Time [s]'

in.signals.values = [saturation_limit zeros(1,Tend/Te)]';
sim('ce1')

subplot(2,1,2)
plot(out.Time, out.Data);
hold on;
plot(in.time, in.signals.values);
grid
title('Impulse Response')
xlabel 'Time [s]'
