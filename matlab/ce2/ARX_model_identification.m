function [yh, ym, theta, sys, J, J_tf] = ARX_model_identification(u, y, iterations) 
    % iterations: amount of iterations for the IV technique
    % yh: predicted output using measured past output
    % ysim: predicted output using the identified transfer function
    % theta: parameter vector
    % sys: identified transfer function model
    % J: prediction loss
    % J_tf: prediction loss of the identified transfer function
    N = size(u,1);

    %% Regressor
    function [phi] = create_phi_matrix(u, y)
        phi = zeros(N,4);
        phi(2,:) = [-y(1), 0, u(1), 0];
        for k=3:N
            phi(k,:)= [-y(k-1),-y(k-2),u(k-1),u(k-2)];
        end
    end

    %% ARX model and IV
    phi = create_phi_matrix(u, y);
    out = y;
    for i=1:iterations
        % Instrumental variables method
        phi_iv = create_phi_matrix(u, out);
        
        % Computing the parameters using least square
        theta = inv(phi_iv' * phi) * phi_iv' * y; s 

        % Transfer function model
        f_sampling = 1e3;
        z = tf('z', 1/f_sampling);
        sys = (theta(3)*(1/z) + theta(4)*(1/z^2)) / ...
                (1 + theta(1)*(1/z) + theta(2)*(1/z^2));

        % Simulate transfer function model
        t = 0:(1/f_sampling):(N-1)*(1/f_sampling);
        ym = lsim(sys, u, t);
        out = ym;
    end

    %% Predicted output and loss function
    yh = phi * theta;
    J = norm(yh - y)^2;
    J_tf = norm(ym - y)^2;

end
