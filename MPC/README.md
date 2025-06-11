This folder is for the development and evaluation of the TMPC-GOCC strategy (using Shift-5occ-G1-4day as an example). It primarily contains the following:

**Folder Shift5occG14day**: The three MPCs in this case study, namely temperature-based MPC, GOCC-based MPC, and GOCC+TL MPC. This folder also contains three subfolders (Baseline, GOCC, and GOCCTL), corresponding to the aforementioned three MPCs.   
	The *run.m* file in each subfolder serves as the main program for running the respective MPC.   
 	This folder also includes a testbed subfolder, which contains:   
  		_Folder VB_: Virtual testbed for simulation   
    		_Folder MPC_:   
      			Folder GroupOccModel: Contains group thermal comfort models obtained before and after transfer learning    
	 		Folder Model: Zone temperature model, zone air relative humidity model, HVAC system power model    
    			Folder OutdoorPrediction: Predictions for outdoor temperature and humidity    
       			MPC.m: Code for MPC interaction in the Simulink file of the virtual testbed.   
	  		ObjectiveFunction.m: The objective function of the MPC.   
       			Speed_determine.m: Determines the operating state of the HVAC (ASHP) system using MPC.

**Folder OBM_repeat**: Due to the randomness of thermal comfort, multiple repeated simulations of occupant thermal comfort are performed to obtain the distribution of occupant thermal comfort.   
**KPI_check.m**: Calculation of KPIs for MPC simulation results.    
**Folder Subfunction**: Sub-equations used in KPI_check.m.
