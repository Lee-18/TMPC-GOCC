function JS_mean=MeanJSD(x,t_test,t_pre)
% input: x: the feature of dataset
%        t_test: the real label of dataset
%        t_pre: the predictive label of dataset
% output: JS_mean: the mean of Jensen–Shannon divergence value between 
%                  the t_test and t_pre distribution in the segmentation space 
invert_1=0.5;
invert_2=0.5;
invert_3=2;

n_inSegSpace_temp=[];
jsDiv_temp=[];
indi_temp=[];

x1_inv=(min(x(:,1))-invert_1/2):invert_1:(max(x(:,1))+invert_1/2);
x2_inv=(min(x(:,2))-invert_2/2):invert_2:(max(x(:,2))+invert_2/2);
x3_inv=(min(x(:,3))-invert_3/2):invert_3:(max(x(:,3))+invert_3/2);

for x1_i=1:size(x1_inv,2)-1
    for x2_i=1:size(x2_inv,2)-1
        for x3_i=1:size(x3_inv,2)-1
            % find the x with close value
            indi_1=x(:,1)>x1_inv(x1_i) & x(:,1)<=x1_inv(x1_i+1);
            indi_2=x(:,2)>x2_inv(x2_i) & x(:,2)<=x2_inv(x2_i+1);
            indi_3=x(:,3)>x3_inv(x3_i) & x(:,3)<=x3_inv(x3_i+1);
            indi=(indi_1 & indi_2 & indi_3);
            if sum(indi)>0
                jsDiv = JensenShannonDivergence(t_test(indi), t_pre(indi));
                % histogram(t_test(indi)); hold on
                % histogram(t_pre(indi));
                n_inSegSpace_temp=[n_inSegSpace_temp sum(indi)];
                jsDiv_temp=[jsDiv_temp jsDiv];
            end
            indi_temp=[indi_temp indi];
            
        end
    end
end

JS_mean=(n_inSegSpace_temp*jsDiv_temp')/sum(n_inSegSpace_temp);