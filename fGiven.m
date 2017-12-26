function [ res ] = fGiven( x, y )
    res = 3.*(x.^3).*exp(x).*cos(x) + y.*sin(4.*y) - cos(y);
%     res = 2.*x.^2.*cos(2.*x) - y.^3.*exp(-y).* sin(y);
end

