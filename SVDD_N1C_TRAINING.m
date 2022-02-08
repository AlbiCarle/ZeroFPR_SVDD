function [alpha, Rsquared,a,SV,YSV] = SVDD_N1C_TRAINING(Xtr, Ytr, kernel, param, C1, C2, qdprg_opts)

% SVDD_N1C_TRAINING
% Usage: [alpha, Rsquared,a,SV,YSV] = SVDD_N1C_TRAINING(Xtr, Ytr, kernel, param, C1, C2, qdprg_opts)

% Xtr: training set
% Ytr: labels of training set
% Kernel: 'linear, 'gaussian', 'polynomial'
% param: kernel parameter
% C1, C2: SVDD weights
% qdprg_opts: display optimization informations

if(size(Ytr(Ytr==-1),1)==0)

    disp('Error: there must be a target class and a negative class')

else
    n=size(Xtr,1);
    
    if (isequal(kernel,'linear') || isequal(kernel,'polynomial'))

        Ztr = Xtr+10; 
        Ztr = normalize(Ztr, 2,'norm',2);

    else
    
        Ztr = Xtr;
    
    end
    
    K = KernelMatrix(Ztr, Ztr, kernel, param);
    
    % Computing alpha, maximizing L=sum_i alpha_i*(x_i*x_i)-sum_l alpha_l*(x_l*x_l)
    %                              -sum_(i,j) alpha_i*alpha_j*(x_i*x_j)
    %                              +2sum_(l,j)alpha_l*alpha_j*(x_l*x_j)
    %                              -sum_(l,m) alpha_l*alpha_m*(x_l*x_m),
    % by using quadprog with L=1/2x'Hx+f'x
    
    H=Ytr*Ytr'.*K;
    H=H+H';
    f=Ytr.*diag(K);
    
    lb = zeros(n,1);
    ub = ones(n,1);
        ub(Ytr==-1,1)=C2;
        ub(Ytr==+1,1)=C1;
    Aeq = ones(1,n);
        Aeq(1,Ytr==-1)=-1;
        Aeq(1,Ytr==+1)=+1;
    beq = 1;
    
    if isequal(qdprg_opts,'on')
    options = optimset('Display', 'on');
    elseif isequal(qdprg_opts,'off')
    options = optimset('Display', 'off');
    end
    
    alpha = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],options);
    
    % Center
    
    a = alpha'*(Ytr.*Xtr);
    
    % Support Vectors
    
    inc=1E-5;
    
    idxSV = find(all(abs(alpha)>inc & abs(alpha)<C1-inc,2) | all(abs(alpha)>inc & abs(alpha)<C2-inc,2));
    SV = Xtr(idxSV,:); 
    YSV = Ytr(idxSV,:);
    
    
    if(size(SV,1)>0)
    
        rand=randperm(size(SV,1),1); 
        
        x_s = SV(rand,:);
        
        Rsquared = TestObject_N(Xtr, Ytr, alpha, x_s, kernel, param);
    else
        Rsquared=0;
    end
end




