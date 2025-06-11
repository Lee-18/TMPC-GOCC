function Speed_opt=Speed_determine(time_sim,Tz_0,RHz_0,To_0,RHo_0,NumOcc,ph,Tlb,Tub,GEB,GroupOcc,TL)
persistent init  To_pre RHo_pre mdl_Tz MARS_RHz net_power MPC_predict MPC_opt Mdl_RF_all
t=(time_sim-186*86400)/60;

ranges = repmat({0:2}, 1, ph);
Speed_ph = combvec(ranges{:})';

for i=1:size(Speed_ph,1)
    J_val(i)=ObjectiveFunction(t,Tz_0,RHz_0,To_0,RHo_0,Speed_ph(i,:),NumOcc,ph,GEB,Tlb,Tub,GroupOcc,TL);
end

[J_min,ind]=min(J_val);

Speed_ph_opt=Speed_ph(ind,:);
Speed_opt=Speed_ph_opt(1);

%% output predicted results
if isempty(init)
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
    init=1;
    
    MPC_predict=[];
    MPC_opt=[];
end
Input_Tz_model=[Tz_0 RHz_0 To_0 To_pre(t+15) Speed_opt];
Input_RHz_model=[Tz_0 RHz_0 To_0 To_pre(t+15) Speed_opt];
Input_power_model=[Tz_0 RHz_0 To_0 RHo_0 To_pre(t+15) RHo_pre(t+15) Speed_opt];

Pre_Tz = predict(mdl_Tz, Input_Tz_model);
Pre_RHz=arespredict(MARS_RHz,Input_RHz_model);
Pre_power=net_power(Input_power_model');
if GroupOcc==1
    Input_GroupOcc_model=[To_pre(t+15) Pre_Tz Pre_RHz];
    Pre_GroupOcc_cell = predict(Mdl_RF_all, Input_GroupOcc_model);
    Pre_GroupOcc=str2double(Pre_GroupOcc_cell);
    
    MPC_predict=[MPC_predict; t+15,Pre_Tz,Pre_RHz,Pre_power,Pre_GroupOcc];
else
    MPC_predict=[MPC_predict; t+15,Pre_Tz,Pre_RHz,Pre_power];
end

MPC_opt=[MPC_opt; t+15,Speed_ph_opt];
save('MPC_res.mat','MPC_predict','MPC_opt')

end