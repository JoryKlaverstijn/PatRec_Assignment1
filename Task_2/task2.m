rng(0, 'twister')

% 1. Making set S by taking a random person and selecting two random rows
% from this person's matrix and calculating the HS between them.
set_S = [];
for i = 1: 1000
    rndm_person = randi(20);
    filename = sprintf('person%02d.mat', rndm_person);
    iris_mat = load(filename).iriscode;

    row1 = randi(20);
    row2 = randi(20);
    ham_dist = sum(abs(iris_mat(row1, :) - iris_mat(row2, :))) / 30;
    set_S(end+1) = ham_dist;
end

% Making set D by taking two random people and selecting a random row from
% each person'smatrix and calculating the HS between them.
set_D = [];
for i = 1: 1000
    rndm_person = randi(20);
    filename = sprintf('person%02d.mat', rndm_person);
    iris_mat1 = load(filename).iriscode;

    rndm_person = randi(20);
    filename = sprintf('person%02d.mat', rndm_person);
    iris_mat2 = load(filename).iriscode;

    row1 = randi(20);
    row2 = randi(20);
    ham_dist = sum(abs(iris_mat1(row1, :) - iris_mat2(row2, :))) / 30;
    set_D(end+1) = ham_dist;
end

% 2. Plotting set S vs set D
bin_edges = 0:0.05:1;
h1 = histogram(set_S, BinEdges=bin_edges);
hold on
h2 = histogram(set_D, BinEdges=bin_edges);
hold on
xlabel('Normalized Hamming distance')
ylabel('Count')
legend({'set S', 'set D'})
title('Comparison of set S and set D')

% 3. Computing means and variances of set S and set D
mean_S = mean(set_S)
mean_D = mean(set_D)

var_S = var(set_S)
var_D = var(set_D)

% 4. add normal distribution for each histogram (scaling based on proportion
% modus and max value of pdf
x = 0:0.00001:1;
pdf_S = normpdf(x, mean_S, sqrt(var_S));
my_counts_S = discretize(set_S, bin_edges);
numbers = unique(my_counts_S);
count = hist(my_counts_S, numbers)
mode_S_count = max(count);
pdf_S_mod = mode_S_count / max(pdf_S) * pdf_S;
plot(x, pdf_S_mod);

pdf_D = normpdf(x, mean_D, sqrt(var_D));
my_counts_D = discretize(set_D, bin_edges);
numbers = unique(my_counts_D);
count = hist(my_counts_D, numbers)
mode_D_count = max(count);
pdf_D_mod = mode_D_count / max(pdf_D) * pdf_D;
plot(x, pdf_D_mod);
legend({'set S', 'set D', 'guassian S', 'Gaussian D'})

% 5. 
% H0: the two irises are different
% ha: the two irises are identical
% false acceptance should be 0.0005
s = 0;
for i = 1:100000
    s = s + pdf_D(i);
    if s >= 0.0005 * sum(pdf_D)
        criterion = i / length(pdf_D)
        break
    end
end

% calculating the false rejection rate is the proportion of pdf_S above
% criterion
s = 0;
for i = 100000:-1:1
    s = s + pdf_S(i);
    if i <= criterion * 100000
        break
    end
end
false_rejection = s / 100000

% 6. Best match for test_person
mystery_mat = load('testperson.mat').iriscode;
mystery_mat(mystery_mat>=2) = 0.5;

% We convert every missing value (2) to a value exactly inbetween 0 and 1
% (0.5). This way the missing values are not taken into consideration. Then
% we calculate the cummulative Hamming distance of the test person's iris 
% code with all the iris codes of a person. If this distance is lower than
% the current lowest distance, then the person is the current best match.
best_match = 0;
lowest_dist = 999999;
for i = 1:20
    filename = sprintf('person%02d.mat', i);
    iris_mat = load(filename).iriscode;
    cur_dist = 0;
    for j = 1:20
        cur_row = iris_mat(i, :);
        cur_dist = cur_dist + sum(abs(cur_row - mystery_mat));
    end
    if cur_dist < lowest_dist
        lowest_dist = cur_dist;
        best_match = i;
    end
end

disp('Best match is person:');
disp(best_match);















