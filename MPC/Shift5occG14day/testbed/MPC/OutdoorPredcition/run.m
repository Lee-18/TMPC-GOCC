clc
clear all
model='SmallOffice_Atlanta_NoOcc_AL';
%% run simulink
load_system(model);
cs = getActiveConfigSet(model);
model_cs = cs.copy;

sim(model, model_cs);
%% read simulation results
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

%% save data
To_pre=table2array(EPlusOutput(:,2));
RHo_pre=table2array(EPlusOutput(:,5));
save('OutdoorPrediction.mat','To_pre','RHo_pre')
