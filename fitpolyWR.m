%% fitpolyWR
% fits a polynomial using polynomial regression technique
function FPWR = fitpolyWR(n, data)
   % Input n, integer, max degree of polynomial
   % Input data, Matrix<double>, f(X) = Y data points
   % Output, polynomial approximation of f(X) = Y
   X = data(:,1); Y = data(:,2);
   % util variables
   S = size(X,1);
   % design matrix
   % x1,...,n^T phi's
   D = ones(S, n+1);
   for i=2:n+1
       for j=1:S
           D(j,i) = X(j,1)^(i-1);
       end
   end
   % coefficient vector
   % eq from slides : W = (X^T*X)^-1*X^T*t, X being design matrix and t the Yi's
   W = D.'*D\D.'*Y; % D.' is D transposed
   % we flip vector because matlab is building polynomials backwards
   Z = flipud(W);
   % turn vector into a polynomial
   FPWR = poly2sym(Z);
end