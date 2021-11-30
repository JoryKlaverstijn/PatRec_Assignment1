% Function that calculates the nearest mean point for a datapoint
function [idx, dist] = get_nearest_mean(k, datapoint, means, current_dist, current_dist_idx)

% The closest mean is based on the cluster the point is currently in (current)
% and the means of the other clusters in the dataset.
for j=1:k
    mean_datapoint = [means(j, 1) means(j, 2)];
    dist = eu_dist(mean_datapoint, datapoint);
    if current_dist > dist
        current_dist = dist;
        current_dist_idx = j;
    end
end
% Returning index and distance values
idx = current_dist_idx;
dist = current_dist;