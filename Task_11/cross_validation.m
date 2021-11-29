% Cross validation for K-Nearest Neighbor
% Created for the Pattern Recognition Master Course, Assignment 1, task 11.
% Group 1

function error_arr = cross_validation()

% Loading in data and setting class amount
data = load('task_11').task_11;
nr_of_classes = 2; 

% Class labelling
class_labels = floor( (0:length(data)-1) * nr_of_classes / length(data) );

% Setting error counter values
error_arr = zeros(25, 1);
index_arr = [];
error = 0;

% Loop to check if the cross validation results in the same class label.
% Errors are normalized to the accuracy after the inner loop completes for
% a specific k.
for k=1:2:25
    index_arr(end+1) = k;
    for i=1:length(data)
        n_data = data;
        n_data(i, :) = [];
        test_point = [data(i, 1), data(i, 2)];
        class = KNN(test_point, k, n_data, class_labels);
        if class ~= class_labels(i)
            error = error + 1;
        end
    end
    error_arr(k, 1) = (length(data) - error)/length(data);
    error = 0;
end

% Figure plotting
error_arr(error_arr == 0) = [];
disp(index_arr)
plot(index_arr, error_arr)
xticks(index_arr)
ylim([0, 1])
title(['Cross validation for ' int2str(nr_of_classes) ' classes.'])
xlabel("Number of K-Nearest Neighbors used for calculations")
ylabel("Accuracy on training data (%)")

