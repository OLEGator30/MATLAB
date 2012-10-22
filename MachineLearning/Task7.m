function B = Task7(A, N)
% Repeat each position in vector A N times

B = repmat(A, N, 1);
B = reshape(B, 1, size(A, 2) * N);

end