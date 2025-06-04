function [JSD_mean] = train_test_LogicANN(x_train_CV,t_train_CV,x_test_CV,t_test_CV)
x_train_CV=x_train_CV';
x_test_CV=x_test_CV';
for i=1:size(t_train_CV,1)
    t_train_array(1,i)=str2double(t_train_CV{i,1});
end
for i=1:size(t_test_CV,1)
    t_test_array(1,i)=str2double(t_test_CV{i,1});
end


JSD_mean=LogicANN_preformance(x_train_CV,t_train_array,x_test_CV,t_test_array);

end