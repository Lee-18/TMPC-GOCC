clc
clear all
model='OBM_repeat';
load_system(model);
cs = getActiveConfigSet(model);
model_cs = cs.copy;
sim(model, model_cs);

load('OBM_Data.mat')
keyword = 'OBM_Data';
files = dir(['*' keyword '*']);
numFiles = numel(files);

save(['OBM_Data' num2str(numFiles) '.mat'],'OBM_Data')