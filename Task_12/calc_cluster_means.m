% Function that calculates the mean point of a number of datapoints
function means = calc_cluster_means(k, datapoints, class_labels)
means = zeros(k, 2);

% Calculating the means of the clusters based on class labels
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