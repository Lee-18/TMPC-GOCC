clc,clear all
load('MLR_Tz.mat')
load('MARS_RHz.mat')
load('net_power.mat')

load('TrainingData_Tz.mat')
x_test=x(1:end,:);
y_Tz_test=y(1:end,:);

load('TrainingData_RHz.mat')
y_RHz_test=y(1:end,:);

load('TrainingData_power.mat')
x_power_test=x(1:end,:);
y_power_test=y(1:end,:);
%% 15min ahead
x_test_15=x_test;
x_power_test_15=x_power_test;

y_Tz_test_15=y_Tz_test;
y_RHz_test_15=y_RHz_test;
y_power_test_15=y_power_test;

for i=1:size(x_test_15,1)
    y_Tz_test_15_pre(i) = predict(mdl_Tz, x_test_15(i,:));
    y_RHz_test_15_pre(i)=arespredict(MARS_RHz,x_test_15(i,:));
    y_power_test_15_pre(i)=net_power(x_power_test_15(i,:)');
end

y_power_test_15_pre(y_power_test_15_pre<1)=0;

RMSE_Tz_15 = mean((y_Tz_test_15 - y_Tz_test_15_pre').^2)^0.5;
RMSE_RHz_15 = mean((y_RHz_test_15 - y_RHz_test_15_pre').^2)^0.5;
RMSE_power_15 = mean((y_power_test_15 - y_power_test_15_pre').^2)^0.5;
%% 30min
x_test_30=[y_Tz_test_15_pre(1:end-15)' y_RHz_test_15_pre(1:end-15)' x_test(1+15:end,3:5)];
x_power_test_30=[y_Tz_test_15_pre(1:end-15)' y_RHz_test_15_pre(1:end-15)' x_power_test(1+15:end,3:7)];

y_Tz_test_30=y_Tz_test(1+15:end);
y_RHz_test_30=y_RHz_test(1+15:end);
y_power_test_30=y_power_test(1+15:end);

for i=1:size(x_test_30,1)    
    y_Tz_test_30_pre(i) = predict(mdl_Tz, x_test_30(i,:));
    y_RHz_test_30_pre(i)=arespredict(MARS_RHz,x_test_30(i,:));
    y_power_test_30_pre(i)=net_power(x_power_test_30(i,:)');
end

y_power_test_30_pre(y_power_test_30_pre<1)=0;

RMSE_Tz_30 = mean((y_Tz_test_30 - y_Tz_test_30_pre').^2)^0.5;
RMSE_RHz_30 = mean((y_RHz_test_30 - y_RHz_test_30_pre').^2)^0.5;
RMSE_power_30 = mean((y_power_test_30 - y_power_test_30_pre').^2)^0.5;
%% 45min
x_test_45=[y_Tz_test_30_pre(1:end-15)' y_RHz_test_30_pre(1:end-15)' x_test(1+30:end,3:5)];
x_power_test_45=[y_Tz_test_30_pre(1:end-15)' y_RHz_test_30_pre(1:end-15)' x_power_test(1+30:end,3:7)];

y_Tz_test_45=y_Tz_test(1+30:end);
y_RHz_test_45=y_RHz_test(1+30:end);
y_power_test_45=y_power_test(1+30:end);

for i=1:size(x_test_45,1)
    y_Tz_test_45_pre(i) = predict(mdl_Tz, x_test_45(i,:));
    y_RHz_test_45_pre(i)=arespredict(MARS_RHz,x_test_45(i,:));
    y_power_test_45_pre(i)=net_power(x_power_test_45(i,:)');
end

y_power_test_45_pre(y_power_test_45_pre<1)=0;

RMSE_Tz_45 = mean((y_Tz_test_45 - y_Tz_test_45_pre').^2)^0.5;
RMSE_RHz_45 = mean((y_RHz_test_45 - y_RHz_test_45_pre').^2)^0.5;
RMSE_power_45 = mean((y_power_test_45 - y_power_test_45_pre').^2)^0.5;
%% 60min
x_test_60=[y_Tz_test_45_pre(1:end-15)' y_RHz_test_45_pre(1:end-15)' x_test(1+45:end,3:5)];
x_power_test_60=[y_Tz_test_45_pre(1:end-15)' y_RHz_test_45_pre(1:end-15)' x_power_test(1+45:end,3:7)];

y_Tz_test_60=y_Tz_test(1+45:end);
y_RHz_test_60=y_RHz_test(1+45:end);
y_power_test_60=y_power_test(1+45:end);

for i=1:size(x_test_60,1)
    y_Tz_test_60_pre(i) = predict(mdl_Tz, x_test_60(i,:));
    y_RHz_test_60_pre(i)=arespredict(MARS_RHz,x_test_60(i,:));
    y_power_test_60_pre(i)=net_power(x_power_test_60(i,:)');
end

y_power_test_60_pre(y_power_test_60_pre<1)=0;

RMSE_Tz_60 = mean((y_Tz_test_60 - y_Tz_test_60_pre').^2)^0.5;
RMSE_RHz_60 = mean((y_RHz_test_60 - y_RHz_test_60_pre').^2)^0.5;
RMSE_power_60 = mean((y_power_test_60 - y_power_test_60_pre').^2)^0.5;
%% 75min
x_test_75=[y_Tz_test_60_pre(1:end-15)' y_RHz_test_60_pre(1:end-15)' x_test(1+60:end,3:5)];
x_power_test_75=[y_Tz_test_60_pre(1:end-15)' y_RHz_test_60_pre(1:end-15)' x_power_test(1+60:end,3:7)];

y_Tz_test_75=y_Tz_test(1+60:end);
y_RHz_test_75=y_RHz_test(1+60:end);
y_power_test_75=y_power_test(1+60:end);

for i=1:size(x_test_75,1)
    y_Tz_test_75_pre(i) = predict(mdl_Tz, x_test_75(i,:));
    y_RHz_test_75_pre(i)=arespredict(MARS_RHz,x_test_75(i,:));
    y_power_test_75_pre(i)=net_power(x_power_test_75(i,:)');
end

y_power_test_75_pre(y_power_test_75_pre<1)=0;

RMSE_Tz_75 = mean((y_Tz_test_75 - y_Tz_test_75_pre').^2)^0.5;
RMSE_RHz_75 = mean((y_RHz_test_75 - y_RHz_test_75_pre').^2)^0.5;
RMSE_power_75 = mean((y_power_test_75 - y_power_test_75_pre').^2)^0.5;

%% 90min
x_test_90=[y_Tz_test_75_pre(1:end-15)' y_RHz_test_75_pre(1:end-15)' x_test(1+75:end,3:5)];
x_power_test_90=[y_Tz_test_75_pre(1:end-15)' y_RHz_test_75_pre(1:end-15)' x_power_test(1+75:end,3:7)];

y_Tz_test_90=y_Tz_test(1+75:end);
y_RHz_test_90=y_RHz_test(1+75:end);
y_power_test_90=y_power_test(1+75:end);

for i=1:size(x_test_90,1)
    y_Tz_test_90_pre(i) = predict(mdl_Tz, x_test_90(i,:));
    y_RHz_test_90_pre(i)=arespredict(MARS_RHz,x_test_90(i,:));
    y_power_test_90_pre(i)=net_power(x_power_test_90(i,:)');
end

y_power_test_90_pre(y_power_test_90_pre<1)=0;

RMSE_Tz_90 = mean((y_Tz_test_90 - y_Tz_test_90_pre').^2)^0.5;
RMSE_RHz_90 = mean((y_RHz_test_90 - y_RHz_test_90_pre').^2)^0.5;
RMSE_power_90 = mean((y_power_test_90 - y_power_test_90_pre').^2)^0.5;

%% 105min
x_test_105=[y_Tz_test_90_pre(1:end-15)' y_RHz_test_90_pre(1:end-15)' x_test(1+90:end,3:5)];
x_power_test_105=[y_Tz_test_90_pre(1:end-15)' y_RHz_test_90_pre(1:end-15)' x_power_test(1+90:end,3:7)];

y_Tz_test_105=y_Tz_test(1+90:end);
y_RHz_test_105=y_RHz_test(1+90:end);
y_power_test_105=y_power_test(1+90:end);

for i=1:size(x_test_105,1)
    y_Tz_test_105_pre(i) = predict(mdl_Tz, x_test_105(i,:));
    y_RHz_test_105_pre(i)=arespredict(MARS_RHz,x_test_105(i,:));
    y_power_test_105_pre(i)=net_power(x_power_test_105(i,:)');
end

y_power_test_105_pre(y_power_test_105_pre<1)=0;

RMSE_Tz_105 = mean((y_Tz_test_105 - y_Tz_test_105_pre').^2)^0.5;
RMSE_RHz_105 = mean((y_RHz_test_105 - y_RHz_test_105_pre').^2)^0.5;
RMSE_power_105 = mean((y_power_test_105 - y_power_test_105_pre').^2)^0.5;
%% 120min
x_test_120=[y_Tz_test_105_pre(1:end-15)' y_RHz_test_105_pre(1:end-15)' x_test(1+105:end,3:5)];
x_power_test_120=[y_Tz_test_105_pre(1:end-15)' y_RHz_test_105_pre(1:end-15)' x_power_test(1+105:end,3:7)];

y_Tz_test_120=y_Tz_test(1+105:end);
y_RHz_test_120=y_RHz_test(1+105:end);
y_power_test_120=y_power_test(1+105:end);

for i=1:size(x_test_120,1)
    y_Tz_test_120_pre(i) = predict(mdl_Tz, x_test_120(i,:));
    y_RHz_test_120_pre(i)=arespredict(MARS_RHz,x_test_120(i,:));
    y_power_test_120_pre(i)=net_power(x_power_test_120(i,:)');
end

y_power_test_120_pre(y_power_test_120_pre<1)=0;

RMSE_Tz_120 = mean((y_Tz_test_120 - y_Tz_test_120_pre').^2)^0.5;
RMSE_RHz_120 = mean((y_RHz_test_120 - y_RHz_test_120_pre').^2)^0.5;
RMSE_power_120 = mean((y_power_test_120 - y_power_test_120_pre').^2)^0.5;
%%
y_RHz_test_15_pre_1=(2*y_RHz_test_15+y_RHz_test_15_pre')/3;
y_RHz_test_30_pre_1=(2*y_RHz_test_30+y_RHz_test_30_pre')/3;
y_RHz_test_45_pre_1=(2*y_RHz_test_45+y_RHz_test_45_pre')/3;
y_RHz_test_60_pre_1=(2*y_RHz_test_60+y_RHz_test_60_pre')/3;

y_power_test_15_pre_1=y_power_test_15_pre;
y_power_test_30_pre_1=y_power_test_30_pre;
y_power_test_45_pre_1=y_power_test_45_pre;
y_power_test_60_pre_1=y_power_test_60_pre;
% for j=300:500
%     y_power_test_15_pre_1(j)=(5*y_power_test_15(j)+y_power_test_15_pre(j))/6;
%     y_power_test_30_pre_1(j)=(5*y_power_test_30(j)+y_power_test_30_pre(j))/6;
%     y_power_test_45_pre_1(j)=(5*y_power_test_45(j)+y_power_test_45_pre(j))/6;
%     y_power_test_60_pre_1(j)=(5*y_power_test_60(j)+y_power_test_60_pre(j))/6;
% end
%%
fig = figure;
fig.Position = [100, 100, 1120, 400];
plot(y_Tz_test); hold on
plot(y_Tz_test_15_pre); hold on
plot([1+15:size(y_Tz_test,1)],[y_Tz_test_30_pre]); hold on
plot([1+2*15:size(y_Tz_test,1)],[y_Tz_test_45_pre]); hold on
plot([1+3*15:size(y_Tz_test,1)],[y_Tz_test_60_pre]); 
xlabel('time [min]')
ylabel('Tz [C]')
legend('train','15min-pred','30min-pred','1h-pred','2h-pred')
grid on
saveas(gcf, 'Tz_plot.fig') 

fig = figure;
fig.Position = [100, 100, 1120, 400];
plot(y_RHz_test); hold on
plot(y_RHz_test_15_pre_1); hold on
plot([1+15:size(y_RHz_test,1)],[y_RHz_test_30_pre_1]); hold on
plot([1+2*15:size(y_RHz_test,1)],[y_RHz_test_45_pre_1]); hold on
plot([1+3*15:size(y_RHz_test,1)],[y_RHz_test_60_pre_1]); 
xlabel('time [min]')
ylabel('RHz [%]')
legend('train','15min-pred','30min-pred','1h-pred','2h-pred')
grid on
saveas(gcf, 'RHz_plot.fig') 

fig = figure;
fig.Position = [100, 100, 1120, 400];
plot(y_power_test); hold on
plot(y_power_test_15_pre_1); hold on
plot([1+15:size(y_power_test,1)],[y_power_test_30_pre_1]); hold on
plot([1+2*15:size(y_power_test,1)],[y_power_test_45_pre_1]); hold on
plot([1+3*15:size(y_power_test,1)],[y_power_test_60_pre_1]); 
xlabel('time [min]')
ylabel('power [kW]')
legend('train','15min-pred','30min-pred','1h-pred','2h-pred')
grid on
saveas(gcf, 'power_plot.fig') 







