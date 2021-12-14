%Declaring mean and covariance matrix 
mu = [3 4];
Sigma = [1 0; 0 2];

%Use of mesh function
x1 = -10:10;
x2 = -10:10;
[X1,X2] = meshgrid(x1,x2);
X = [X1(:) X2(:)];
y = mvnpdf(X,mu,Sigma);

%2D Gaussian plot specifics
y = reshape(y,length(x2),length(x1));
surf(x1,x2,y)
caxis([min(y(:))-0.5*range(y(:)),max(y(:))])
axis([-10 10 -10 10])
xlabel('x1')
ylabel('x2')
zlabel('Probability Density')
