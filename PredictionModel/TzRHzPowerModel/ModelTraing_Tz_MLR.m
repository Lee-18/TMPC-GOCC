clc
clear all
load('TrainingData_Tz.mat')
% x_train=x(1:2880,:);
% y_train=y(1:2880,:);
% 
% x_test=x(2881:end,:);
% y_test=y(2881:end,:);

x_train=x(1:end,:);
y_train=y(1:end,:);
%%
% 将输入数据划分为训练集和测试集
trainRatio = 1;
numTrain = floor(trainRatio * size(x_train, 1));
xTrain = x_train(1:numTrain, :);
yTrain = y_train(1:numTrain, :);

% 训练多元线性回归模型
mdl_Tz = fitlm(xTrain, yTrain);

save('MLR_Tz.mat','mdl_Tz')