clc
clear all
currentFolder = pwd;
parentFolder = fileparts(currentFolder);
par_dir=strcat(parentFolder,'\Shared');
addpath(par_dir)
addpath(strcat(par_dir,'\VirtualASHP'))
addpath(strcat(par_dir,'\OBM'))

rng('shuffle');

model='SmallOffice_Atlanta_Occ_AL';
%% run simulink
load_system(model);
cs = getActiveConfigSet(model);
model_cs = cs.copy;

sim(model, model_cs);