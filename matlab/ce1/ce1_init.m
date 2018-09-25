Te = 0.5;
saturation_limit = 0.5;
Tend = 100;
Tstep = 1;

in.signals.values = [zeros(1,Tstep/Te) saturation_limit*ones(1,(Tend-Tstep)/Te)];
in.time = 0:Te:Tend;