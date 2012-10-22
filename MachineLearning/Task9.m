function res = Task9(A, B)
% Calculate vector [A(1):B(1) A(2):B(2) ... A(end):B(end)] for vectors A
% and B of the same size

idx1 = A > B;
A(idx1) = [];
B(idx1) = [];
temp1 = B - A + 1;
size = sum(temp1);
res = zeros(1, size);
temp2 = res;
temp1(1) = temp1(1) + 1;
idx2 = cumsum(temp1(1:end - 1));
res([1 idx2]) = A;
res(~res) = 1;
res = cumsum(res);
temp2(idx2) = B(1:end - 1);
res = res - cumsum(temp2);

end