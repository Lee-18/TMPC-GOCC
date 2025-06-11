clc
clear all
par_dir = fileparts(strcat(pwd,'\ExampleCall.m'));
addpath(strcat(par_dir,'\VirtualASHP'))
model='SmallOffice_Atlanta_NoOcc_AL';
%% run simulink
load_system(model);
cs = getActiveConfigSet(model);
model_cs = cs.copy;

sim(model, model_cs);
%% read simulation results
load('HP_data.mat')

VBuildFileName = strrep(model,'.slx','');
EPlusOutputDir = ['\Output_EPExport_' VBuildFileName '\FMU\'];
EPlusOutputFiles = dir(fullfile([pwd EPlusOutputDir],'*.csv'));
for i=1:length(EPlusOutputFiles)
    NameStrLength(i) = strlength(EPlusOutputFiles(i).name);
end
[~,FileLoc] = min(NameStrLength);
EPlusOutput = ...
    readtable([pwd EPlusOutputDir EPlusOutputFiles(FileLoc).name],...
    'PreserveVariableNames',true);

%% Power model data preparsion
% inputs
Tz=table2array(EPlusOutput(1:end-15,23));
RHz=table2array(EPlusOutput(1:end-15,25));
To=table2array(EPlusOutput(1:end-15,2));
RHo=table2array(EPlusOutput(1:end-15,5));
To_15=table2array(EPlusOutput(1+15:end,2));
RHo_15=table2array(EPlusOutput(1+15:end,5));

Speed=Cap(1+1:end-15,2);
Speed_15=Cap(1+1+15:end,2);

x=[Tz RHz To RHo To_15 RHo_15 Speed_15]; 
% outpts
Power_15=Cap(1+1+15:end,3);
y=[Power_15];

save('TrainingData_power.mat','x','y')
%% Tz model data preparsion
% inputs
Tz=table2array(EPlusOutput(1:end-15,23));
RHz=table2array(EPlusOutput(1:end-15,25));
To=table2array(EPlusOutput(1:end-15,2));
To_15=table2array(EPlusOutput(1+15:end,2));

Speed_15=Cap(1+1+15:end,2);

x=[Tz RHz To To_15 Speed_15]; 
% outpts
Tz_15=table2array(EPlusOutput(1+15:end,23));

y=[Tz_15];

save('TrainingData_Tz.mat','x','y')
%% RHz model data preparsion
% inputs
Tz=table2array(EPlusOutput(1:end-15,23));
RHz=table2array(EPlusOutput(1:end-15,25));
To=table2array(EPlusOutput(1:end-15,2));
Speed=Cap(1+1:end-15,2);

To_15=table2array(EPlusOutput(1+15:end,2));
Speed_15=Cap(1+1+15:end,2);

x=[Tz RHz To To_15 Speed_15]; 
% outpts
RHz_15=table2array(EPlusOutput(1+15:end,25));

y=[RHz_15];

save('TrainingData_RHz.mat','x','y')
%%
ModelTraing_power_ANN
ModelTraing_RHz_MARS
ModelTraing_Tz_MLR

ModelValidation_training