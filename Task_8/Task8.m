%% Cross-Validation (5p)
%% Initials
clc; clear all; close all;
data_A  = load("data_lvq_A.mat").matA;
data_B  = load("data_lvq_B.mat").matB;

% Parameters
prototype_count_A = 2;
prototype_count_B = 1;
learning_rate = 0.01;
rng('default');

% Add class labels as a 3rd column, then put in single train_data matrix
data_A_labeled = [data_A ones(size(data_A, 1), 1)];
data_B_labeled = [data_B 2*ones(size(data_B, 1), 1)];
train_data = [data_A_labeled; data_B_labeled];

% Shuffle the training data
train_data = train_data(randperm(size(train_data, 1)), :);

% Initializing prototypes (TODO: ADD A BETTER WAY TO INTIALIZE)
prototypes_A = rand(prototype_count_A, 2, 'double');
prototypes_A = [prototypes_A ones(size(prototypes_A, 1), 1)];
prototypes_B = rand(prototype_count_B, 2, 'double');
prototypes_B = [prototypes_B 2*ones(size(prototypes_B, 1), 1)];


% Initializing prototypes
if prototype_count_A == 1    % Center of mass of points if one prototype
    xA_coord = sum(data_A(:,1))/size(data_A,1);
    yA_coord = sum(data_A(:,2))/size(data_A,1);
    prototypes_A = [xA_coord, yA_coord];
    prototypes_A = [prototypes_A ones(size(prototypes_A, 1), 1)];
  
else prototype_count_A == 2  % Two highest peaks based on the histogram values 
    prototypes_A = [3, 5, 1; 6.48, 5, 1];
    
end

if prototype_count_B == 1    % Center of mass of points if one prototype
    xB_coord = sum(data_B(:,1))/size(data_B,1);
    yB_coord = sum(data_B(:,2))/size(data_B,1);
    prototypes_B = [xB_coord, yB_coord];
    prototypes_B = [prototypes_B 2*ones(size(prototypes_B, 1), 1)];
   
else prototype_count_B == 2  % Two highest peaks based on the histogram values
    prototypes_B = [4.25, 3.58, 2; 5.75, 6.62, 2];    
end
prototypes = [prototypes_A; prototypes_B];

% Starting the lvq process
train_error_arr = [];
test_error_arr = zeros(1,10);
epoch = 1;

%% K fold
% Apply 10-fold cross validation for the estimation of the classification error
n = size(train_data,1);
folds = 10;
partition = cvpartition(size(train_data,1),'KFold',folds);

%Indices of training and test samples for Kfold
trainingSetsIdx = [];
testSetsIdx = [];

% Finding indices for traning and test sets for Kfold
for i = 1:folds
    trainingSetsIdx(:,i) = training(partition,i);
    testSetsIdx(:,i) = test(partition,i);
end
%% LVQ
for k = 1:folds
    
    % Indices to remove
    traingRemove = [];
    testRemove = [];

    % Creating training and test sets for Kfold
    for i = 1:size(train_data,1)
        if trainingSetsIdx(i,k) ~= 1
            traingRemove = [traingRemove, i];
        else
            testRemove = [testRemove, i];
        end
    end

    [trainingSet,~] = removerows(train_data,'ind',traingRemove);
    [testSet,~] = removerows(train_data,'ind',testRemove);
    
    % Train:
    while 1
        missclassifications = 0;
        for i = 1:180
            % Get the point from the training data together with label
            point = trainingSet(i, :); 

            % Find the minimum distance prototype
            min_dist = 99999;
            closest_prototype = [0 0 1];
            for j = 1:(prototype_count_A+prototype_count_B)
                cur_dist = norm(point(:, [1, 2]) - prototypes(j, [1, 2]));
                if  cur_dist < min_dist
                    closest_prototype = j;
                    min_dist = cur_dist;
                end
            end

            diff = point(:, [1, 2]) - prototypes(closest_prototype, [1, 2]);
            % If the point belongs to the same class, move the prototype closer
            if prototypes(closest_prototype, 3) == point(:, 3)
                prototypes(closest_prototype, [1, 2]) = prototypes(closest_prototype, [1, 2]) + diff * learning_rate;
            end

            % If the point does not belong to the same class, move the prototype further
            if prototypes(closest_prototype, 3) ~= point(:, 3)
                prototypes(closest_prototype, [1, 2]) = prototypes(closest_prototype, [1, 2]) - diff * learning_rate;
                missclassifications = missclassifications + 1;
            end
        end

        % Calculate training error
        training_error = missclassifications / size(trainingSet, 1);
        train_error_arr(end+1) = training_error;

        if epoch == 5000 || training_error < 0.05 
            break
        end

        epoch = epoch + 1;
    end
    
    % Test:
    missclassificationsTest = 0;
    for i = 1:size(testSet,1)
        
        point = testSet(i, :);
        
        % Find the minimum distance prototype
        min_dist = 99999;
        closest_prototype = [0 0 1];
        for j = 1:(prototype_count_A+prototype_count_B)
          cur_dist = norm(point(:, [1, 2]) - prototypes(j, [1, 2]));
             if  cur_dist < min_dist
               closest_prototype = j;
               min_dist = cur_dist;
             end
        end
        
        if prototypes(closest_prototype, 3) ~= point(:, 3)
           missclassificationsTest = missclassificationsTest + 1;
        end
        
    end
    
    % Classification error (Test)
    test_error = missclassificationsTest / size(testSet, 1);
    test_error_arr(1,k) = test_error;

    
    
end
epoch
prototypes
test_error_arr

% Test Error
KfoldError = sum(test_error_arr)/folds
KfoldError = KfoldError * 100;
test_error_arr = test_error_arr * 100;

% Plotting:
figure(1);
bar(test_error_arr)
text(1:length(test_error_arr),test_error_arr,num2str(test_error_arr','%%%0.1f'),'vert','bottom','horiz','center'); 
box off
ylabel('Error [%]');
xlabel('Each fold and the corresponding error');
hold on
yline(KfoldError,'r','Average Kfold error');
hold off

