function B = Task8(A)
% Find the maximum element in the vector A from elements in positions
% after zero elements

B = max(A(find(~A(1:end - 1)) + 1));

end