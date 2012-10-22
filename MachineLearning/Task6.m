function B = Task6(A)
% Fill all zero-values in vector A by previous nonzero-value from A

idx = find(A);
A(idx(2:end)) = diff(A(idx));
B = cumsum(A);

end