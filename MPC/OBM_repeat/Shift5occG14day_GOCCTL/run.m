clc,clear all
[~, currentFolderName] = fileparts(pwd);
parts = split(currentFolderName, '_');

CaseName=parts{1};
ScenarioName=parts{2};
% defaultPaths = strsplit(matlabpath, pathsep);
%%
addpath([fileparts(fileparts(pwd)) '\' CaseName '\testbed\VB\OBM'])
addpath([fileparts(fileparts(pwd)) '\' CaseName '\' ScenarioName])

OneRun
OneRun
OneRun
OneRun
OneRun
OneRun
OneRun
OneRun
OneRun
OneRun

%%
% % 获取当前所有的路径
% allPaths = strsplit(path, pathsep);
% % 找出用户添加的路径（即不在默认路径中的路径）
% userAddedPaths = setdiff(allPaths, defaultPaths);
% rmpath(userAddedPaths{:})