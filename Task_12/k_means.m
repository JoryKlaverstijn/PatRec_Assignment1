function [class_labels, means, start_means] = k_means(k, datapoints)

% Assigning initial random class labels
class_labels = zeros(length(datapoints), 1);
for i=1:length(datapoints)
    class_labels(i) = randsample(k, 1);
end
start_means = zeros(k, 2);
means = zeros(k, 2);
change = true;
while change == true
    change = false;
    % Calculating the means of the clusters
    for j=1:k
        sum = [0 0];
        count = 0;
        for p=1:length(datapoints)
            if class_labels(p) == j
                sum = [(sum(1, 1) + datapoints(p, 1)) (sum(1, 2) + datapoints(p, 2))];
                count = count + 1;
            end
        end
        % A check has to be made if the cluster is currently empty,
        % otherwise division by 0 occurs
        if count == 0
            means(j, 1) = sum(1,1);
            means(j, 2) = sum(1,2);
        else
            means(j, 1) = sum(1, 1)/count;
            means(j, 2) = sum(1, 2)/count;
        end 
    end

    if start_means == zeros(k, 2)
        start_means = means;
    end
    
    % Checking if any datapoint should change cluster
    for p=1:length(datapoints)
        current_dist = eu_dist(means(class_labels(p)), datapoints(p));
        current_dist_idx = class_labels(p);
        for j=1:k
            dist = eu_dist(means(j), datapoints(p));
            if current_dist > dist
                current_dist = dist;
                current_dist_idx = j;
            end
        end
        if class_labels(p) ~= current_dist_idx
            class_labels(p) = current_dist_idx;
            change = true;
        end
    end
end