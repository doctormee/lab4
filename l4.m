%%
clc;
n = 100;
A = complex([1 1;1 1; 1 1],[0 0;0 0; 0 0])
B = complex([2 2;2 2; 2 2],[0 0; 0 0; 0 0]);
C = complex([1 1;1 1; 1 1],[0 0; 0 0; 0 0]);
A = complex(3,4);
B = complex(-1,2);
C = complex(1,4);
%A = complex(0,0)
%B = complex(2,0)
%C = complex(1,0)
[x1, x2, x3, x4] = biquadsolve(A, B, C)
disp(norm(A.*x1.*x1.*x1.*x1 + B.*x1.*x1 + C));
disp(norm(A.*x2.*x2.*x2.*x2 + B.*x2.*x2 + C));
disp(norm(A.*x3.*x3.*x3.*x3 + B.*x3.*x3 + C));
disp(norm(A.*x4.*x4.*x4.*x4 + B.*x4.*x4 + C));
%%
clc;
n = 100;
A = [1 1 1; 1 1 1; 2 1 3];
[Q, R] = gr_c(A)
diff1 = sqrt(sum(sum((A - Q*R).^2)))
[Q1, R1] = qr_M(A)
diff2 = sqrt(sum(sum((A - Q1*R1).^2)))
[Q2, R2] = qr(A)
diff3 = sqrt(sum(sum((A - Q2*R2).^2)))
%%
n = 40;
t1 = zeros(1, n);
t2 = zeros(1, n);
t3 = zeros(1, n);
diff1 = zeros(1, n);
diff2 = zeros(1, n);
diff3 = zeros(1, n);
x = 2: n;
A = [4 2; 5 3];
for i = 2 : n
    tc1 = 0;
    tc2 = 0;
    tc3 = 0;
    while(abs(det(A)) < 0.00001)
        A = rand(i);
    end;
    for j = 1 :20
    tStart = tic;
    [Q, R] = qr(A);
    tc1 = tc1 + toc(tStart);
    tStart = tic;
    [Q1, R1] = qr_c(A);
    tc2 = tc2 + toc(tStart);
    tStart = tic;
    [Q2, R2] = qr_M(A);
    tc3 = tc3 + toc(tStart);
    end;
    t1(i) = tc1 / n;
    t2(i) = tc2 / n;
    t3(i) = tc3 / n;
    diff1(i) = sqrt(sum(sum((A - Q*R).^2)));
    diff2(i) = sqrt(sum(sum((A - Q1*R1).^2)));
    diff3(i) = sqrt(sum(sum((A - Q2*R2).^2)));
    A = rand(i + 1);
end;
figure(1);
plot(x, t1(2:end), 'k', x, t2(2:end), 'b', x, t3(2 : end), 'm');
grid on;
legend('qr(A)', 'qr_c(A)', 'qr_M(A)');
xlabel('n');
ylabel('t');
title('Latency');
figure(2);
plot(x, diff1(2:end), 'k', x, diff2(2:end), 'b', x, diff3(2 : end), 'm');
grid on;
legend('qr(A)', 'qr_c(A)', 'qr_M(A)');
xlabel('n');
ylabel('y');
title('Accuracy');