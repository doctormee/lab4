function [ res ] = uNumerical( u1Zero, u2Zero, mju, M, N )
    res = solveDirichlet(@fGiven, @(x)uAnalytical(x, zeros(size(x)), ...
        mju, u1Zero, u2Zero), @(y)uAnalytical(zeros(size(y)), y, ...
        mju, u1Zero, u2Zero), mju, M, N);
    

end

