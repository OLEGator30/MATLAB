function [mean cov] = Task1(MAT)
% Calculate sample mean and covariance matrix for matrix MAT

mean = sum(MAT) / size(MAT, 1);
temp = MAT - repmat(mean, size(MAT, 1), 1);
cov = temp' * temp;

end