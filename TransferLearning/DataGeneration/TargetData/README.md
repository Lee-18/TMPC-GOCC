This folder contains code for target domain data generation. Using 5-occupants group with neutral preference case as example. The folder structure is as follows:

Within the subfolder (...\TargetData\Group1\5):
SmallOffice_Atlanta_Occ_Eff.slx: A Simulink file used to generate target domain data for the efficiency scenario.
SmallOffice_Atlanta_Occ_Shift.slx: A Simulink file used to generate target domain data for the shifting scenario.
SmallOffice_Atlanta_Occ_testing.slx: A Simulink file used to generate test data.
TargetEffDataPull.m and TargetShiftDataPull.m: Generate target domain data based on the simulation results of the corresponding Simulink files.  
TargetTestingDataPull.m: Generate test data based on the simulation results.
