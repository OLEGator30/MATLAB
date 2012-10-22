function res = Task3(A, x)
% Calculate vector y_j = argmin(x_i + A_i_j) for square matrix A and
% vector x

X = repmat(x', 1, size(A, 1));
B = A + X;
[temp res] = min(B);

end