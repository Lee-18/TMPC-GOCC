function error_JSD=LogicANN_preformance(x_train,t_train,x_test,t_test)
% normalize feature data
[input,minI,maxI]=premnmx(x_train);
% make the output file
s=length(t_train) ;
output=zeros(s,length(unique(t_train))) ;
for i=1:s 
   output(i,find(t_train(i)==unique(t_train)))=1;
end
% make the ANN net
net=newff(minmax(input),[20 length(unique(t_train))],{'logsig' 'purelin'},'traingdx'); 

net.trainparam.show = 50 ;% 显示中间结果的周期
net.trainparam.epochs = 500 ;%最大迭代次数（学习次数）
net.trainparam.goal = 0.01 ;%神经网络训练的目标误差
net.trainParam.lr = 0.01 ;%学习速率（Learning rate）

net = train(net,input,output');

testInput=tramnmx(x_test, minI, maxI ) ;
Y_predict=sim(net,testInput);
for i=1:size(Y_predict,2)
    y_predict(i)=find( max(Y_predict(:,i))==Y_predict(:,i)  );
end

error_JSD=MeanJSD(x_test',t_test,y_predict);
end