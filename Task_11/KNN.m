% K-Nearest Neighbor function
% Created for the Pattern Recognition Master Course, Assignment 1, task 11.
% Group 1

function class = KNN(test_point, K, train_data, train_class_labels)
tr_len = length(train_data);
dist_arr = zeros(1, tr_len);

% The euclidean distance is calculated between the training data points and
% the testing data point
for j = 1:tr_len
    train_point = [train_data(j, 1) train_data(j, 2)];
    dist_arr(j) = eu_dist(test_point, train_point);
end

% The class labels of the training points are sorted in ascending order
% based based on the closest distance to the testing point
[sorted_dist_arr, sort_index] = sort(dist_arr);
sorted_class_labels = train_class_labels(sort_index);
k_arr = zeros(1, K);

% Finally the top K neighbors are selected, from which the most frequent
% class occurence is selected as the output
for j = 1:K
    k_arr(j) = sorted_class_labels(j);
end

% The mode function already picks the value of k arbitrarily so this is fine
class = mode(mode(k_arr));

end