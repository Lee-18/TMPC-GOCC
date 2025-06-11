clc
clear all
addpath(strcat(pwd,'\VirtualASHP'))
addpath(strcat(pwd,'\OBM'))
%% run simulink
clc
clear all
model='SmallOffice_Atlanta_Occ_AL';
load_system(model);
cs = getActiveConfigSet(model);
model_cs = cs.copy;

sim(model, model_cs);
TargetDataPull;

%%
clc
clear all
model='SmallOffice_Atlanta_Occ_AL_testing';
load_system(model);
cs = getActiveConfigSet(model);
model_cs = cs.copy;

sim(model, model_cs);
TargetTestingDataPull;
%%
clc
clear all
model='SmallOffice_Atlanta_Occ_Shift';
load_system(model);
cs = getActiveConfigSet(model);
model_cs = cs.copy;

sim(model, model_cs);
TargetShiftDataPull;

%%
clc
clear all
rng('shuffle');
model='SmallOffice_Atlanta_Occ_Eff';
load_system(model);
cs = getActiveConfigSet(model);
model_cs = cs.copy;

sim(model, model_cs);
TargetEffDataPull;