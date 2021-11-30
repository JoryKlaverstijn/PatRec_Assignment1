datapoints = load("kmeans1.mat").kmeans1;
[class_labels, means, start_means] = k_means(8, datapoints);

print_types = ["go" "r+" "bo" "m+" "co" "y+" "b+" "ro"];

% Plotting all datapoints
for p=1:length(datapoints)
    plot(datapoints(p, 1), datapoints(p, 2), print_types(class_labels(p)))
    hold on
end

% Plotting means
for m=1:length(means)
    plot(means(m, 1), means(m, 2), "k+", 'linewidth', 4)
end
ylim([-4, 4])
xlim([-8, 8])
%hold off

% Plotting second plot with arrows
for m=1:length(means)
    plot_arrow(start_means(m, 1), start_means(m, 2), means(m, 1), means(m, 2))
end


