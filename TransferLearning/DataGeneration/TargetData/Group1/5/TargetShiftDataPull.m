clc,clear all
addpath(strcat(pwd,'\VirtualASHP'))
addpath(strcat(pwd,'\OBM'))

% OBM data
load('OBM_Data.mat');

% EPlus file
EPlusOutputDir = ['/Output_EPExport_SmallOffice_Atlanta_Occ_Shift/FMU'];
EPlusOutputFiles = dir(fullfile([pwd EPlusOutputDir],'*.csv'));
for i=1:length(EPlusOutputFiles)
    NameStrLength(i) = strlength(EPlusOutputFiles(i).name);
end
[~,FileLoc] = min(NameStrLength);
EPlusOutput = ...
    readtable([[pwd EPlusOutputDir] '/' EPlusOutputFiles(FileLoc).name],...
    'PreserveVariableNames',true);
%%
% full occupanct index
FullOccupancyRow = find(all(OBM_Data(:,1:size(OBM_Data,2)/3) == 1, 2));

FullOccComf=OBM_Data(FullOccupancyRow,size(OBM_Data,2)/3+1:size(OBM_Data,2)/3*2);
GroupComf=sum(FullOccComf == 0, 2)/(size(OBM_Data,2)/3);

y_tar_temp=GroupComf;

Tz=table2array(EPlusOutput(FullOccupancyRow-1,23));
RHz=table2array(EPlusOutput(FullOccupancyRow-1,25));
To=table2array(EPlusOutput(FullOccupancyRow-1,2));

x_tar_temp=[To Tz RHz];

x_tar_5=[x_tar_temp(1:480*5,:)];
y_tar_5=[y_tar_temp(1:480*5,:)];

x_tar=x_tar_temp;
y_tar=y_tar_temp;

save('TargetDamianData_Shift.mat','x_tar','y_tar')