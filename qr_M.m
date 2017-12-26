function [Q, R] = qr_M(A)
moe = 0.00000000001;
[m, n] = size(A);
if (m~= n)
    disp('Error');
    return;
end;
Q = zeros(n, n);
R = zeros(n, n);
bufq = zeros(1, n);
bufa = zeros(1, n);
for j = 1 : n
    for k = 1 : n
        Q(k, j) = A(k, j);
    end;
    for i = 1 : j-1
        for k = 1 : n
            bufq(k) = Q(k, i);
            bufa(k) = A(k, j);
        end;
        R(i, j) = sum(bufq .* bufa);
        for k = 1 : n
            Q(k, j) = Q(k, j) - R(i, j) * Q(k, i);
        end;
    end;
    for k = 1 : n
        bufq(k) = Q(k, j);
    end;
    R(j, j) = norm(bufq);
    if (abs(R(j, j)) < moe)
        disp('Bad matrix');
        return;
    end;
    for k = 1 : n
        Q(k, j) = Q(k, j) / R(j, j);
    end;
end;
end