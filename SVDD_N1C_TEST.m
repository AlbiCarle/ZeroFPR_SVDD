function y = SVDD_N1C_TEST(Xtr, Ytr, alpha, Xts, kernel, param, Rsquared)

% SVDD_N1C_TEST
% Usage: y = SVDD_N1C_TEST(Xtr, Ytr, alpha, Xts, kernel, param, Rsquared)

% Xtr: training set
% Ytr: labels of training set
% Xts: test set
% Kernel: 'linear, 'gaussian', 'polynomial'
% param: kernel parameter
% Rsquared: radius of the SVDD

    Tts = TestObject_N(Xtr, Ytr, alpha, Xts, kernel, param);
    y = sign(Rsquared-Tts);
    
end
                    