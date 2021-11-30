% Function that creates k-means for k-clustering
function [class_labels, means] = k_means(k, datapoints, plus_plus_flag, print_types)
% class labels for all datapoints are randomly set first
class_labels = zeros(length(datapoints), 2);
for i=1:length(datapoints)
    class_labels(i) = randsample(k, 1);
end

% If kmeans++ should be used, prototypes are used as inital means
if plus_plus_flag == true
    means = zeros(k, 2);

    % Initial random prototype
    r_num = randsample(length(datapoints), 1);
    means(1, 1) = datapoints(r_num, 1);
    means(1, 2) = datapoints(r_num, 2);
    datapoints_dist = zeros(length(datapoints), 1);

    for m=2:k
        % Getting the closest mean for every datapoint
        for p=1:length(datapoints)
            r_num = randsample(length(means), 1);
            datapoint = [datapoints(p, 1) datapoints(p, 2)];
            mean_datapoint = [means(r_num, 1) means(r_num, 2)];
            r_dist = eu_dist(datapoint, mean_datapoint);
            [idx, dist] = get_nearest_mean(k, datapoint, means, r_dist, r_num);
            datapoints_dist(p) = dist;
        end
        % Getting probabilities for each datapoint and then selecting based
        % on the probability
        datapoints_dist = datapoints_dist.^2;
        s = sum(datapoints_dist);
        dist_probabilities = datapoints_dist;
        dist_probabilities = dist_probabilities./s;
        idx2 = randsample(1:length(dist_probabilities), 1, true, dist_probabilities);
        means(m, 1) = datapoints(idx2, 1);
        means(m, 2) = datapoints(idx2, 2);
    end
else
    % Calculating starting means the normal way
    means = calc_cluster_means(k, datapoints, class_labels);
end

% Keeping track of means for arrow plotting
previous_means = means;
for m=1:length(means)
    % First iteration of plotting means
    hold on
    plot(means(m, 1), means(m, 2), print_types(m), 'linewidth', 4)
end

% Change variable to keep track of the exit condition for the loop
change = true;
while change == true
    change = false;
    
    % Checking if any datapoint should change cluster
    for p=1:length(datapoints)
        datapoint = [datapoints(p, 1) datapoints(p, 2)];
        mean_datapoint = [means(class_labels(p), 1) means(class_labels(p), 2)];
        current_dist = eu_dist(mean_datapoint, datapoint);
        [idx, dist] = get_nearest_mean(k, datapoint, means, current_dist, class_labels(p));
        current_dist_idx = idx;

        if class_labels(p) ~= current_dist_idx
            class_labels(p) = current_dist_idx;
            change = true;
        end
    end

    % Means calculated via a seperate function because it is used twice
    means = calc_cluster_means(k, datapoints, class_labels);
    
    %Plotting second plot with arrows to see how the means change for each
    %iteration
    for m=1:length(means)
        hold on
        plot(means(m, 1), means(m, 2), print_types(m), 'linewidth', 4)
        plot_arrow(previous_means(m, 1), previous_means(m, 2), means(m, 1), means(m, 2))
    end
    previous_means = means;
end
ylim([-4, 4])
xlim([-8, 8])
end