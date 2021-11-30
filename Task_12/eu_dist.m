function sum = eu_dist(vector_1, vector_2)
% The lenghts of the two vectors have to be equal for a distance
% calculation to be possible

if length(vector_1) ~= length(vector_2)
    disp("vectors not equal in size")
end

% This function ensures that features with more dimensions than 2 can also
% still be used in the KNN function
sum = 0;
for i = 1:length(vector_1)
    p1 = vector_1(i);
    p2 = vector_2(i);
    sum = sum + (p2-p1)*(p2-p1);
end
sum = sqrt(sum);
end