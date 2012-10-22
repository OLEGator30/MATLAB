function [newA newB] = Task5(A, B)
% Calculate two vectors which consists of values in vectors A and B in
% positions where A_i != 0 and B_i != 0

idx = (A ~= 0) & (B ~= 0);
newA = A(idx);
newB = B(idx);

end