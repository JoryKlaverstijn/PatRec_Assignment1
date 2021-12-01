% Function that calculates the quantization error 
function q_error = stat_analysis(it, datapoints, plus_plus_flag, print_types)
q_error = (it);

% The k_means algorithm is run iteration times, with k = 100
for i=1:it
    [class_labels, means] = k_means(100, datapoints, plus_plus_flag, print_types);
    for p=1:length(datapoints)
        datapoint = [datapoints(p, 1) datapoints(p, 2)];
        mean_datapoint = [means(class_labels(p), 1) means(class_labels(p), 2)];
        q_error(i) = + eu_dist(datapoint, mean_datapoint);
    end
    disp(i)
end
disp("Mean quantization error")
disp(mean(q_error))
disp("Standard error")
disp(std(q_error))
end

