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

n = sum(cumsum(singular_values)>=0.95*(sum(singular_values))); 
disp(sprintf("Estimated order of the system: %d", n))
O = Q(:,1:n);

C = O(1,:);
A = pinv(O(1:(r-1),:)) * O(2:r,:);


q = tf('z');
F = C*inv(q*eye(n) - A);
uf = zeros(N, n);
for i=1:n
	uf(:,i) = lsim(F(i), u);
end
B = pinv(uf) * y;
D = 0;
sys = ss(A,B,C,D,1e-3);
[y_sys, t_sys, x_sys] = lsim(sys, u);

figure
plot(singular_values);
title 'Singular values of Q';

figure
plot(t_sys, y_sys);
hold on
stairs(0:1e-3:(N-1)*1e-3, y, 'r')
legend("simulated", "input data")
grid

figure
plot(t_sys, x_sys);
legend("x_1", "x_2", "x_3")

