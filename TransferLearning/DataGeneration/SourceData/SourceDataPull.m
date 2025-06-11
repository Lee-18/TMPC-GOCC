clc,clear all
% subFolders = genpath(strcat(pwd));
% addpath(subFolders);
%%
x_sou=[];
y_sou=[];
for NumOcc=[5 10 15]
    for Group=1:24
        for i=1:4
            % 指定文件夹路径
            folderPath = strcat(pwd,'/', num2str(NumOcc), '/G', num2str(Group), '_', num2str(i));
            % OBM data
            fileName = 'OBM_Data.mat';
            filePath = fullfile(folderPath, fileName);
            load(filePath);
            
            % full occupanct index
            FullOccupancyRow = find(all(OBM_Data(:,1:size(OBM_Data,2)/3) == 1, 2));
            
            FullOccComf=OBM_Data(FullOccupancyRow,size(OBM_Data,2)/3+1:size(OBM_Data,2)/3*2);
            GroupComf=sum(FullOccComf == 0, 2)/(size(OBM_Data,2)/3);
            
            y_sou_temp=GroupComf;
            
            % EPlus file
            EPlusOutputDir = ['/Output_EPExport_SmallOffice_Atlanta_Occ_AL/FMU'];
            EPlusOutputFiles = dir(fullfile([folderPath EPlusOutputDir],'*.csv'));
            for i=1:length(EPlusOutputFiles)
                NameStrLength(i) = strlength(EPlusOutputFiles(i).name);
            end
            [~,FileLoc] = min(NameStrLength);
            EPlusOutput = ...
                readtable([[folderPath EPlusOutputDir] '/' EPlusOutputFiles(FileLoc).name],...
                'PreserveVariableNames',true);
            
            Tz=table2array(EPlusOutput(FullOccupancyRow-1,23));
            RHz=table2array(EPlusOutput(FullOccupancyRow-1,25));
            To=table2array(EPlusOutput(FullOccupancyRow-1,2));
            
            x_sou_temp=[To Tz RHz];
            
            x_sou=[x_sou; x_sou_temp];
            y_sou=[y_sou; y_sou_temp];
        end
    end
end

save('SouceDamianData.mat','x_sou','y_sou')

DeleteCacheFile