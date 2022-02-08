function R_star = RadiusReductionSVDD(Xtr, Ytr, alpha, Xts, kernel, param, Rsquared, treshold)

% RadiusReductionSVDD

% Usage: R_star = RadiusReductionSVDD(Xtr, Ytr, alpha, Xts, kernel, param, Rsquared, treshold)

% Xtr: training set
% Ytr: labels of training set
% alpha: lagrange multipliers of SVDD
% Xts: test set
% param: kernel parameter
% Rsquared: squared radius of the SVDD
% kernel: 'linear, 'gaussian', 'polynomial'
% treshold: percentage of FP to be achieved

maxiter = 1000;

i = 1;

Rsq = Rsquared;

while(i<maxiter)
    
    Rsq = Rsq-10e-4;
    
y = SVDD_N1C_TEST(Xtr, Ytr, alpha, Xts, kernel, param, Rsq);

Y = [y Yts];

TN = sum(Y(:,1)==-1 & Y(:,2)==-1);
FN = sum(Y(:,1)==-1 & Y(:,2)==+1);
TP = sum(Y(:,1)==+1 & Y(:,2)==+1);
FP = sum(Y(:,1)==+1 & Y(:,2)==-1);

FPR=FP/N;

    if(FPR<treshold)
        R_star = Rsq;
        break;
    end

i=i+1;

disp(['Iteration --> ',num2str(i)])

end