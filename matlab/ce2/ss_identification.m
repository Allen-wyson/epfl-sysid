function [A, B, C, D] = ss_identification(u, y)
	%u: input signal
	%y: output signal
	% returns: the identified state space model matrices

	N = size(u,1);
	r = 10;
	thrshld = 0.8;

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

	% Create extended observability matrix and estimate model order
	U_orth = eye(N) - U' * inv(U*U') * U;
	Q = Y * U_orth;
	singular_values = svd(Q);
	n = find(cumsum(singular_values)./sum(singular_values) >= thrshld, 1, 'first');
	fprintf('Estimated order of the system (using %d%%): %d\n', 100*thrshld, n)
	O = Q(:,1:n);

	% Compute estimates for A and C
	C = O(1,:);
	A = pinv(O(1:(r-1),:)) * O(2:r,:);

	% Construct the signals u_{f_i}
	q = tf('z');
	F = C*inv(q*eye(n) - A);
	uf = zeros(N, n);
	for i=1:n
		uf(:,i) = lsim(F(i), u);
	end

	% Compute estimates for B and D
	B = pinv(uf) * y;
	D = 0;
end