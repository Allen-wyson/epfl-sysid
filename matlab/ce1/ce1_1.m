clc;
close all;
 
Te = 0.5;
Tend = 100;
Tstep = 1;
 
saturation_limit = 0.5;
 
simin = struct('signals',zeros(1+Tend/Te,1), 'time',(0:Te:Tend)');
simin.signals = struct('values',[zeros(Tstep/Te,1); saturation_limit*ones(1+(Tend-Tstep)/Te,1)]);
 
sim('ce1');
 
figure('Name','Exercise CE-1 1.1 Step response','NumberTitle','off');

subplot(2,1,1);
plot(simout.Time, simout.Data, 'b');
hold on;
plot(simin.time, simin.signals.values, 'r');
grid;
title('Step Response');
xlabel 'Time [s]';
legend('step response','input step');
 
simin.signals.values = [saturation_limit zeros(1,Tend/Te)]';
sim('ce1')
 
subplot(2,1,2);
plot(simout.Time, simout.Data, 'color', [0, 0.5, 0]);
hold on;
plot(simin.time, simin.signals.values,'color', [1, 0.5, 0]);
grid;
title('Impulse Response');
xlabel 'Time [s]';
legend('impulse response','input impulse');

