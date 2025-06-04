clc
clear all
load('TrainingData_RHz.mat')
% x_train=x(1:2880,:);
% y_train=y(1:2880,:);
% 
% x_test=x(2881:end,:);
% y_test=y(2881:end,:);

x_train=x(1:end,:);
y_train=y(1:end,:);
%%
Params = aresparams(40,-1,true,2, 1, 1, 1e-4, false); 
MARS_RHz = aresbuild(x_train,y_train,Params);

save('MARS_RHz.mat','MARS_RHz')