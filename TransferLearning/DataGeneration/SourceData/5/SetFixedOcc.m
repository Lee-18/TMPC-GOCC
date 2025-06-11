clc,clear all
load('Fixed_OccupantMatrix.mat')
load('group_rec_5.mat')
%%
OriginalOcc=Fixed_OccupantMatrix;
OriginalOcc_temp=OriginalOcc;

for g=1:24
    for occ=1:size(group_rec{1, 1},1)
        Acc_temp=group_rec{1,g}(occ,:);
        Acc_temp(Acc_temp==3)=2;
        Acc_temp(Acc_temp==-3)=-2;
        for s=1:2
            if Acc_temp(2*s)-Acc_temp(2*s-1)==0
                if randi([0, 1])==1
                    Acc_temp(2*s)=Acc_temp(2*s)+1;
                else
                    Acc_temp(2*s-1)=Acc_temp(2*s-1)-1;
                end
            end
        end
        Acc_temp(5:6)=Acc_temp(3:4);
        Acc_temp(7:8)=Acc_temp(1:2);
        
        OriginalOcc_temp{1, 1}(occ).AcceptabilityVector=Acc_temp;  
        for s = 1:4
            if median(OriginalOcc_temp{1, 1}(occ).AcceptabilityVector(...
                    ((s*2)-1)):1:...
                    OriginalOcc_temp{1, 1}(occ).AcceptabilityVector(s*2)) <= 0
                OriginalOcc_temp{1, 1}(occ).PreferenceClass(s) = 0;
            else
                OriginalOcc_temp{1, 1}(occ).PreferenceClass(s) = 1;
            end
        end
    end
    Fixed_OccupantMatrix=OriginalOcc_temp;
    
    for i=1:4
        folderName = ['G' num2str(g) '_' num2str(i)];  % 定义新文件夹名称
        if ~exist(folderName, 'dir')  % 检查文件夹是否已存在
            mkdir(folderName);  % 如果不存在，则创建文件夹
        end
        
        variableName = 'Fixed_OccupantMatrix';  % 定义变量名
        myVariable = Fixed_OccupantMatrix;  % 示例变量
        save(fullfile(folderName, variableName), variableName);  % 将变量保存到文件夹中
        
        sourceFile = 'run.m';  % 替换为你要复制的文件名
        destinationFolder = [pwd '\' folderName];  % 替换为目标文件夹的路径
        
        % 复制文件到目标文件夹
        copyfile(sourceFile, destinationFolder);
    end
end
