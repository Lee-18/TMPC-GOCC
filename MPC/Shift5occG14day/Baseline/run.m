clc
clear all
testbed_dir=[fileparts(pwd),'\testbed'];

addpath(strcat(testbed_dir,'\MPC'))
addpath(strcat(testbed_dir,'\MPC\Model'))
addpath(strcat(testbed_dir,'\MPC\GroupOccModel'))
addpath(strcat(testbed_dir,'\MPC\OutdoorPredcition'))
addpath(strcat(testbed_dir,'\VB'))
addpath(strcat(testbed_dir,'\VB\VirtualASHP'))
addpath(strcat(testbed_dir,'\VB\OBM'))
%% run simulink
clc
clear all
model='SmallOffice_Atlanta_Occ';
load_system(model);
cs = getActiveConfigSet(model);
model_cs = cs.copy;

sim(model, model_cs);

