datapoints = load("checkerboard.mat").checkerboard;

% Creating a large array of colour types so the clusters can be more easily
% distinguished
print_types_def = ["go" "r+" "bo" "m+" "co" "y+" "b+" "ro"];
print_types = print_types_def;
for i=1:14
    print_types = [print_types print_types_def];
end

% Uncomment next code block to run the statistical analysis from stat_analysis.m
% q_error_flag_false = stat_analysis(20, datapoints, false, print_types);
% q_error_flag_true = stat_analysis(20, datapoints, true, print_types);
% [h, p, ci, stats] = ttest2(q_error_flag_true, q_error_flag_false);
% disp("T-test results")
% disp(['Test statistic = ', num2str(h)])
% disp(p)
% disp(ci)
% disp(stats)

[class_labels, means] = k_means(100, datapoints, false, print_types);

% Making scatterplots
figure()
for p=1:length(datapoints)
    hold on
    plot(datapoints(p, 1), datapoints(p, 2), print_types(class_labels(p)))
end

% Plotting means
for m=1:length(means)
    plot(means(m, 1), means(m, 2), "k+", 'linewidth', 4)
end
ylim([-4, 4])
xlim([-8, 8])



