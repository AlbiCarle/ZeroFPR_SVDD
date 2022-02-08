function T=TestObject_N(Xtr, Ytr, alpha, Z, kernel, param)

% TestObject_N
% Usage: T=TestObject_N(Xtr, Ytr, alpha, Z, kernel, param)

% Xtr: training set
% Ytr: labels of training set
% alpha: lagrange multipliers of SVDD
% Z: test object
% Kernel: 'linear, 'gaussian', 'polynomial'
% param: kernel parameter

alf_i=alpha(Ytr==+1,1);
alf_l=alpha(Ytr==-1,1);

flag_i=find(all(Ytr==+1,2));
flag_l=find(all(Ytr==-1,2));

X_i=Xtr(flag_i,:);
X_l=Xtr(flag_l,:);

 K_i=KernelMatrix(X_i, X_i, kernel, param);
 K_l=KernelMatrix(X_l, X_l, kernel, param);

 Zker=KernelMatrix(Z, Z, kernel, param);
 Kz=diag(Zker);
 
 KZX_i=KernelMatrix(Z,X_i,kernel,param);
 KZX_l=KernelMatrix(Z,X_l,kernel,param);

 KX_lX_i=KernelMatrix(X_l, X_i, kernel, param);
 
 T=Kz-2*(KZX_i*alf_i-KZX_l*alf_l)+ ...
     +alf_i'*K_i*alf_i-2*alf_l'*KX_lX_i*alf_i+alf_l'*K_l*alf_l;
 
end