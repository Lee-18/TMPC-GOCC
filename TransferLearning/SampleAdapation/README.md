This folder contains various evaluation cases in transfer learning. Its folder structure is as follows:

Each subfolder (such as “Group 1”) represents a group with specific thermal comfort preferences. Groups 1 to 3 have neutral thermal preferences, Group 4 has a cold preference, and Group 5 has a warm preference.
Within each subfolder, there are two secondary subfolders (“TL_eff” and “TL_shift”), representing HVAC control strategy scenarios.  
The secondary subfolders contain multiple tertiary subfolders (such as “5occ”), representing groups with different numbers of occupants.  
The tertiary subfolders contain multiple quaternary subfolders (such as “1day”), representing different durations of target domain data collection.

Within each fourth-level subfolder (e.g., SampleAdapation\Group1\TL_eff\5occ\1day):  
TransferLearning_DomainAdaptation.m: Code implementing sample adaptation using a genetic algorithm.  
SampledInstances.mat: Sample data obtained after sample adaptation.

Within each second-level subfolder (such as SampleAdapation\Group1\TL_eff), there is another subfolder (“ModelTesting”) containing all the evaluation code for the evaluation cases in this scenario. Among these:  
AllTesting.m: The main code for testing the model performance before and after transfer learning. After execution, it generates “res.mat”, which records the JSD values for each evaluation case before and after transfer learning.
TargetModelTesting.m: Code for testing the model performance before transfer learning.
TargetTLModelTesting.m: Code for testing the model performance after transfer learning.
