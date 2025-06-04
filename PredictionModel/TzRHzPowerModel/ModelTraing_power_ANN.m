clc
clear all
load('TrainingData_power.mat')
% x_train=x(1:2880,:);
% y_train=y(1:2880,:);
% 
% x_test=x(2881:end,:);
% y_test=y(2881:end,:);

x_train=x(1:end,:);
y_train=y(1:end,:);
%%
% 转换输入和目标数据为合适的格式
inputs = x_train';
targets = y_train';

% 创建前馈神经网络
hiddenLayerSize = 10; % 隐藏层神经元数量
net_power = feedforwardnet(hiddenLayerSize);

% 将数据分为训练集、验证集和测试集
net_power.divideParam.trainRatio = 100/100; % 70% 用于训练
net_power.divideParam.valRatio = 0/100; % 15% 用于验证
net_power.divideParam.testRatio = 0/100; % 15% 用于测试

% 训练神经网络
[net_power, tr] = train(net_power, inputs, targets);

save('net_power.mat','net_power')