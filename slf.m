%% Square loss function
function SLF = slf(fct, data)
    % Input fct, function, function to perform
    % Input data, Matrix<double>, f(X) = Y data points
    % Output SLF, double, Sum of square losses
    X = data(:,1); Y = data(:,2);
    SLF = 0;
    for i=1:length(X)
        % subs : substitute x with value in the function
        SLF = SLF + (subs(fct,X(i,1))- Y(i,1))^2;
    end
    SLF = 1/2*SLF;
end