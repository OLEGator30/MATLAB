function res = Task2(N)
% Calculate the area of a quarter circle of radius 1 with use of
% Monte-Carlo simulation with 1:10:N random points

vec = zeros(1, N);
for k = 1:10:N;
    temp1 = rand(N, 2);
    d = diag(temp1 * temp1');
    temp2 = double(d < ones(size(d)));
    vec(k:k+9) = sum(temp2) / length(temp2);
end
res = median(vec);
plot(1:N, vec);

end