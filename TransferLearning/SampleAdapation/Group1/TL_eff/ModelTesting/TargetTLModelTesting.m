function JSD_tarTL_test=TargetTLModelTesting(NumOcc,NumDay)
load([fileparts(fileparts(pwd)) '\Data\' num2str(NumOcc) 'occ\TargetDamianData_testing.mat'])
load([fileparts(fileparts(pwd)) '\Data\' num2str(NumOcc) 'occ\TargetDamianData_Eff.mat'])
load([fileparts(pwd) '\' num2str(NumOcc) 'occ\' num2str(NumDay) 'day\SampledInstances.mat'])
%%
x_feature=x_tar(1:480*NumDay,:);
if NumOcc==7
    y=discretize(y_tar(1:480*NumDay), [0:0.1:1]);
else
    y=y_tar(1:480*NumDay)*NumOcc;
end
%%
x_train=[x_feature(1:15:end,:); x_sampled_GA(:,(1:end-1))];
y_train_array=[y(1:15:end); y_sampled_GA];

% the y used in RF,SMV,kNN should be in cell format
y_cell=num2cell(y_train_array);
for i=1:size(y_train_array,1)
    y_train{i,1}=num2str(y_cell{i,1});
end
%% All training and validation
Mdl_RF_all = TreeBagger(50,x_train,y_train,'OOBPredictorImportance','On');
t_RF_pre_all = predict(Mdl_RF_all, x_train);
for i=1:size(y_train,1)
    y_train_array(i,1)=str2double(y_train{i,1});
    t_RF_pre_all_array(i,1)=str2double(t_RF_pre_all{i,1});
end
JS_RF_all_mean=MeanJSD(x_train,y_train_array,t_RF_pre_all_array);
        
%% Model testing
x_tar_test=x_tar_test(1:15:end,:);
y_tar_test=y_tar_test(1:15:end);

t_RF_pre_test = predict(Mdl_RF_all, x_tar_test);
% convect the cell to double
for i=1:size(t_RF_pre_test,1)
    y_tar_test_pre(i,1)=str2double(t_RF_pre_test{i,1});
end

if NumOcc==7
    y_tar_test=discretize(y_tar_test, [0:0.1:1]);
else
    y_tar_test=y_tar_test*NumOcc;
end
JSD_tarTL_test=MeanJSD(x_tar_test,y_tar_test,y_tar_test_pre);
end