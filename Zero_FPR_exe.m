%% Example of ZeroFPR_SVDD
% This script shows how the zeroFPR_SVDD algorithm works.
% Given a training set X labelled in a target class (+1) 
% and in a negative class (-1), the algorithm performs a 
% cleaning of the SVDD classification until a threshold on
% the percentage of False Positives (FP) is reached.

clc; clear all; close all; %#ok<CLALL>

% Create the dataset

N1 = 1000; % number of target points
N2 = 100; % number of negative points

X1 = MixGauss([1;1],[1,1],N1); % target class
X2 = MixGauss([1;1],[2,2],N2); % negative class

Xtr = [X1; X2];

Y1 = ones(N1,1);
Y2 = -ones(N2,1);

Ytr = [Y1; Y2];

ir = randperm(size(Xtr, 1));
Xtr = Xtr(ir',:);
Ytr = Ytr(ir');

%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%

figure(1)

gscatter(Xtr(:,1), Xtr(:,2), Ytr, 'br'); % display the data

%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%

% Classification via SVDD

N1 = nnz(Ytr(:,1)==+1); 
N2 = nnz(Ytr(:,1)==-1);

C1 = 0.5;
C2 = 1; % if Kernel is linear, choose C2 = 1/N2;
kernel='gaussian';

param=1;

[alpha, Rsquared,a,SV,YSV]= ... 
    SVDD_N1C_TRAINING(Xtr, Ytr, kernel, C1, C2, param,'on');

%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%

% Display the classification

plotSVDD(Xtr, Ytr, Xtr, Ytr, SV, YSV, kernel, param, alpha, Rsquared, a, 2);

%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%

% Display the metrics

y = SVDD_N1C_TEST(Xtr, Ytr, alpha, Xtr, kernel, param, Rsquared);

P = nnz(Ytr(:,1)==+1);
N = nnz(Ytr(:,1)==-1); 

Y = [y Ytr];

TN = sum(Y(:,1)==-1 & Y(:,2)==-1);
FN = sum(Y(:,1)==-1 & Y(:,2)==+1);
TP = sum(Y(:,1)==+1 & Y(:,2)==+1);
FP = sum(Y(:,1)==+1 & Y(:,2)==-1);

FNR_start = FN/P;
FPR_start = FP/N;

ACC_start = (TP+TN)/(P+N);

F1_start = 2*TP/(2*TP+FP+FN);

PPV_start = TP/(TP+FP);
NPV_start = TN/(TN+FN);

TotalN_start = TP+FP;

%figure(3)

%cm = confusionchart(Ytr, y);

%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%

% zeroFPR_SVDD algorithm

treshold = 0.3; % treshold

[X_star, Y_star, alpha_star, Rsquared_star, ...
    a_star, SV_star, YSV_star, param_star] = ...
    ZeroFPR_SVDD(Xtr, Ytr, alpha, Rsquared, kernel, param, C1, C2, treshold, 'Y');

%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%

% Display the classification after the algorithm cleaning

plotSVDD(X_star, Y_star, Xtr, Ytr, SV_star, YSV_star, kernel, param_star, alpha_star, Rsquared_star,a_star,4);

%%%%%%%%%%%%%% XXXX %%%%%%%%%%%%%%%%%%%%%%

% Display the metrics

y = SVDD_N1C_TEST(X_star, Y_star, alpha_star, Xtr, kernel, param_star, Rsquared_star);

P = nnz(Ytr(:,1)==+1);
N = nnz(Ytr(:,1)==-1); 

Y = [y Ytr];

TN = sum(Y(:,1)==-1 & Y(:,2)==-1);
FN = sum(Y(:,1)==-1 & Y(:,2)==+1);
TP = sum(Y(:,1)==+1 & Y(:,2)==+1);
FP = sum(Y(:,1)==+1 & Y(:,2)==-1);

FNR_start = FN/P;
FPR_start = FP/N;

ACC_start = (TP+TN)/(P+N);

F1_start = 2*TP/(2*TP+FP+FN);

PPV_start = TP/(TP+FP);
NPV_start = TN/(TN+FN);

TotalN_start = TP+FP;

%figure(5)

%cm = confusionchart(Ytr, y);




