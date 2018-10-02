function [phi, h] = intcor(u, y)
    % we assume same length for the signals u and y
    len = size(u,1);
    
    half = ceil(len/2);
    h = (-half:1:half)';
    phi = zeros(size(h, 1), 1);
    M = size(h,1);
    
    for i = 1:M
        phi(i) = sum(u .* circshift(y, -h(i)));
    end
    phi = 1/len * phi;
end

