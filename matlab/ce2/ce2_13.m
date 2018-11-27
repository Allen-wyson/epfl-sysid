close all;

load laserbeamdataN.mat
N = size(u,1);

r = 10;

Y = zeros(r, N);
U = zeros(r, N);

for i=1:N
	for j=1:r
		k = i+j-1;
		if k > N
			Y(j,i) = 0;
			U(j,i) = 0;
		else
			Y(j,i) = y(k);
			U(j,i) = u(k);
		end
	end
end

U_orth = eye(N) - U' * inv(U*U') * U;
Q = Y * U_orth;
singular_values = svd(Q);

n = 3; % TODO: make this automatically
O = Q(:,1:n);

C = O(1,:);
A = pinv(O(1:(r-1),:)) * O(2:r,:);

q = 0;
F = C*inv(q*eye(n) - A);
uf = zeros(N, n);
for i=1:N
	uf(i,:) = F*u(i);
end
B = pinv(uf)*y;
D = 0;
sys = ss(A,B,C,D,-1);


figure
plot(singular_values);
title 'Singular values of Q';

figure
lsim(sys,u);
hold on
plot(y, 'r')



