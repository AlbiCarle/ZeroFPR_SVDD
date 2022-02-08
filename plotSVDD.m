function [] = plotSVDD(Xtr, Ytr, Xts, Yts, SV, YSV, kernel, param, alpha, Rsquared, a, ind)

% plotSVDD
% Usage: plotSVDD(Xtr, Ytr, Xts, Yts, SV, YSV, kernel, param, alpha, Rsquared, a, ind)

% Xtr: training set
% Ytr: labels of training set
% Xts: test set
% Yts: labesl of test set
% SV: Support Vectors of the training set
% YSV: labels of SVs
% Kernel: 'linear, 'gaussian', 'polynomial'
% param: kernel parameter
% alpha: lagrange multipliers of SVDD
% Rsquared: radius of the SVDD
% a: center of the SVDD
% ind: number of the figure, figure(ind)

if isequal(kernel, 'linear')

    R=sqrt(Rsquared);
    
    th = 0:pi/50:2*pi;
    xunit = R*cos(th) + a(1,1);
    yunit = R*sin(th) + a(1,2);
    plot(xunit, yunit, 'linewidth',1,'Color', 'g');
    axis equal;

    hold on

else

dimGrid=90; % dimGrid*dimGrid

[K1, Z1] = meshgrid(linspace(min(Xtr(:,1))-1, max(Xtr(:,1))+1,dimGrid),...
                    linspace(min(Xtr(:,2))-1, max(Xtr(:,2))+1,dimGrid));

x=linspace(min(Xtr(:,1))-1, max(Xtr(:,1))+1, dimGrid);
y=linspace(min(Xtr(:,2))-1, max(Xtr(:,2))+1, dimGrid);
   
K1=K1(:); Z1=Z1(:);
E=[K1 Z1];
    
target = SVDD_N1C_TEST(Xtr, Ytr, alpha, E, kernel, param, Rsquared);
    
target(target~=1)=2;
target(target==1)=-1;

figure(ind)
axis equal
contour(x, y, reshape(target,numel(y),numel(x)),[0.9999 0.9999] , ...
    'linecolor', 'g', 'LineWidth', 1);

end

hold on 
g = gscatter(Xts(:,1), Xts(:,2), Yts,'br','.',[8 8]);
hold on
g1 = gscatter(SV(:,1), SV(:,2), YSV,'br','*',[5 5]);
if(YSV==ones(size(SV,1),1))
hold on
gscatter(SV(:,1), SV(:,2), YSV,'r','*',[5 5]);
end
xlabel('$x_1$', 'Interpreter', 'Latex')
ylabel('$x_2$', 'Interpreter', 'Latex')
hold off

%for i = 1:numel(g)
%    g(i).DisplayName = strcat(g(i).DisplayName);
%end
legend('off')