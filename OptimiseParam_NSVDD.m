function [s, Vm, Vs, Tm, Ts] = OptimiseParam_NSVDD(X, Y, kernel, perc, nrip, intKerPar, C1, C2)

%Usage

%[s, Vm, Vs, Tm, Ts] = OptimiseParam_NSVDD(X, Y, kernel, perc, nrip, intKerPar, C1, C2)
% X: training set
% Y: labels of training set
% kernel: 'linear, 'gaussian', 'polynomial'
% perc: percentage of the dataset to be used for validation
% nrip: number of repetitions of the test for the parameter
% intKerPar: list of kernel parameters 
% C1, C2: SVDD weights
% 
% Output:
% s: kernel parameter that minimize the median of the
%    validation error
% Vm, Vs: median and variance of the validation error for the  parameter
% Tm, Ts: median and variance of the error computed on the training set for the parameter


    nKerPar = numel(intKerPar); 
    
    n = size(X,1);
    ntr = ceil(n*(1-perc));
    
    tmn = zeros(nKerPar, nrip);
    vmn = zeros(nKerPar, nrip);
    
    for rip = 1:nrip
        I = randperm(n);
        Xtr = X(I(1:ntr),:);
        Ytr = Y(I(1:ntr),:);
        Xvl = X(I(ntr+1:end),:);
        Yvl = Y(I(ntr+1:end),:);
        
        
        is = 0;
        for param=intKerPar
            is = is + 1;

            [alpha, Rsquared,~,~,~] = ...
                SVDD_N1C_TRAINING(Xtr, Ytr, kernel, param, C1, C2, 'off');

            tmn(is, rip) = ...
    calcErr(SVDD_N1C_TEST(Xtr, Ytr, alpha, Xtr, kernel, param, Rsquared), Ytr);               
            vmn(is, rip)  = ...
    calcErr(SVDD_N1C_TEST(Xtr, Ytr, alpha, Xvl, kernel, param, Rsquared), Yvl);
            
        end

        disp(['Opt_iter ', num2str(rip)]);

    end
    
    Tm = median(tmn,2);
    Ts = std(tmn,0,2);
    Vm = median(vmn,2);
    Vs = std(vmn,0,2);
    
    [row, col] = find(Vm <= min(min(Vm)));
    
    s = intKerPar(row(1));
    
end

function err = calcErr(T, Y)
    n=size(T,1);
    err=sum(T~=Y)/n;
end
