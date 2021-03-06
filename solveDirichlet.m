function [ res ] = solveDirichlet( fHandle, xiHandle, etaHandle, mju, M, N )
    x = linspace(0, 1, M + 1);
    xStep = 1 ./ M;
    y = linspace(0, 1, N + 1);
    yStep = 1 ./ N;
    n = 1:N;
    m = 1:M;
    theta = @(k, l) 1 ./ ((-4 ./ xStep.^2) .* sin(pi .* (k - 1) ./ M) .^2 + ...
        (-4 ./ yStep.^2) .* sin(pi .* (l - 1) ./ N) .^2 - mju);
    phi = zeros(M, N);
    [yGrid, xGrid] = meshgrid(y(2:(end - 1)), x(2:(end - 1)));
    [nGrid, mGrid] = meshgrid(n, m);
    Theta = theta(mGrid, nGrid);
    phi(2:end, 2:end) = fHandle(xGrid, yGrid); %now we know all phies, except first ones
    Phi0 = fft2(phi);
    %here we try to find phi(0, i), phi (i, 0) and phi(0, 0) via solving a
    %SLAE:
    %this would be useful later on:
    indicesM = repmat(1:M, M, 1);
    indicesM = abs(indicesM - indicesM.') + 1;
    
    indicesN = repmat(1:N-1, N - 1, 1);
    indicesN = abs(indicesN - indicesN.') + 1;
    
    thetaIfft2 = ifft2(Theta);
    thetaFft2 = fft2(Theta);
    
    firstColI = thetaIfft2(:, 1);
    firstCol = (1./ (M * N)) .* thetaFft2(:, 1);
    firstRowI = thetaIfft2(1, :).';
    firstRow = (1./ (M * N)) .* thetaFft2(1, :).';
    
    A12 = ifft(fft(Theta, [], 2), [], 1);
    A12 = A12(:, 2:end) .* (1 ./ N);
    
    A21 = ifft(fft(Theta, [], 1), [], 2);
    A21 = A21(:, 2:end).' .* (1 ./ M);
    
    extVec = [0; firstCol];
    ind = triu(indicesM) + 1 - eye(M);
    A11 = extVec(ind);
    extVec = [0; firstColI];
    ind = tril(indicesM) + 1;
    A11 = A11 + extVec(ind);
    
    extVec = [0; firstRow];
    ind = triu(indicesN) + 1 - eye(N - 1);
    A22 = extVec(ind);
    extVec = [0; firstRowI];
    ind = tril(indicesN) + 1;
    A22 = A22 + extVec(ind);
    
    A = [A11, A12; A21, A22];
    %now we have to find the right-side of the linear system
    yZero = [xiHandle(x(1:(end-1))), etaHandle(y(2:(end - 1)))].';
    Phi0Theta = ifft2(Phi0 .* Theta);
    Phi0Theta = [Phi0Theta(:, 1); Phi0Theta(1, 2:end).'];
    B = yZero - Phi0Theta;
    %solving the system
    phi0 = linsolve(A, B);
    %updating our phi-matrix
    phi(:, 1) = phi0(1:M);
    phi(1, 2:end) = phi0(M + 1: end).';
    %new Phi
    Phi = fft2(phi);
    %and the Answer, finally
    res = ifft2(Phi .* Theta);
end

