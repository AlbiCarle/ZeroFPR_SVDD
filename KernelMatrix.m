function K = KernelMatrix(X1, X2, kernel, param)

% Usage: K = KernelMatrix(X1, X2, kernel, param)
% X1 and X2 are the two collections of points on which to compute the Gram matrix

%kernel = 'linear', 'polynoial', 'gaussian'
    if numel(kernel) == 0
        kernel = 'linear';
    end
    if isequal(kernel, 'linear')
        K = X1*X2';
    elseif isequal(kernel, 'polynomial')
        K = (1 + X1*X2').^param;
    elseif isequal(kernel, 'gaussian')
        K = exp(-1/(2*param^2)*SquareDist(X1,X2));
    end
end
