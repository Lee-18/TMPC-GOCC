function J_val=ObjectiveFunction(t,Tz_0,RHz_0,To_0,RHo_0,Speed_ph,NumOcc,ph,GEB,Tlb,Tub,GroupOcc,TL)
persistent init_ind price_hour To_pre RHo_pre mdl_Tz MARS_RHz net_power Mdl_RF_all
%% initialize
if isempty(init_ind)
    price_hour(1,1:14)=0.00746;
    price_hour(1,15:19)=0.01692;
    price_hour(1,20:24)=0.00746;
    
    load('OutdoorPrediction.mat')
    ModelName_RHz=[num2str(NumOcc) '_MARS_RHz.mat'];
    ModelName_power=[num2str(NumOcc) '_net_power.mat'];
    ModelName_Tz=[num2str(NumOcc) '_MLR_Tz.mat'];
    
    load(ModelName_Tz)
    load(ModelName_RHz)
    load(ModelName_power)
    if GroupOcc==1
        if TL==1
            load('GroupOccModel_TL.mat')
        else
            load('GroupOccModel_nonTL.mat')
        end
    end
    init_ind=1;
end
%% Objective function
for i=1:ph
    To_next(i)=To_pre(t+i*15);
    RHo_next(i)=RHo_pre(t+i*15);
    
    Input_Tz_model(i,:)=[Tz_0 RHz_0 To_0 To_next(i) Speed_ph(i)];
    Input_RHz_model(i,:)=[Tz_0 RHz_0 To_0 To_next(i) Speed_ph(i)];
    Input_power_model(i,:)=[Tz_0 RHz_0 To_0 RHo_0 To_next(i) RHo_next(i) Speed_ph(i)];
    
    Pre_Tz(i) = predict(mdl_Tz, Input_Tz_model(i,:));
    Pre_RHz(i)=arespredict(MARS_RHz,Input_RHz_model(i,:));
    Pre_power(i)=net_power(Input_power_model(i,:)');
    if Pre_power(i)<1
        Pre_power(i)=0;
    end
    
    if GroupOcc==1
        Input_GroupOcc_model(i,:)=[To_next(i) Pre_Tz(i) Pre_RHz(i)];
        Pre_GroupOcc_cell(i) = predict(Mdl_RF_all, Input_GroupOcc_model(i,:));
        Pre_GroupOcc(i)=str2double(Pre_GroupOcc_cell(i));
    end
    
    Tz_0=Pre_Tz(i);
    RHz_0=Pre_RHz(i);
    
    To_0=To_next(i);
    RHo_0=RHo_next(i);
end

if GroupOcc==1 % GroupOcc case violation
    if NumOcc==7
        Vio=sum(10-Pre_GroupOcc);
    else
        Vio=sum(NumOcc-Pre_GroupOcc);
    end
else % Non GroupOcc case violation
    Vio=sum(Pre_Tz < Tlb | Pre_Tz > Tub);
end

if GEB==1
    J=sum(Pre_power)+Vio*99;
else
    t_ph=t+15:15:t+15*ph;
    t_hour_ph=ceil(mod(t_ph,1440)/60);
    J_temp=0;
    for ph_temp=1:ph
        J_temp=J_temp+Pre_power(ph_temp)*price_hour(t_hour_ph(ph_temp));
    end
    J=J_temp+Vio*99;
end
J_val=J;
end