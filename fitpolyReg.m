%% fitpolyReg
% fits a polynomial using polynomial regression technique, add regularizer
function FPReg = fitpolyReg(n, data, l)
   % Input n, integer, max degree of polynomial
   % Input data, Matrix<double>, f(X) = Y data points
   % input lambda, double, Regularizer
   % Output, polynomial approximation of f(X) = Y
   X = data(:,1); Y = data(:,2);
   S = size(X,1);
   D = ones(S, n+1);
   for i=2:n+1
       for j=1:S
           D(j,i) = X(j,1)^(i-1);
       end
   end
   % eq from slides :
   % w = (X^T*X+lambda*Id)^-1*X^T*t where X is design matrix and t function data
   % points and Id is identity matrix
   W = (D.' * D + l * eye(n+1))\D.' * Y; 
   Z = flipud(W);
   FPReg = poly2sym(Z);
end