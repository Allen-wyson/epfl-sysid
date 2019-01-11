close all;
clear all;

load CE2.mat
N = size(u,1);
Z = iddata(y,u,0.03);

for n= 1:10
    M = arx(Z,[n n 1]);
    J(n) = M.EstimationInfo.LossFcn;
end

plot(J);
ylabel("J(\theta)")
xlabel("Model Order n")
grid

% zero-pole cancellation
M4 = armax(Z,[4 4 4 1]);
figure;
h = iopzplot(M4);
title('n=4');
axis([-1 1 -1 1]);
showConfidence(h,2);

M5 = armax(Z,[5 5 5 1]);
figure;
h = iopzplot(M5);
title('n=5');
axis([-1 1 -1 1]);
showConfidence(h,2);

M6 = armax(Z,[6 6 6 1]);
figure;
h = iopzplot(M6);
title('n=6');
axis([-1 1 -1 1]);
showConfidence(h,2);

figure;
impulse(M6)

M7 = armax(Z,[7 7 7 1]);
figure;
h = iopzplot(M7);
title('n=7');
axis([-1 1 -1 1]);
showConfidence(h,2);


M8 = armax(Z,[8 8 8 1]);
figure;
h = iopzplot(M8);
title('n=8');
axis([-1 1 -1 1]);
showConfidence(h,2);

M9 = armax(Z,[9 9 9 1]);
figure;
h = iopzplot(M9);
title('n=9');
axis([-1 1 -1 1]);
showConfidence(h,2);

Model_of_choice = M4;

figure;
errorbar(0:1:size(Model_of_choice.b, 2)-1, Model_of_choice.b, 2*Model_of_choice.db);
grid

comb = struc(1:10, 1:10, 1:10);
Marx = arxstruc(Z,Z,comb);
orderarx = selstruc(Marx);


