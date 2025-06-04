function ASHP(block)
%MSFUNTMPL_BASIC A Template for a Level-2 MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.

%   Copyright 2003-2018 The MathWorks, Inc.

%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C MEX counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions        = 10;
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = true;

% Override output port properties
block.OutputPort(1).Dimensions       = 4;
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';


% Register parameters
block.NumDialogPrms     = 0;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [0 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------

% block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
% block.RegBlockMethod('InitializeConditions', @InitializeConditions);
% block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
% block.RegBlockMethod('Update', @Update);
% block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate); % Required

%end setup

%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C MEX counterpart: mdlSetWorkWidths
%%
function DoPostPropSetup(block)
% block.NumDworks = 1;
%   
%   block.Dwork(1).Name            = 'x1';
%   block.Dwork(1).Dimensions      = 1;
%   block.Dwork(1).DatatypeID      = 0;      % double
%   block.Dwork(1).Complexity      = 'Real'; % real
%   block.Dwork(1).UsedAsDiscState = true;


%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C MEX counterpart: mdlInitializeConditions
%%
function InitializeConditions(block)

%end InitializeConditions


%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C MEX counterpart: mdlStart
%%
function Start(block)
block.Dwork(1).Data = 0;

%end Start

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C MEX counterpart: mdlOutputs
%%
function Outputs(block)
persistent Cooling_HSpeedTable Cooling_LSpeedTable Heating_HSpeedTable Heating_LSpeedTable 
persistent  HP_speed m_sup_all Cap StopTime
%% Initialization
if isempty(Cooling_HSpeedTable)
    [Cooling_HSpeedTable]=xlsread('COEF_SS_HIGHSpeed-ALL',1,'B7:K10');
    [Cooling_LSpeedTable]=xlsread('COEF_SS_LowSpeed-ALL',1,'B7:K10');
    [Heating_HSpeedTable]=xlsread('COEF-Heating-HIGH-COMBINED-ALL',1,'B4:K40');
    [Heating_LSpeedTable]=xlsread('COEF-Heating-LOW-COMBINED-ALL',1,'B4:K40');
    HP_speed=0;  % -1=heating low speed, -2=heating high speed, 0=passby, 1=cooling low speed, 2=cooling high speed
    m_sup_all=[0 680 1055 ;0 630 1015];  % the supply air mass flow rate in different HP operation speed [cfm]
    Cap=[];  % record TC, speed, and Power
    StopTime=eval(get_param(bdroot, 'StopTime'));   
end
%% Read the input
InputData=block.InputPort(1).Data;
Tz=InputData(1);
Tz_d=InputData(2);
wz=InputData(3);
To=InputData(4);
To_d=InputData(5);
wo=InputData(6);
TC=InputData(7);
TH=InputData(8);
HP_status=InputData(9);
time=InputData(10);
%% Determine HP cooling/heating mode and speed
if HP_status==1
    if HP_speed==0   % current status = no running
        if Tz<TC && Tz>TH
            HP_speed=0;
        elseif (Tz-TC)>=0 && (Tz-TC)<(0.5/1.8)
            HP_speed=0;
        elseif (Tz-TC)>=(0.5/1.8) && (Tz-TC)<(1/1.8)
            HP_speed=1;
        elseif (Tz-TC)>=(1/1.8)
            HP_speed=2;
        elseif (TH-Tz)>=0 && (TH-Tz)<(0.5/1.8)
            HP_speed=0;
        elseif (TH-Tz)>=(0.5/1.8) && (TH-Tz)<(1/1.8)
            HP_speed=-1;
        elseif (TH-Tz)>=(1/1.8)
            HP_speed=-2;
        end
    elseif HP_speed==1   % current status = low speed cooling
        if (Tz-TC)<0
            HP_speed=0;
        elseif (Tz-TC)>=0 && (Tz-TC)<(0.5/1.8)
            HP_speed=1;
        elseif (Tz-TC)>=(0.5/1.8) && (Tz-TC)<(1/1.8)
            HP_speed=1;
        elseif (Tz-TC)>=(1/1.8)
            HP_speed=2;
        end
    elseif HP_speed==2   % current status = high speed cooling
        if (Tz-TC)<0
            HP_speed=0;
        elseif (Tz-TC)>=0 && (Tz-TC)<(0.5/1.8)
            HP_speed=1;
        elseif (Tz-TC)>=(0.5/1.8) && (Tz-TC)<(1/1.8)
            HP_speed=2;
        elseif (Tz-TC)>=(1/1.8)
            HP_speed=2;
        end
    elseif HP_speed==-1   % current status = low speed heating
        if (TH-Tz)<0
            HP_speed=0;
        elseif (TH-Tz)>=0 && (TH-Tz)<(0.5/1.8)
            HP_speed=-1;
        elseif (TH-Tz)>=(0.5/1.8) && (TH-Tz)<(1/1.8)
            HP_speed=-1;
        elseif (TH-Tz)>=(1/1.8)
            HP_speed=-2;
        end
    elseif HP_speed==-2   % current status = high speed heating
        if (TH-Tz)<0
            HP_speed=0;
        elseif (TH-Tz)>=0 && (TH-Tz)<(0.5/1.8)
            HP_speed=-1;
        elseif (TH-Tz)>=(0.5/1.8) && (TH-Tz)<(1/1.8)
            HP_speed=-2;
        elseif (TH-Tz)>=(1/1.8)
            HP_speed=-2;
        end
    end
end

% if mod(time,86400)>6*3600 && mod(time,86400)<20*3600
%     if mod(time,3600) == 0
%         HP_speed=randi([-1,2],1,1);
%         if HP_speed==-1
%             HP_speed=0;
%         end
%     end
% else
%     HP_speed=0;
% end
%% Calculate the sensible/latant capacity and HP power
if HP_status==1 && HP_speed>0 % cooling case
    x1_real=Tz*1.8+32;     % [F]
    x1=max(min(x1_real,80),65);
    x2_real=Tz_d*1.8+32;   % [F]
    x2=max(min(x2_real,61),55);
    x3_real=To*1.8+32;     % [F]
    if HP_speed==1
        x3=max(min(x3_real,110),75);
    elseif HP_speed==2
        x3=max(min(x3_real,110),80);
    end
    
    if HP_speed==1
        SenCap=Cooling_LSpeedTable(1,1)+Cooling_LSpeedTable(1,2)*x1+Cooling_LSpeedTable(1,3)*x2+...
            Cooling_LSpeedTable(1,4)*x3+Cooling_LSpeedTable(1,5)*x1*x2+Cooling_LSpeedTable(1,6)*x1*x3+...
            Cooling_LSpeedTable(1,7)*x2*x3+Cooling_LSpeedTable(1,8)*x1^2+Cooling_LSpeedTable(1,9)*x2^2+...
            Cooling_LSpeedTable(1,10)*x3^2;  % [btu/hr]
        TotCap=Cooling_LSpeedTable(3,1)+Cooling_LSpeedTable(3,2)*x1+Cooling_LSpeedTable(3,3)*x2+...
            Cooling_LSpeedTable(3,4)*x3+Cooling_LSpeedTable(3,5)*x1*x2+Cooling_LSpeedTable(3,6)*x1*x3+...
            Cooling_LSpeedTable(3,7)*x2*x3+Cooling_LSpeedTable(3,8)*x1^2+Cooling_LSpeedTable(3,9)*x2^2+...
            Cooling_LSpeedTable(3,10)*x3^2;  % [btu/hr]
        Power=Cooling_LSpeedTable(4,1)+Cooling_LSpeedTable(4,2)*x1+Cooling_LSpeedTable(4,3)*x2+...
            Cooling_LSpeedTable(4,4)*x3+Cooling_LSpeedTable(4,5)*x1*x2+Cooling_LSpeedTable(4,6)*x1*x3+...
            Cooling_LSpeedTable(4,7)*x2*x3+Cooling_LSpeedTable(4,8)*x1^2+Cooling_LSpeedTable(4,9)*x2^2+...
            Cooling_LSpeedTable(4,10)*x3^2;  % [W]
    elseif HP_speed==2
        SenCap=Cooling_HSpeedTable(1,1)+Cooling_HSpeedTable(1,2)*x1+Cooling_HSpeedTable(1,3)*x2+...
            Cooling_HSpeedTable(1,4)*x3+Cooling_HSpeedTable(1,5)*x1*x2+Cooling_HSpeedTable(1,6)*x1*x3+...
            Cooling_HSpeedTable(1,7)*x2*x3+Cooling_HSpeedTable(1,8)*x1^2+Cooling_HSpeedTable(1,9)*x2^2+...
            Cooling_HSpeedTable(1,10)*x3^2;  % [btu/hr]
        TotCap=Cooling_HSpeedTable(3,1)+Cooling_HSpeedTable(3,2)*x1+Cooling_HSpeedTable(3,3)*x2+...
            Cooling_HSpeedTable(3,4)*x3+Cooling_HSpeedTable(3,5)*x1*x2+Cooling_HSpeedTable(3,6)*x1*x3+...
            Cooling_HSpeedTable(3,7)*x2*x3+Cooling_HSpeedTable(3,8)*x1^2+Cooling_HSpeedTable(3,9)*x2^2+...
            Cooling_HSpeedTable(3,10)*x3^2;  % [btu/hr]
        Power=Cooling_HSpeedTable(4,1)+Cooling_HSpeedTable(4,2)*x1+Cooling_HSpeedTable(4,3)*x2+...
            Cooling_HSpeedTable(4,4)*x3+Cooling_HSpeedTable(4,5)*x1*x2+Cooling_HSpeedTable(4,6)*x1*x3+...
            Cooling_HSpeedTable(4,7)*x2*x3+Cooling_HSpeedTable(4,8)*x1^2+Cooling_HSpeedTable(4,9)*x2^2+...
            Cooling_HSpeedTable(4,10)*x3^2;  % [W]
    end
    % convert the unit
    m_sup=m_sup_all(1,HP_speed+1)*0.0283*1.225/60;  % cfm to kg/s
    SenCap=SenCap*0.293;  % btu/hr to W
    TotCap=TotCap*0.293;  % btu/hr to W
    Power=0.001*Power;    % W to kW
    % based on the HP input air (equal to zone air) and sensible/total
    % capacity to calculate the HP output air
    T_sup=Tz-SenCap/(1000*m_sup*(1.006+1.86*0.007))+1.5/1.8;
    % w_sup=(1.006*(Tz-(T_sup-1.5/1.8))+1.86*Tz*wz+2501*wz-(TotCap/(1000*m_sup)))/(1.86*(T_sup-1.5/1.8)+2501);
    w_sup=0.011;
elseif HP_status==1 && HP_speed<0 % heating case
    x1_real=To*1.8+32;     % [F]
    x2_real=To_d*1.8+32;   % [F]
    x3_real=Tz*1.8+32;     % [F]
    if HP_speed==-1
        x1=max(min(x1_real,68.20),45.55);
        x2=max(min(x2_real,41.14),34.48);
        x3=max(min(x3_real,72.16),67.51);
    elseif HP_speed==-2
        x1=max(min(x1_real,60.27),43.10);
        x2=max(min(x2_real,37.64),34.38);
        x3=max(min(x3_real,72.16),67.85);
    end
    
    if HP_speed==-1
        SenCap=Heating_LSpeedTable(35,1)+Heating_LSpeedTable(35,2)*x1+Heating_LSpeedTable(35,3)*x2+...
            Heating_LSpeedTable(35,4)*x3+Heating_LSpeedTable(35,5)*x1*x2+Heating_LSpeedTable(35,6)*x1*x3+...
            Heating_LSpeedTable(35,7)*x2*x3+Heating_LSpeedTable(35,8)*x1*x1+Heating_LSpeedTable(35,9)*x2*x2+...
            Heating_LSpeedTable(35,10)*x3*x3;
        TotCap=Heating_LSpeedTable(37,1)+Heating_LSpeedTable(37,2)*x1+Heating_LSpeedTable(37,3)*x2+...
            Heating_LSpeedTable(37,4)*x3+Heating_LSpeedTable(37,5)*x1*x2+Heating_LSpeedTable(37,6)*x1*x3+...
            Heating_LSpeedTable(37,7)*x2*x3+Heating_LSpeedTable(37,8)*x1*x1+Heating_LSpeedTable(37,9)*x2*x2+...
            Heating_LSpeedTable(37,10)*x3*x3;
        Power=Heating_LSpeedTable(1,1)+Heating_LSpeedTable(1,2)*x1+Heating_LSpeedTable(1,3)*x2+...
            Heating_LSpeedTable(1,4)*x3+Heating_LSpeedTable(1,5)*x1*x2+Heating_LSpeedTable(1,6)*x1*x3+...
            Heating_LSpeedTable(1,7)*x2*x3+Heating_LSpeedTable(1,8)*x1*x1+Heating_LSpeedTable(1,9)*x2*x2+...
            Heating_LSpeedTable(1,10)*x3*x3+...
            Heating_LSpeedTable(4,1)+Heating_LSpeedTable(4,2)*x1+Heating_LSpeedTable(4,3)*x2+...
            Heating_LSpeedTable(4,4)*x3+Heating_LSpeedTable(4,5)*x1*x2+Heating_LSpeedTable(4,6)*x1*x3+...
            Heating_LSpeedTable(4,7)*x2*x3+Heating_LSpeedTable(4,8)*x1*x1+Heating_LSpeedTable(4,9)*x2*x2+...
            Heating_LSpeedTable(4,10)*x3*x3;
    elseif HP_speed==-2
        SenCap=Heating_HSpeedTable(35,1)+Heating_HSpeedTable(35,2)*x1+Heating_HSpeedTable(35,3)*x2+...
            Heating_HSpeedTable(35,4)*x3+Heating_HSpeedTable(35,5)*x1*x2+Heating_HSpeedTable(35,6)*x1*x3+...
            Heating_HSpeedTable(35,7)*x2*x3+Heating_HSpeedTable(35,8)*x1*x1+Heating_HSpeedTable(35,9)*x2*x2+...
            Heating_HSpeedTable(35,10)*x3*x3;
        TotCap=Heating_HSpeedTable(37,1)+Heating_HSpeedTable(37,2)*x1+Heating_HSpeedTable(37,3)*x2+...
            Heating_HSpeedTable(37,4)*x3+Heating_HSpeedTable(37,5)*x1*x2+Heating_HSpeedTable(37,6)*x1*x3+...
            Heating_HSpeedTable(37,7)*x2*x3+Heating_HSpeedTable(37,8)*x1*x1+Heating_HSpeedTable(37,9)*x2*x2+...
            Heating_HSpeedTable(37,10)*x3*x3;
        Power=Heating_HSpeedTable(1,1)+Heating_HSpeedTable(1,2)*x1+Heating_HSpeedTable(1,3)*x2+...
            Heating_HSpeedTable(1,4)*x3+Heating_HSpeedTable(1,5)*x1*x2+Heating_HSpeedTable(1,6)*x1*x3+...
            Heating_HSpeedTable(1,7)*x2*x3+Heating_HSpeedTable(1,8)*x1*x1+Heating_HSpeedTable(1,9)*x2*x2+...
            Heating_HSpeedTable(1,10)*x3*x3+...
            Heating_HSpeedTable(4,1)+Heating_HSpeedTable(4,2)*x1+Heating_HSpeedTable(4,3)*x2+...
            Heating_HSpeedTable(4,4)*x3+Heating_HSpeedTable(4,5)*x1*x2+Heating_HSpeedTable(4,6)*x1*x3+...
            Heating_HSpeedTable(4,7)*x2*x3+Heating_HSpeedTable(4,8)*x1*x1+Heating_HSpeedTable(4,9)*x2*x2+...
            Heating_HSpeedTable(4,10)*x3*x3;
    end
    % convert the unit
    m_sup=m_sup_all(2,(-1)*HP_speed+1)*0.0283*1.225/60;  % cfm to kg/s
    SenCap=SenCap*0.293;  % btu/hr to W
    TotCap=TotCap*0.293;  % btu/hr to W
    Power=0.001*Power;    % W to kW
    % based on the HP input air (equal to zone air) and sensible/total
    % capacity to calculate the HP output air
    T_sup=Tz+SenCap/(1000*m_sup*(1.006+1.86*0.00875))-1.1/1.8;
    w_sup=(-1.006*(T_sup+1.1/1.8-Tz)+1.86*Tz*wz+2501*wz+(TotCap/(1000*m_sup)))/(1.86*(T_sup+1.1/1.8)+2501);
else  % for the case HP is not running or bypass
    m_sup=0;
    T_sup=Tz;
    w_sup=wz;
    Power=0;
end

Cap=[Cap; TC HP_speed Power];
if time==StopTime
    save('HP_data.mat','Cap')
end
save('m_sup.mat','m_sup')

block.OutputPort(1).Data = [m_sup,T_sup,w_sup,Power];

%end Outputs

%%
%% Update:
%%   Functionality    : Called to update discrete states
%%                      during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlUpdate
%%
function Update(block)

% block.Dwork(1).Data = block.InputPort(1).Data;

%end Update

%%
%% Derivatives:
%%   Functionality    : Called to update derivatives of
%%                      continuous states during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlDerivatives
%%
function Derivatives(block)

%end Derivatives

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C MEX counterpart: mdlTerminate
%%
function Terminate(block)

%end Terminate

