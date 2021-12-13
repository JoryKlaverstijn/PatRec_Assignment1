% 1. compute the mean and covariance matrix
mat =  [4 5 6; 6 3 9; 8 7 3; 7 4 8; 4 6 5];
disp('Mean of each feature:')
mat_mean = mean(mat)
disp('Covariance matrix:')
mat_cov = cov(mat)

% 2. Model observed data by a normal distribution and compute the
% probability density function in the points [5 5 6], [3 5 7] and [4 6.5 1]
model = normpdf(mat_mean, mat_cov);
model([5,5,6])
