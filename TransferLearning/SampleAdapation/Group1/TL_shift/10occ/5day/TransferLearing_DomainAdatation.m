clc,clear all
addpath(strcat(pwd,'\Subfunction'))

[~, day_str, ~] = fileparts(pwd);
[~, NumOcc_str, ~] = fileparts(fileparts(pwd));

load([fileparts(fileparts(fileparts(pwd))) '\Data\SouceDamianData.mat'])
load([fileparts(fileparts(fileparts(pwd))) '\Data\' num2str(NumOcc_str) '\TargetDamianData_testing.mat'])
x_tar=x_tar_test;
y_tar=y_tar_test;
%%
NumOccStr= extractBefore(NumOcc_str, 'occ');
NumOcc = str2double(NumOccStr);
if NumOcc==5
    y_sou=y_sou(1:size(y_sou,1)/3)*5;
    x_sou=x_sou(1:size(x_sou,1)/3,:);
elseif NumOcc==10
    y_sou=y_sou((size(y_sou,1)/3+1):(size(y_sou,1)/3*2))*10;
    x_sou=x_sou((size(x_sou,1)/3+1):(size(x_sou,1)/3*2),:);
elseif NumOcc==15
    y_sou=y_sou((size(y_sou,1)/3*2+1):end)*15;
    x_sou=x_sou((size(x_sou,1)/3*2+1):end,:);
else
    y_sou = discretize(y_sou, [0:0.1:1]);
end
%%
numberStr = extractBefore(day_str, 'day');
NumDay = str2double(numberStr);

x_tar=x_tar(1:480*NumDay,:);
y_tar=y_tar(1:480*NumDay)*NumOcc;
if NumOcc==7
    y_tar = discretize(y_tar, [0:0.1:1]*NumOcc);
end


sou_ind=ismember(y_sou, y_tar);
x_sou=x_sou(sou_ind,:);
y_sou=y_sou(sou_ind);
%% sample data 15-min
if NumOcc==7
    x_sou=x_sou(1:60:end,:);
    y_sou=y_sou(1:60:end,:);
    x_tar=x_tar(1:15:end,:);
    y_tar=y_tar(1:15:end,:);
else
    x_sou=x_sou(1:15:end,:);
    y_sou=y_sou(1:15:end,:);
    x_tar=x_tar(1:15:end,:);
    y_tar=y_tar(1:15:end,:);
end

%%
x_sou=[x_sou y_sou];
x_tar=[x_tar y_tar];
%%
% figure
% plot3(x_sou(:,1),x_sou(:,2),x_sou(:,3),'o'); hold on
% plot3(x_tar(:,1),x_tar(:,2),x_tar(:,3),'o'); 
% xlabel('Tout [C]')
% ylabel('Tz [C]')
% zlabel('RHz [%]')
% legend('souce','target')
% grid on
%% calculate the MMD
sigma = 1;          % Kernel parameter
MMD_0 = calculateMMD(x_sou, x_tar, sigma);
%% GA
% NumSample = size(x_tar,1); % 1000; % 从样本集A中采样的样本数
NumSample = 1000; % 1000; % 从样本集A中采样的样本数
NumItera=500;

lb = ones(1, NumSample); % 下界
ub = size(x_sou, 1) * ones(1, NumSample); % 上界
intCon = 1:NumSample; % 整数约束

% 使用遗传算法找到最小化MMD的样本集C
options = optimoptions('ga', 'Display', 'iter', 'MaxGenerations', NumItera,'PlotFcn', @gaplotbestf,...
    'MaxTime',3*60*60,...
    'PopulationSize',200,...
    'ConstraintTolerance',0.001,'FunctionTolerance',0.000001);
ind_sampled_GA = ga(@(sampleIndices) ObjFcn_sampled(sampleIndices, x_sou, x_tar, sigma), NumSample, [], [], [], [], lb, ub, [], intCon, options);

% 输出最佳样本集C
x_sampled_GA=x_sou(ind_sampled_GA,:);
y_sampled_GA=y_sou(ind_sampled_GA);
save('SampledInstances.mat','x_sampled_GA','y_sampled_GA')
saveas(gcf, 'GA_TL1.fig') 

minMMD=calculateMMD(x_sampled_GA, x_tar, sigma);
save('MMD_TL.mat','MMD_0','minMMD')
