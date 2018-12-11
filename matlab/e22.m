clear all;
close all;
clc;


z = tf('z');
G = (z+2)/((z-0.5)*(z^2 -1.5*z + 0.7));

p = pole(G);

N = 1000;
u = rand(N,1)-0.5;
t = (0:1:N-1);

y = lsim(G,u,t) + 0.1*rand(N,1);
Z = iddata(y,u,1);


%% Loss function

for n=1:10
    M = arx(Z,[n n 1]);
    C(n) = M.EstimationInfo.LossFcn;
end

%% Zero pole cancellation

M3 = armax(Z,[3 3 3 1]); figure; h = iopzplot(M3); axis([-1 1 -1 1]); showConfidence(h,2);
M4 = armax(Z,[4 4 4 1]); figure; h = iopzplot(M4); axis([-1 1 -1 1]); showConfidence(h,2);
M5 = armax(Z,[5 5 5 1]); figure; h = iopzplot(M5); axis([-1 1 -1 1]); showConfidence(h,2);
M6 = armax(Z,[6 6 6 1]); figure; h = iopzplot(M6); axis([-1 1 -1 1]); showConfidence(h,2);

%% Delay

M30 = oe(Z,[30 0 1])
stairs(0:30,M30.b);
[M30.b(1:5);2*M30.db(1:5)]

%% Estimation of nb

Mb2 = arx(Z,[3 2 2]); J2 = Mb2.EstimationInfo.LossFcn
Mb1 = arx(Z,[3 1 2]); J1 = Mb1.EstimationInfo.LossFcn

nn = struc(1:10,1:10,1:10);
V = arxstruc(Z,Z,nn);
selstruc(V);


%% Identification

Zi = Z(1:500); Zv = Z(501:1000);
Marx = arx(Zi,[3 2 2]);
Marmax = armax(Zi,[3 2 3 2]);
Moe = oe(Zi,[2 3 2]);
Mbj = bj(Zi,[2 3 3 3 2]);
Mss = n4sid(Zi, 3);
figure;
compare(Zv,Marx,Marmax,Moe,Mbj,Mss);









