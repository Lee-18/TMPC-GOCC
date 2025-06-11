clc,clear all
load('AllFullOccData_AtlantaTypSum.mat')

AllFullOccData=AllFullOccData_AtlantaTypSum;
x=[];
y=[];
for i=1:size(AllFullOccData,1)
    for t=1:size(AllFullOccData{i,2},2)
    x=[x; AllFullOccData{i,2}(t).T_out,AllFullOccData{i,2}(t).T_z,...
        AllFullOccData{i,2}(t).RH_z, AllFullOccData{i,2}(t).m_sup,...
        AllFullOccData{i,2}(t).T_sup, AllFullOccData{i,2}(t).w_sup];
    y=[y;AllFullOccData{i,4}(t).GroupOccTheComf_2];
    end    
end
y=y*7;
%% process/sample the data
% feature selection
x_feature=x(:,[1,2,3]);

%% 
% figure
% plot3(x_feature(y==7,1),x_feature(y==7,2),x_feature(y==7,3),'o'); hold on
% plot3(x_feature(y==6,1),x_feature(y==6,2),x_feature(y==6,3),'o'); hold on
% plot3(x_feature(y==5,1),x_feature(y==5,2),x_feature(y==5,3),'o'); hold on
% plot3(x_feature(y==4,1),x_feature(y==4,2),x_feature(y==4,3),'o'); hold on
% plot3(x_feature(y==3,1),x_feature(y==3,2),x_feature(y==3,3),'o');
% xlabel('Tout [C]')
% ylabel('Tz [C]')
% zlabel('RHz [%]')
% legend('7','6','5','4','3')
% grid on
%%
x_train=x_feature;
y_train_array=y;

% the y used in SMV should be in cell format
y_cell=num2cell(y_train_array);
for i=1:size(y_train_array,1)
    y_train{i,1}=num2str(y_cell{i,1});
end
%% model training using linear classification model
% % t = templateLinear;
% % rng(1); % For reproducibility 
% % Mdl_LCM = fitcecoc(x_train',y_train,'Learners',t,'ObservationsIn','columns');
% % % error
% % y_pre_LCM=predict(Mdl_LCM,x_train);
% % 
% % for i=1:size(y_pre_LCM,1)
% %     y_pre_LCM_array(i,1)=str2double(y_pre_LCM{i,1});
% % end
% % 
% % % calcuate the mean Jensen–Shannon divergence
% % JS_CV_mean=MeanJSD(x_train,y_train_array,y_pre_LCM_array);

%% model training using random forest
for rep=1:5
    tic
    k_flod=3;
    indices = crossvalind('Kfold',y_train,k_flod);
    for k=1:k_flod
        test = (indices == k);
        train = ~test;
        x_train_CV=x_train(train,:);
        t_train_CV=y_train(train,:);
        x_test_CV=x_train(test,:);
        t_test_CV=y_train(test,:);
        
        Mdl_RF = TreeBagger(50,x_train_CV,t_train_CV,'OOBPredictorImportance','On');
        Mdl_SVM = fitcecoc(x_train_CV,t_train_CV);
        Mdl_kNN = fitcknn(x_train_CV,t_train_CV,'NumNeighbors',5,'Standardize',1);
        
        t_RF_pre_CV = predict(Mdl_RF, x_test_CV);
        t_SVM_pre_CV=predict(Mdl_SVM,x_test_CV);
        t_kNN_pre_CV=predict(Mdl_kNN,x_test_CV);
        
        % convect the cell to double
        for i=1:size(t_test_CV,1)
            t_array_test(i,1)=str2double(t_test_CV{i,1});
            t_RF_array_pre(i,1)=str2double(t_RF_pre_CV{i,1});
            t_SVM_array_pre(i,1)=str2double(t_SVM_pre_CV{i,1});
            t_kNN_array_pre(i,1)=str2double(t_kNN_pre_CV{i,1});
        end
        
        % calcuate the mean Jensen–Shannon divergence
        JS_RF_CV_mean(k)=MeanJSD(x_test_CV,t_array_test,t_RF_array_pre);
        JS_SVM_CV_mean(k)=MeanJSD(x_test_CV,t_array_test,t_SVM_array_pre);
        JS_kNN_CV_mean(k)=MeanJSD(x_test_CV,t_array_test,t_kNN_array_pre);
        JS_ANN_CV_mean(k)=train_test_LogicANN(x_train_CV,t_train_CV,x_test_CV,t_test_CV);
    end
    
    JS_RF(rep)=mean(JS_RF_CV_mean);
    JS_SVM(rep)=mean(JS_SVM_CV_mean);
    JS_kNN(rep)=mean(JS_kNN_CV_mean);
    JS_ANN(rep)=mean(JS_ANN_CV_mean);
    toc
end
JS_RF_final=mean(JS_RF);
JS_SVM_final=mean(JS_SVM);
JS_kNN_final=mean(JS_kNN);
JS_ANN_final=mean(JS_ANN);
%%
Mdl_RF_all = TreeBagger(50,x_train,y_train,'OOBPredictorImportance','On');
t_RF_pre_all = predict(Mdl_RF_all, x_train);
for i=1:size(y_train,1)
    y_train_array(i,1)=str2double(y_train{i,1});
    t_RF_pre_all_array(i,1)=str2double(t_RF_pre_all{i,1});
end
JS_RF_all_mean=MeanJSD(x_train,y_train_array,t_RF_pre_all_array);
        
