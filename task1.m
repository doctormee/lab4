clear;
clc;
u1Zero = 1;
u2Zero = -1;
M = 200;
N = 200;
mju = 1;
x = linspace(0, 1, M + 1);
xStep = 1 ./ M;
y = linspace(0, 1, N + 1);
yStep = 1 ./ N;
[yGrid, xGrid] = meshgrid(y, x);

mat = real(uNumerical(u1Zero, u2Zero, mju, M, N));
anaMat = uAnalytical(xGrid, yGrid, mju, u1Zero, u2Zero);
mat(:, end + 1) = mat(:, 1);
mat(end + 1, :) = mat(1, :);
numSurface = surf(xGrid, yGrid, mat);
set(numSurface,'FaceColor',[1 0 0],'FaceAlpha',1);
hold on;
anaSurface = surf( xGrid, yGrid, anaMat);
set(anaSurface,'FaceColor',[0 1 0],'FaceAlpha',0.5);
legend('Numerical', 'Analytical');
title('Solutions');
xlabel('X');
ylabel('Y');
zlabel('U(x, y)');
% figure;
% someMat = real(solveDirichlet(@(x, y) -2.*(sin(pi.*x) + sin(pi*y)), @(x) sin(pi.*x), ...
%     @(x) sin(pi.*x), 1, M, N));
% surf( xGrid, yGrid, abs(someMat - sin(pi.*xGrid) - sin(pi.*yGrid)));

% title('Another boundaries (abs diff between analytical and numerical)');
% xlabel('X');
% ylabel('Y');
% zlabel('U(x, y)');

figure;
surf( xGrid, yGrid, abs(anaMat - mat));
title('Absolute difference between numerical and analytical solutions');
xlabel('X');
ylabel('Y');
zlabel('Difference');
find(abs(mat(:, 1) -  uAnalytical(x,zeros(size(x)),mju,u1Zero,u2Zero).') > .0001)
find(abs(mat(1, :) -  uAnalytical(zeros(size(y)),y,mju,u1Zero,u2Zero)) > .0001)

