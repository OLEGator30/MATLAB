function res = Task4(X, Y)
% Calculate distance between matrix X N-by-Q and matrix Y M-by-Q

x = diag(X * X');
XX = repmat(x, 1, size(Y, 1));
y = diag(Y * Y');
YY = repmat(y', size(X, 1), 1);
XY = -2 * X * Y';
res = sqrt(XX + XY + YY);

end