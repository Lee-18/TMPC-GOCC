The virtual testbed used for TMPC-GOCC including three components: ASHP system, EnergyPlus building model, and occupants model. The following is a brief introduction to the code involved in these three components.   

**ASHP**:   
*VirtualASHP*: includes ASHP model and its interaction files
*ASHP.m*: the function used in "SmallOffice_Atlanta_Occ.slx" Simulink to call ASHP model

**ASHRAE901_OfficeSmall_STD2004_Atlanta.fmu**: the FMU file generated by EnergyPlus for co-simulation in Simulink

**OBM**: includes all the subfunction about the occupant comfort and behavior model

**SmallOffice_Atlanta_Occ.slx**: the final Simulink file connecting the three components.
