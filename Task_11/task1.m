features = load("task_1.mat").task_1;

correlations = [];
for i = 1:3
    for j = 1:3
        covariance = cov(features(:, i), features(:, j));
        covariance = covariance(1, 2);
        correlation = covariance / (std(features(:, i)) * std(features(:, j)));
        correlations(i, j) = correlation;
    end
end

disp(correlations);

% Plot the height vs. weight scatter plot
figure()
scatter(height, weight)
xlabel('height (cm)')
ylabel('weight (kg)')
title('Plot A: height vs. weight')

% Plot the weight vs age scatter plot
figure()
scatter(weight, age)
xlabel('weight (kg)')
ylabel('age')
title('Plot B: weight vs. age')