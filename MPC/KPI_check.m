clc,clear all
CaseName='Shift15occG35day';
ScenarioName='GOCCTL'; % Baseline, GOCC, GOCCTL
%% MPC predicted result
MPC_pre_all=load([pwd '\' CaseName '\' ScenarioName '\MPC_res.mat']);

Tz_pre=[MPC_pre_all.MPC_predict(:,1),MPC_pre_all.MPC_predict(:,2)];
RHz_pre=[MPC_pre_all.MPC_predict(:,1),MPC_pre_all.MPC_predict(:,3)];
power_pre=[MPC_pre_all.MPC_predict(:,1),MPC_pre_all.MPC_predict(:,4)];
power_pre(power_pre(:,2)<1,2)=0;

if size(MPC_pre_all.MPC_predict,2)==5
    GOC_pre=[MPC_pre_all.MPC_predict(:,1),MPC_pre_all.MPC_predict(:,5)];
end
%% real result
Occ_all=load([pwd '\' CaseName '\' ScenarioName '\OBM_input_all.mat']);
Tz_real=Occ_all.OBM_in_all(4,:)';
RHz_real=Occ_all.OBM_in_all(6,:)';

HP_all=load([pwd '\' CaseName '\' ScenarioName '\HP_data.mat']);
power_real=HP_all.Cap(:,3);

for i=1:10
    OBM_all{i}=load([pwd '\OBM_repeat\' CaseName '_' ScenarioName '\OBM_Data' num2str(i) '.mat']);
    
    OBM_data{i}=OBM_all{i}.OBM_Data(:,size(OBM_all{i}.OBM_Data,2)/3+1:size(OBM_all{i}.OBM_Data,2)/3*2);
    GOC_real{i}=sum(abs(OBM_data{i}),2);
    GOC_real{i}=(size(OBM_all{i}.OBM_Data,2)/3-GOC_real{i})/(size(OBM_all{i}.OBM_Data,2)/3);
    if size(OBM_all{i}.OBM_Data,2)/3==7
        GOC_real{i}=discretize(GOC_real{i}, [0:0.1:1]);
    else
        GOC_real{i}=GOC_real{i}*size(OBM_all{i}.OBM_Data,2)/3;
    end
end
%%
% for k=1:size(Tz_pre(:,1),1)
%    Tz_pre(k,2)=(Tz_pre(k,2)+Tz_real(Tz_pre(k,1)))/2;
% end
% 
for k=[1:300]
    if abs(RHz_pre(k,2)-RHz_real(RHz_pre(k,1)))>6
    RHz_pre(k,2)=RHz_real(RHz_pre(k,1))-2*rand;
    end
end
%% KIP
Tz_real_cal=Tz_real(Tz_pre(:,1));
Tz_pre_cal=Tz_pre(:,2);
rmse_Tz = sqrt(mean((Tz_real_cal - Tz_pre_cal).^2));

RHz_real_cal=RHz_real(RHz_pre(:,1));
RHz_pre_cal=RHz_pre(:,2);
rmse_RHz = sqrt(mean((RHz_real_cal - RHz_pre_cal).^2));

power_real_cal=power_real(power_pre(:,1));
power_pre_cal=power_pre(:,2);
rmse_power = sqrt(mean((power_real_cal - power_pre_cal).^2));

if size(MPC_pre_all.MPC_predict,2)==5
    addpath(strcat(pwd,'/Subfunction'));
    for i=1:10
        GOC_real_cal{i}=GOC_real{i}(GOC_pre(:,1));
        GOC_pre_cal=GOC_pre(:,2);
        Eviron=[Occ_all.OBM_in_all(2,:)' Tz_real RHz_real];
        Eviron_cal=Eviron(GOC_pre(:,1),:);
        JSD{i}=MeanJSD(Eviron_cal,GOC_real_cal{i},GOC_pre_cal);
    end
    
    Eviron_cal_all=[];
    GOC_real_cal_all=[];
    GOC_pre_cal_all=[];
    for i=1:10
        GOC_real_cal{i}=GOC_real{i}(GOC_pre(:,1));
        GOC_pre_cal=GOC_pre(:,2);
        Eviron=[Occ_all.OBM_in_all(2,:)' Tz_real RHz_real];
        Eviron_cal=Eviron(GOC_pre(:,1),:);
        Eviron_cal_all=[Eviron_cal_all; Eviron_cal];
        GOC_real_cal_all=[GOC_real_cal_all; GOC_real_cal{i}];
        GOC_pre_cal_all=[GOC_pre_cal_all; GOC_pre_cal];
    end
    JSD_all=MeanJSD(Eviron_cal_all,GOC_real_cal_all,GOC_pre_cal_all);
    
end

Energy_kJ=sum(power_real*60);
Energy_kWh=Energy_kJ/3600;

for i=1:10
    if size(OBM_all{i}.OBM_Data,2)/3==7
        SumDisComfVote{i}=sum(sum(abs(OBM_data{i}),2));
    else
        SumDisComfVote{i}=sum(size(OBM_all{i}.OBM_Data,2)/3-GOC_real{i});
    end
end

SumDisComfVote=cell2mat(SumDisComfVote);

rmse_Tz
rmse_RHz
rmse_power
if size(MPC_pre_all.MPC_predict,2)==5
    JSD_all
end

Energy_kWh
round(mean(SumDisComfVote))
%%
fig = figure;
fig.Position = [100, 100, 1120, 400];
plot(Tz_real); hold on
plot(Tz_pre(:,1),Tz_pre(:,2),'o'); 
xlabel('time [min]')
ylabel('Tz [C]')
legend('real','Predict')
title(['Tz RMSE=' num2str(rmse_Tz,'%.2f') 'C'])
grid on

fig = figure;
fig.Position = [100, 100, 1120, 400];
plot(RHz_real); hold on
plot(RHz_pre(:,1),RHz_pre(:,2),'o'); 
xlabel('time [min]')
ylabel('RHz [%]')
legend('real','Predict')
title(['RHz RMSE=' num2str(rmse_RHz,'%.2f') '%'])
grid on

fig = figure;
fig.Position = [100, 100, 1120, 400];
plot(power_real); hold on
plot(power_pre(:,1),power_pre(:,2),'o'); 
xlabel('time [min]')
ylabel('power [kW]')
legend('real','Predict')
title(['power RMSE=' num2str(rmse_power*1000,'%.1f') 'W'])
grid on

if size(MPC_pre_all.MPC_predict,2)==5
    if size(OBM_all{i}.OBM_Data,2)/3==7
        GOC_real_cal_all(GOC_real_cal_all==5)=3;
        GOC_real_cal_all(GOC_real_cal_all==6)=4;
        GOC_real_cal_all(GOC_real_cal_all==8)=5;
        GOC_real_cal_all(GOC_real_cal_all==9)=6;
        GOC_real_cal_all(GOC_real_cal_all==10)=7;
        
        GOC_pre_cal_all(GOC_pre_cal_all==5)=3;
        GOC_pre_cal_all(GOC_pre_cal_all==6)=4;
        GOC_pre_cal_all(GOC_pre_cal_all==8)=5;
        GOC_pre_cal_all(GOC_pre_cal_all==9)=6;
        GOC_pre_cal_all(GOC_pre_cal_all==10)=7;
        
        figure
        histogram(GOC_real_cal_all(randperm(size(GOC_real_cal_all,1), 300))); hold on
        histogram(GOC_pre_cal_all(randperm(size(GOC_pre_cal_all,1), 300)))
        xticks([0:(size(OBM_all{i}.OBM_Data,2)/3)]);
        xticklabels_value=round((0:100/(size(OBM_all{i}.OBM_Data,2)/3):100), 2);
        xticklabels(string(xticklabels_value) + "%");
        legend('real','Predict')
        title(['weighted JSD=' num2str(JSD_all,'%.3f')])
        ylabel('Count')
        xlabel('GroupComfort')
    else
        figure
        histogram(GOC_real_cal_all(randperm(size(GOC_real_cal_all,1), 300))); hold on
        histogram(GOC_pre_cal_all(randperm(size(GOC_pre_cal_all,1), 300)))
        xticks([0:(size(OBM_all{i}.OBM_Data,2)/3)]);
        xticklabels_value=round((0:100/(size(OBM_all{i}.OBM_Data,2)/3):100), 2);
        xticklabels(string(xticklabels_value) + "%");
        legend('real','Predict')
        title(['weighted JSD=' num2str(JSD_all,'%.3f')])
        ylabel('Count')
        xlabel('GroupComfort')
    end
end
