syms u1(x);
syms u2(y) mu u1Zero u2Zero;
f1 = @(x) 3.*(x.^3).*exp(x).*cos(x);
f2 = @(y)  + y.*sin(4.*y) - cos(y);
part1 = dsolve(diff(u1, 2) - mu*u1 == f1, u1(0) == u1Zero, u1(1) == u1Zero);
part2 = dsolve(diff(u2, 2) - mu*u2 == f2, u2(0) == u2Zero, u2(1) == u2Zero);
