function varargout = MasterControlGUI(varargin)
% MASTERCONTROLGUI MATLAB code for MasterControlGUI.fig
%      MASTERCONTROLGUI, by itself, creates a new MASTERCONTROLGUI or raises the existing
%      singleton*.
%
%      H = MASTERCONTROLGUI returns the handle to a new MASTERCONTROLGUI or the handle to
%      the existing singleton*.
%
%      MASTERCONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASTERCONTROLGUI.M with the given input arguments.
%
%      MASTERCONTROLGUI('Property','Value',...) creates a new MASTERCONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MasterControlGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MasterControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% edit_wingverticalaligner the above text to modify the response to help MasterControlGUI

% Last Modified by GUIDE v2.5 02-Aug-2016 12:30:17

% Begin initialization code - DO NOT EDIT_WINGVERTICALALIGNER
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MasterControlGUI_OpeningFcn, ...
    'gui_OutputFcn',  @MasterControlGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT_WINGVERTICALALIGNER

% --- Executes just before MasterControlGUI is made visible.
function MasterControlGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MasterControlGUI (see VARARGIN)

% Choose default command line output for MasterControlGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes MasterControlGUI wait for user response (see UIRESUME)
% uiwait(handles.HomeScreen);

% --- Outputs from this function are returned to the command line.
function varargout = MasterControlGUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%% DONT EDIT ANY FUNCTIONS ABOVE THIS LINE %%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%% GUI CALLBACK FUNCTIONS BEGIN HERE %%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pushbtn_ExperimentParameters.
function pushbtn_ExperimentParameters_Callback(hObject, eventdata, handles)
funcExperimentParameters

% --- Executes on button press in pushbtn_SensorsTare.
function pushbtn_SensorsTare_Callback(hObject, eventdata, handles)
%{
This function helps find the stationary load on the wing due when the
wind tunnel is running. To find so, first, a mean value from the
SensorZeroing function is taken without the windtunnel running, and then
the windtunnel is run, and mean values of reading taken again. The
difference of the two values gives the net load on the force and torque
gages due to the wind. This is later added to the raw when experiments
are run, because zeroing out the raw data in Run Experiment function
also subtracts the wind load, if the wind tunnel is running. Therefore
it is important to add this stationary load due to wind back again, after
the sensors are zeroed out.
%}
%% Initialization
windTare.zeroWindTareData=[0 0 0 0 0 0 0 0 0 0];
windTare.onWindTareData=[0 0 0 0 0 0 0 0 0 0];
% First sensors are tared without windtunnel on.
uiwait(warndlg({'First, make sure the windtunnel is switched off, that is,'...
    'wind speed should be 0 m/s'},'Zero windspeed (0 m/s) sensor taring'));
autoRun=0;
[tareArg1,tareArg2]=funcSensorTaring(autoRun); % Always Zeroes Sensor first
if tareArg1>0
    windTare.zeroWindTareData=tareArg2;
end
assignin('base','windTare',windTare);
% uisave('windTare','windTare');

% --- Executes on button press in pushbutton_AeroLoad.
function pushbutton_AeroLoad_Callback(hObject, eventdata, handles)
% This function helps find the stationary load on the wing due when the
% wind tunnel is running. To find so, first, a mean value from the
% SensorZeroing function is taken without the windtunnel running, and then
% the windtunnel is run, and mean values of reading taken again. The
% difference of the two values gives the net load on the force and torque
% gages due to the wind. This is later added to the raw when experiments
% are run, because zeroing out the raw data in Run Experiment function
% also subtracts the wind load, if the wind tunnel is running. Therefore
% it is important to add this stationary load due to wind back again, after
% the sensors are zeroed out.
%% Initialization
windTare.zeroWindTareData=[0 0 0 0 0 0 0 0 0 0];
windTare.onWindTareData=[0 0 0 0 0 0 0 0 0 0];
windTare.windLoadTareData=[0 0 0 0 0 0 0 0 0 0];
autoRun=0;
%% First sensors are tared without windtunnel on.
uiwait(warndlg({'First, make sure the windtunnel is switched off, that is,'...
    'wind speed should be 0 m/s'},'Zero windspeed (0 m/s) sensor taring'));
[tareArg1,tareArg2]=funcSensorTaring(autoRun); % Always Zeroes Sensor first
if tareArg1>0
    windTare.zeroWindTareData=tareArg2;
end
%% Then sensors are tared with windtunnel on
uiwait(warndlg('Now, set the windtunnel to desired windspeed and hit OK!',...
    'Zero windspeed (0 m/s) sensor taring'));
[tareArg1,tareArg2]=funcSensorTaring(autoRun); % Always Zeroes Sensor first
if tareArg1>0
    windTare.onWindTareData=tareArg2;
end
%% The difference gives the loading due to wind at stationary state
windTare.windLoadTareData = windTare.onWindTareData-windTare.zeroWindTareData;
assignin('base','windTare',windTare);
uiwait(warndlg('Stationary Wing Wind Loading Calibration Completed!','Successfull!!!'));

% --- Executes on button press in pushbtn_RunExperiment.
function pushbtn_RunExperiment_Callback(hObject, eventdata, handles)
%%
clc
clearvars -except windTare
temp=funcExperimentParameters; % calls this function that has settings
temp.graceCycles=4;  % always has to be even for DataProcessing to work
temp.autoRun=0;
%{
uiwait(warndlg({'If running experiment in windtunnel at non zero speed,'...
    'make sure you find the stationary-wing aerodynamic load first'},'Warning!!!'));
%}
continueExp = 1;
while continueExp==1
    %% Dialogbox for Parameters to generate file names
    testSettings=1;
    while testSettings==1
        window_title = 'Test Settings';
        prompt = {'Flexion Ratio','Shim Color','Pitch Angle [deg]',...
            'Wing Mass [g]',...
            'Experiment Setup [windtunnel or vacuumchamber]',...
            'Windtunnel Frequency','Temperature [C]','Humidity [%]',...
            'Differential Pressure [Pa for windtunnel OR in-Hg for vacuum chamber]'};
        num_lines = [1 47];
        defaultAns = {'100','none','0','28','windtunnel','5.3','33.2','28','11.7'};
        options.WindowStyle='normal';
        expSettings = inputdlg(prompt,window_title,num_lines,defaultAns,options);
        
        % if user presses Cancel
        if isempty(expSettings)
            return
        end
        % assigns the numeric values entered by the user to appropriate variables
        temp.flexionRatio = str2num(expSettings{1});
        temp.shimColor = lower(expSettings{2});
        temp.pitchAngle = str2num(expSettings{3});
        temp.wingMass = str2num(expSettings{4});
        temp.expSetup = lower(expSettings{5});
        temp.tunnelFreq = str2num(expSettings{6});
        temp.roomTemp = str2num(expSettings{7});
        temp.relHumidity = str2num(expSettings{8});
        temp.pressDiff = str2num(expSettings{9});
        
        % condition to check if all inputs are numerical and
        % the color of shimstock match with database
        % if inputs are non-numerical, then the input window is redisplayed
        if strcmp(temp.expSetup,'windtunnel')==1 | strcmp(temp.expSetup,'vacuumchamber')==1
            if strcmp(temp.shimColor,'none')==1 | strcmp(temp.shimColor,'silver')==1 |...
                    strcmp(temp.shimColor,'gold')==1 | strcmp(temp.shimColor,'amber')==1 |...
                    strcmp(temp.shimColor,'purple')==1 | strcmp(temp.shimColor,'red')==1 |...
                    strcmp(temp.shimColor,'green')==1 | strcmp(temp.shimColor,'tan')==1 |...
                    strcmp(temp.shimColor,'blue')==1 | strcmp(temp.shimColor,'transmatte')==1 |...
                    strcmp(temp.shimColor,'brown')==1 | strcmp(temp.shimColor,'black')==1 |...
                    strcmp(temp.shimColor,'pink')==1 | strcmp(temp.shimColor,'yellow')==1 |...
                    strcmp(temp.shimColor,'white')==1 | strcmp(temp.shimColor,'coral')==1
                % condition to check if all inputs are numerical
                % if inputs are non-numerical, then the input window is redisplayed
                if size(temp.flexionRatio) == 0 | size(temp.pitchAngle) == 0 |...
                        size(temp.tunnelFreq) == 0 | size(temp.roomTemp) == 0 |...
                        size(temp.relHumidity) == 0 | size(temp.pressDiff) == 0 |...
                        size(temp.wingMass) == 0
                    continue
                end
            else
                continue
            end
        else
            continue
        end
        testSettings=0;
    end
    %% Check if sensors are tared or not
    try
        windTare=evalin('base','windTare');
        temp.zeroWindTareData = windTare.zeroWindTareData;
    catch
        uiwait(warndlg({'Sensors are not tared.'...
            'Please tare sensors first and try again.'},'Warning!!!'));
        return
    end
    try
        windTare=evalin('base','windTare');
        temp.onWindTareData = windTare.onWindTareData;
        temp.windLoadTareData = windTare.windLoadTareData;
        temp.aeroLoadTaring=1;
    catch
        % Dialog box asking about AeroLoad Tare vs General Tare
        taringMethod = questdlg({'Aero Load Taring was not performed.',...
            'Do you want to proceed with general taring?'},...
            'Choice of Taring Method!', ...
            'Yes! General Taring it is!','Exit and Perform Aero Load Taring!',...
            'Exit and Perform Aero Load Taring!');
        % if user presses Cancel
        if isempty(taringMethod)
            return
        end
        if strcmp(taringMethod,'Yes! General Taring it is!')==1
            temp.aeroLoadTaring=0;
        elseif strcmp(taringMethod,'Exit and Perform Aero Load Taring!')==1
            return
        end
    end
    %% Dialog box for other experiment controls
    motionControl=1;
    while motionControl==1
        %% INPUT for experiment control
        window_title = 'Experimental Parameters';
        prompt = {'Frequency [Hz]','Corrected Peak-to-Peak Amplitude [deg]',...
            'Ideal Peak-to-Peak Amplitude [deg]','Ramp Up/Down (minimum 5)',...
            'Number of Cycles (minimum 10)','Offset Angle [deg]'};
        num_lines = [1 47];
        defaultAns = {'4.5','40','40','8','25','0'};
        options.WindowStyle='normal';
        expSettings = inputdlg(prompt,window_title,num_lines,defaultAns,options);
        % if user presses Cancel
        if isempty(expSettings)
            return
        end
        % assigns the numeric values entered by the user to appropriate variables
        temp.flapFrequency = str2num(expSettings{1});
        temp.correctedAmp = str2num(expSettings{2});
        temp.idealAmp = str2num(expSettings{3});
        temp.ramp = str2num(expSettings{4});
        temp.cycleNum = str2num(expSettings{5});
        temp.offsetAngle = str2num(expSettings{6});
        % condition to check if all inputs are numerical and
        % the color of shimstock match with database
        % if inputs are non-numerical, then the input window is redisplayed
        if size(temp.flapFrequency)== 0 | size(temp.idealAmp) == 0 |...
                size(temp.correctedAmp) == 0 | size(temp.ramp) == 0 |...
                size(temp.cycleNum) == 0 | size(temp.offsetAngle) == 0
            continue
        end
        motionControl=0;
    end
    rawSignal=experimentControl(temp);
    %% Dialog box to save the data
    fileSaveChoice = questdlg('Would you like to save the collected data?',...
        'Data Acquisition Complete!','YES','NO','YES');
    if strcmp(fileSaveChoice,'YES')==1
        %% MAT filename generation
        flapFrequency=num2str(rawSignal.flapFrequency);
        idealAmp=num2str(rawSignal.idealAmp);
        pitchAngle=num2str(rawSignal.pitchAngle);
        flexionRatio=num2str(rawSignal.flexionRatio);
        fileName=strcat('trial_',rawSignal.expSetup,'_rawSignal_',...
            flapFrequency,'freq_',idealAmp,'amp_',...
            pitchAngle,'pitch_',flexionRatio,'flex_',...
            rawSignal.shimColor,'Color');
        uisave('rawSignal',fileName);
    end
    %% Cleanup memory
    assignin('base','rawSignal',rawSignal);
    %% Dialog box asking what to do after completion
    nextTrialChoice = questdlg('What would you like to do next?',...
        'Experiment Completed!', ...
        'Next Run!','Terminate Program!','Next Run!');
    % if user presses Cancel
    if isempty(nextTrialChoice)
        continueExp=0;
        continue
    end
    if strcmp(nextTrialChoice,'Next Run!')==1
        continue
    elseif strcmp(nextTrialChoice,'Terminate Program!')==1
        continueExp=0;
        continue
    end
    
end

% --- Executes on button press in pushbtn_AutomateExperiments.
function pushbtn_AutomateExperiments_Callback(hObject, eventdata, handles)
%% Initialization
clc
clearvars -except windTare
temp=funcExperimentParameters; % calls this function that has settings
temp.graceCycles=4;  % always has to be even for DataProcessing to work
temp.autoRun=1;
%{
uiwait(warndlg({'If running experiment in windtunnel at non zero speed,'...
    'make sure you find the stationary-wing aerodynamic load first'},'Warning!!!'));
%}

%% Parameters to generate file names
testSettings=1;
while testSettings==1
    window_title = 'Test Settings';
    prompt = {'Flexion Ratio','Shim Color','Pitch Angle [deg]',...
        'Wing Mass [g]',...
        'Experiment Setup [windtunnel or vacuumchamber]',...
        'Windtunnel Frequency','Temperature [C]','Humidity [%]',...
        'Differential Pressure [Pa for windtunnel OR in-Hg for vacuum chamber]'};
    num_lines = [1 47];
    defaultAns = {'50','blue','0','30','windtunnel','0','32.8','28','8.2'};
    options.WindowStyle='normal';
    expSettings = inputdlg(prompt,window_title,num_lines,defaultAns,options);
    
    % if user presses Cancel
    if isempty(expSettings)
        return
    end
    % assigns the numeric values entered by the user to appropriate variables
    
    temp.flexionRatio = str2num(expSettings{1});
    temp.shimColor = lower(expSettings{2});
    temp.pitchAngle = str2num(expSettings{3});
    temp.wingMass = str2num(expSettings{4});
    temp.expSetup = lower(expSettings{5});
    temp.tunnelFreq = str2num(expSettings{6});
    temp.roomTemp = str2num(expSettings{7});
    temp.relHumidity = str2num(expSettings{8});
    temp.pressDiff = str2num(expSettings{9});
    
    % condition to check if all inputs are numerical and
    % the color of shimstock match with database
    % if inputs are non-numerical, then the input window is redisplayed
    if strcmp(temp.expSetup,'windtunnel')==1 | strcmp(temp.expSetup,'vacuumchamber')==1
        if strcmp(temp.shimColor,'none')==1 | strcmp(temp.shimColor,'silver')==1 |...
                strcmp(temp.shimColor,'gold')==1 | strcmp(temp.shimColor,'amber')==1 |...
                strcmp(temp.shimColor,'purple')==1 | strcmp(temp.shimColor,'red')==1 |...
                strcmp(temp.shimColor,'green')==1 | strcmp(temp.shimColor,'tan')==1 |...
                strcmp(temp.shimColor,'blue')==1 | strcmp(temp.shimColor,'transmatte')==1 |...
                strcmp(temp.shimColor,'brown')==1 | strcmp(temp.shimColor,'black')==1 |...
                strcmp(temp.shimColor,'pink')==1 | strcmp(temp.shimColor,'yellow')==1 |...
                strcmp(temp.shimColor,'white')==1 | strcmp(temp.shimColor,'coral')==1
            % condition to check if all inputs are numerical
            % if inputs are non-numerical, then the input window is redisplayed
            if size(temp.flexionRatio) == 0 | size(temp.pitchAngle) == 0 |...
                    size(temp.tunnelFreq) == 0 | size(temp.roomTemp) == 0 |...
                    size(temp.relHumidity) == 0 | size(temp.pressDiff) == 0 |...
                    size(temp.wingMass) == 0
                continue
            end
        else
            continue
        end
    else
        continue
    end
    testSettings=0;
end
%% Check if sensors are tared or not
try
    windTare=evalin('base','windTare');
    temp.zeroWindTareData = windTare.zeroWindTareData;
catch
    uiwait(warndlg({'Sensors are not tared.'...
        'Please tare sensors first and try again.'},'Warning!!!'));
    return
end
try
    windTare=evalin('base','windTare');
    temp.onWindTareData = windTare.onWindTareData;
    temp.windLoadTareData = windTare.windLoadTareData;
    temp.aeroLoadTaring=1;
catch
    % Dialog box asking about AeroLoad Tare vs General Tare
    taringMethod = questdlg({'Aero Load Taring was not performed.',...
        'Do you want to proceed with general taring?'},...
        'Experiment Completed!', ...
        'Yes! General Taring it is!','Exit and Perform Aero Load Taring!',...
        'Exit and Perform Aero Load Taring!');
    % if user presses Cancel
    if isempty(taringMethod)
        return
    end
    if strcmp(taringMethod,'Yes! General Taring it is!')==1
        temp.aeroLoadTaring=0;
    elseif strcmp(taringMethod,'Exit and Perform Aero Load Taring!')==1
        return
    end
end
%% INPUT for experiment control
motionControl=1;
while motionControl==1
    window_title = 'Experimental Parameters';
    prompt = {'Trial Number','Starting Frequency [Hz]',...
        'Frequency Increment [Hz]','Ending Frequency [Hz]',...
        'Ideal Peak-to-Peak Amplitude [deg]',...
        'Ramp Up/Down (minimum 5)','Offset Angle [deg]'};
    num_lines = [1 47];
    defaultAns = {'1','0','0.25','4.75','40','10','0'};
    options.WindowStyle='normal';
    expSettings = inputdlg(prompt,window_title,num_lines,defaultAns,options);
    % if user presses Cancel
    if isempty(expSettings)
        return
    end
    % assigns the numeric values entered by the user to appropriate variables
    numTrials = str2num(expSettings{1});
    begFreq = str2num(expSettings{2});
    deltaFreq = str2num(expSettings{3});
    endFreq = str2num(expSettings{4});
    temp.idealAmp = str2num(expSettings{5});
    temp.ramp = str2num(expSettings{6});
    temp.offsetAngle = str2num(expSettings{7});
    % condition to check if all inputs are numerical and
    % the color of shimstock match with database
    % if inputs are non-numerical, then the input window is redisplayed
    if size(numTrials)== 0 | size(begFreq)== 0 | size(deltaFreq) == 0 |...
            size(endFreq) == 0 | size(temp.idealAmp) == 0 |...
            size(temp.ramp) == 0 | size(temp.offsetAngle) == 0
        continue
    end
    motionControl=0;
end
%% Folder Selection and Corrected Amplitude Map Container is loaded here
folderLocation=uigetdir; % gets the folder to save data in
%{
try
    % If you use this Method (Method II) for supplying Corrected Amplitude,
    % make sure to uncomment the Method II block inside the nested For Loop
    % and/or disable Method I if needed
    begFrequency=num2str(begFreq);
    endFrequency=num2str(endFreq);
    idealAmplitude=num2str(temp.idealAmp);
    flexRatio=num2str(temp.flexionRatio);
    fileName=strcat(folderLocation,'\','AmplitudeMap_',...
        begFrequency,'to',endFrequency,'Hz_',...
        idealAmplitude,'amp_',flexRatio,'flex_',...
        temp.shimColor,'Color','.mat');
    load(fileName);
    temp.ampMap=amplitudeMap.ampMap;
catch
end
%}
uiwait(warndlg('TURN COMPRESSED GAS ON AND HIT OK TO BEGIN','WARNING!!!','modal'));
%% Automated Wing flapping and Data Acquisition begins here
if strcmp(temp.expSetup,'windtunnel')==1
    begTrials=numTrials;
elseif strcmp(temp.expSetup,'vacuumchamber')==1
    begTrials=1;
end
for trialCntr=begTrials:numTrials
    for flapFrequency=begFreq:deltaFreq:endFreq
        %% Experiment Initializers
        temp.trial=trialCntr;
        temp.flapFrequency=flapFrequency;
        temp.correctedAmp=temp.idealAmp;
        temp.cycleNum = 20; % only 20 cycles to find corrected amplitude
        if temp.flapFrequency ~=0
            %% METHOD I: Active Corrected Amplitude Finder Procedure
            if temp.flapFrequency<4
                fprintf('\n Prelim data being acquired \n')
                tempSignal=experimentControl(temp);
                assignin('base','data',tempSignal);
                pushbtn_PhaseAvgCycles_Callback
                data=evalin('base','data');
                temp.correctedAmp=((1-data.realAmp/temp.idealAmp)*temp.idealAmp)+temp.idealAmp;
            else
                temp.correctedAmp=temp.idealAmp-5;
                fprintf('\n Prelim data being acquired \n ')
                tempSignal=experimentControl(temp);
                assignin('base','data',tempSignal);
                pushbtn_PhaseAvgCycles_Callback
                data=evalin('base','data');
                temp.tempCorrectedAmp=((1-(data.realAmp)/(temp.idealAmp-5))*(temp.idealAmp-5))+(temp.idealAmp-5);
                temp.correctedAmp=temp.tempCorrectedAmp*(data.idealAmp/(temp.idealAmp-5));
            end
            %}
            %% METHOD II: Find Corrected Amplitude from stored Function
            %{
            temp.correctedAmp=temp.ampMap(flapFrequency);
            %}
        end
        fprintf('\n Actual data being acquired \n')
        temp.cycleNum=100; % 100 cycles for actual run
        rawSignal=experimentControl(temp);
        %% MAT filename generation
        trial=num2str(rawSignal.trial);
        flapFreq=num2str(rawSignal.flapFrequency);
        idealAmp=num2str(rawSignal.idealAmp);
        pitchAngle=num2str(rawSignal.pitchAngle);
        flexRatio=num2str(rawSignal.flexionRatio);
        fileName=strcat(folderLocation,'\',trial,'trial_',...
            rawSignal.expSetup,'_rawSignal_',...
            flapFreq,'freq_',idealAmp,'amp_',...
            pitchAngle,'pitch_',flexRatio,'flex_',...
            rawSignal.shimColor,'Color','.mat');
        save(fileName,'rawSignal');
    end
end
uiwait(warndlg('TURN COMPRESSED GAS OFF','WARNING!!!','modal'));

% --- Executes on button press in pushbtn_LoadCurrentRawData.
function pushbtn_LoadCurrentRawData_Callback(hObject, eventdata, handles)
% assign all raw data to new variable called data
% that we will work on, and clear all other variables in workspace
clc
clear data
data=evalin('base','rawSignal');
% Call Signal Calibration functions to calibrate loaded raw signal
data=funcPrepStructuresForRawSigCalib(data);
assignin('base','data',data);

% --- Executes on button press in pushbtn_LoadRawDataFile.
function pushbtn_LoadRawDataFile_Callback(hObject, eventdata, handles)
clc
clear data
uiopen
% assign all raw data to new variable called data
% that we will work on
data=rawSignal;  % expData
% Call raw Calibration functions to calibrate loaded raw signal
data=funcPrepStructuresForRawSigCalib(data);
assignin('base','data',data);

% --- Executes on button press in pushbtn_Filter.
function pushbtn_Filter_Callback(hObject, eventdata, handles)
data=evalin('base','data');
nyquistFrequency=data.samplingRate/2;
data.filterOrder=5;
data.cutOffFreq=15;
data.cutOffWn=data.cutOffFreq/nyquistFrequency;
[bCoeff,aCoeff]=butter(data.filterOrder,data.cutOffWn,'low');

% if rawForce data exists then apply filter
if isfield(data,'rawForce')==1
    data.filtForce=filtfilt(bCoeff,aCoeff,data.rawForce);
else
    warndlg('Raw Force signal wasn''t found, so it''s not filtered.','Warning');
end

% if rawTorque data exists then apply filter
if isfield(data,'rawTorque')==1
    data.filtTorque=filtfilt(bCoeff,aCoeff,data.rawTorque);
else
    warndlg('Raw Torque signal wasn''t found, so it''s not filtered.','Warning');
end

assignin('base','data',data);

% --- Executes on button press in pushbtn_PhaseAvgCycles.
function pushbtn_PhaseAvgCycles_Callback(hObject, eventdata, handles)
data=evalin('base','data');
%% Shortcut method of applying filter to future SS Force data only
nyquistFrequency=data.samplingRate/2;
data.filterOrder=5;
data.cutOffFreq=15;
data.cutOffWn=data.cutOffFreq/nyquistFrequency;
[bCoeff,aCoeff]=butter(data.filterOrder,data.cutOffWn,'low');
data.filtForce=filtfilt(bCoeff,aCoeff,data.rawForce);
force=data.filtForce;
%% 
% force=data.rawForce;
torque=data.rawTorque;
[data,pozPerCycle,forcePerCycle,torquePerCycle]=...
    funcSteadyStateIsolator(data,force,torque);
data.rawPozPerCycle=pozPerCycle;
data.rawForcePerCycle=forcePerCycle;
data.rawTorquePerCycle=torquePerCycle;

%{
% if both Force & Torque data were filtered
if isfield(data,'filtForce')==1 && isfield(data,'filtTorque')==1
    force=data.filtForce;
    torque=data.filtTorque;
    [data,~,forcePerCycle,torquePerCycle]=...
        funcSteadyStateIsolator(data,force,torque);
    data.filtForcePerCycle=forcePerCycle;
    data.filtTorquePerCycle=torquePerCycle;
    % if only Force data were filtered
elseif isfield(data,'filtForce')==1 && isfield(data,'filtTorque')==0
    force=data.filtForce;
    torque=data.rawTorque;
    [data,~,forcePerCycle,torquePerCycle]=...
        funcSteadyStateIsolator(data,force,torque);
    data.filtForcePerCycle=forcePerCycle;
    data.filtTorquePerCycle=torquePerCycle;
    % if only Torque data were filtered
elseif isfield(data,'filtForce')==0 && isfield(data,'filtTorque')==1
    force=data.rawForce;
    torque=data.filtTorque;
    [data,~,forcePerCycle,torquePerCycle]=...
        funcSteadyStateIsolator(data,force,torque);
    data.filtForcePerCycle=forcePerCycle;
    data.filtTorquePerCycle=torquePerCycle;
elseif data.autoRun==0
    warndlg({'No filtered signal was found.',...
        'Steady state of filtered data not isolated.'},'Warning');
end
%}
%% Find Phase Average Position
[data.phaseAvgPosition,data.phaseAvgStdPosition] =...
    funcAvgStdCalculator(data.rawPozPerCycle);
[~,~,data.timeAvgOfPhzAvgPoz,data.timeAvgErrOfPhzAvgPoz]=...
    funcAvgStdCalculator(data.phaseAvgPosition);
data.avgSigLength=length(data.phaseAvgPosition);
data.cycleTime=(linspace(0,data.realPeriod,data.avgSigLength)).';

%% Find Phase Average Raw Force and Raw Torque
if isfield(data,'rawForcePerCycle')==1 && isfield(data,'rawTorquePerCycle')==1
    [data.phaseAvgRawForce,data.phaseAvgErrRawForce] =...
        funcAvgStdCalculator(data.rawForcePerCycle);
    [data.phaseAvgRawTorque,data.phaseAvgErrRawTorque] =...
        funcAvgStdCalculator(data.rawTorquePerCycle);
    
    [~,~,data.timeAvgOfPhzAvgRawForce,data.timeAvgErrOfPhzAvgRawForce]=...
        funcAvgStdCalculator(data.phaseAvgRawForce);
    [~,~,data.timeAvgOfPhzAvgRawTorque,data.timeAvgErrOfPhzAvgRawTorque]=...
        funcAvgStdCalculator(data.phaseAvgRawTorque);
end

%% Find Phase Average Filtered Force and Filtered Torque
%{
if isfield(data,'filtForcePerCycle')==1 || isfield(data,'filtTorquePerCycle')==1
    if isfield(data,'filtForcePerCycle')==1 && isfield(data,'filtTorquePerCycle')==1
        [data.phaseAvgFiltForce,data.phaseAvgErrFiltForce] =...
            funcAvgStdCalculator(data.filtForcePerCycle);
        [data.phaseAvgFiltTorque,data.phaseAvgErrFiltTorque] =...
            funcAvgStdCalculator(data.filtTorquePerCycle);
    elseif isfield(data,'filtForcePerCycle')==1 && isfield(data,'filtTorquePerCycle')==0
        [data.phaseAvgFiltForce,data.phaseAvgErrFiltForce] = ...
            funcAvgStdCalculator(data.filtForcePerCycle);
        [data.phaseAvgFiltTorque,data.phaseAvgErrFiltTorque] =...
            funcAvgStdCalculator(data.rawTorquePerCycle);
    elseif isfield(data,'filtForcePerCycle')==0 && isfield(data,'filtTorquePerCycle')==1
        [data.phaseAvgFiltForce,data.phaseAvgErrFiltForce] =...
            funcAvgStdCalculator(data.rawForcePerCycle);
        [data.phaseAvgFiltTorque,data.phaseAvgErrFiltTorque] =...
            funcAvgStdCalculator(data.filtTorquePerCycle);
    elseif data.autoRun==0
        warndlg('Filtered signal wasn''t found, so Phase Averaging not performed.','Warning');
    end
    [~,~,data.timeAvgOfPhzAvgFiltForce,data.timeAvgErrOfPhzAvgFiltForce]...
        =funcAvgStdCalculator(data.phaseAvgFiltForce);
    [~,~,data.timeAvgOfPhzAvgFiltTorque,data.timeAvgErrOfPhzAvgFiltTorque]...
        =funcAvgStdCalculator(data.phaseAvgFiltTorque);
end
%}
% Power Calculator
data=funcPowerCalculator(data);
assignin('base','data',data);

% --- Executes on button press in pushbtn_PerformanceMetrics.
function pushbtn_PerformanceMetrics_Callback(hObject, eventdata,handles)
data=evalin('base','data');
if data.flapFrequency==0 % Case: Static Wing under Aerodynamic load
    [data]=funcStaticWingPerformance(data);
end
[data]=funcShimProperties(data);
% Parameters Calculator
data.aspectRatio=data.wingSpan/data.chordLength;
data.airDynViscosity=1.846e-05; %(-4e-06*data.roomTemp^2+0.0073*data.roomTemp+0.0409)*10^(-05);
data.reynoldsNum=data.airDensity*data.airVelocity*data.chordLength/data.airDynViscosity;
data.wingBase2PeakLength = data.wingShaft + data.wingSpan/2; % Remove later
data.strouhalNum = data.flapFrequency*2*data.wingBase2PeakLength...
    *tand(data.idealAmp/2)/data.airVelocity;
data.reducedFreq=2*pi*data.flapFrequency*data.chordLength/round(data.airVelocity);
data.coeffPower= data.timeAvgOfPhzAvgRawPower/(0.5*data.airDensity...
    *data.airVelocity^3*data.chordLength*data.wingSpan);
data.coeffForce=data.timeAvgOfPhzAvgRawForce/(0.5*data.airDensity...
    *data.airVelocity^2*data.chordLength*data.wingSpan);
if strcmp(data.forceSetup,'lift')==1 | strcmp(data.forceSetup,'intertial')==1 |...
        strcmp(data.forceSetup,'force')==1
    %data.coeffLift=coeffForce;
    data.coeffLift=data.coeffForce;
elseif strcmp(data.forceSetup,'thrust')==1
    %data.coeffThrust=coeffForce;
    data.coeffThrust=data.coeffForce;
end
data.propEff = data.coeffForce/data.coeffPower;
assignin('base','data',data);

% --- Executes on button press in pushbtn_AllinOneAnalysis.
function pushbtn_AllinOneAnalysis_Callback(hObject, eventdata, handles)
% pushbtn_Filter_Callback
pushbtn_PhaseAvgCycles_Callback
pushbtn_PerformanceMetrics_Callback

% --- Executes on button press in pushbtn_AutomateProcessing.
function pushbtn_AutomateProcessing_Callback(hObject, eventdata, handles)
%% Load Multiple Data sets and process them
clearvars
clc
%% Parameters to load files
wingSettingCount=0;
loadFolder=1;
while loadFolder==1
    wingSettingCount=wingSettingCount+1;
    expTypeCount=1;
    fileLoad=1;
    while fileLoad==1
        window_title = 'Test Settings';
        prompt = {'Number of trials for each setting'...
            'Starting Frequency [Hz]','Ending Frequency [Hz]','Frequency Increment [Hz]'...
            'Peak-to-Peak Amplitude [deg]','Pitch Angle [deg]','Flexion Ratio',...
            'Shim Color'};
        num_lines = [1 47];
        defaultAns = {'2','0.5','4.5','2','40','0','33','black'};
        options.WindowStyle='normal';
        expSettings = inputdlg(prompt,window_title,num_lines,defaultAns,options);
        % if user presses Cancel
        if isempty(expSettings)
            return
        end
        % assigns the numeric values entered by the user to appropriate variables
        numTrials = str2num(expSettings{1});
        begFreq = str2num(expSettings{2});
        endFreq = str2num(expSettings{3});
        deltaFreq = str2num(expSettings{4});
        amplitude = str2num(expSettings{5});
        pitchAngle = str2num(expSettings{6});
        flexion = str2num(expSettings{7});
        shimColor = lower(expSettings{8});
        
        % condition to check if all inputs are numerical and
        % the color of shimstock match with database
        % if inputs are non-numerical, then the input window is redisplayed
        if strcmp(shimColor,'none')==1 | strcmp(shimColor,'coral')==1 |...
                strcmp(shimColor,'white')==1 | strcmp(shimColor,'yellow')==1 |...
                strcmp(shimColor,'pink')==1 | strcmp(shimColor,'black')==1 |...
                strcmp(shimColor,'brown')==1 | strcmp(shimColor,'transmatte')==1 |...
                strcmp(shimColor,'blue')==1 | strcmp(shimColor,'tan')==1 |...
                strcmp(shimColor,'green')==1 | strcmp(shimColor,'red')==1 |...
                strcmp(shimColor,'purple')==1 | strcmp(shimColor,'silver')==1 |...
                strcmp(shimColor,'tan')==1 | strcmp(shimColor,'amber')==1
            % condition to check if all inputs are numerical
            % if inputs are non-numerical, then the input window is redisplayed
            if size(numTrials) == 0 | size(begFreq)== 0 | size(endFreq) == 0 |...
                    size(deltaFreq) == 0 | size(amplitude) == 0 |...
                    size(pitchAngle) == 0 | size(flexion) == 0
                continue
            end
        else
            continue
        end
        fileLoad=0;
    end
    pitch=num2str(pitchAngle);
    amp=num2str(amplitude);
    flex=num2str(flexion);
    %% Bundle Processing (Air vs Vacuum vs Both) Method Selection Selection
    expSetupProcessing=0;
    while expSetupProcessing==0
        %% Dialog box to process another folder of data
        dataProcessingMethod = questdlg('How would you like to process the experiment data?',...
            'Bundle Processing Method','Windtunnel Data Only!','Vacuumchamber Data Only!','Windtunnel - Vacuumchamber','Windtunnel Data Only!');
        if strcmp(dataProcessingMethod,'Windtunnel Data Only!')==1
            expSetupProcessing=1;
        elseif strcmp(dataProcessingMethod,'Vacuumchamber Data Only!')==1
            expSetupProcessing=2;
        elseif strcmp(dataProcessingMethod,'Windtunnel - Vacuumchamber')==1
            expSetupProcessing=3;
        else
            return
        end
    end
    if expSetupProcessing==1
        uiwait(warndlg('Load Windtunnel files directory',...
            'Warning!!!'));
        expSetup='windtunnel';
    elseif expSetupProcessing==2
        uiwait(warndlg('Load Vacuumchamber files directory',...
            'Warning!!!'));
        expSetup='vacuumchamber';
    elseif expSetupProcessing==3
        expSetup='windtunnel';
        uiwait(warndlg('First Load Windtunnel files directory',...
            'Warning!!!'));
    end
    resultMatrixCntr=1;
    while resultMatrixCntr==1
        %% Main action happens here
        folderLocation=uigetdir;
        settingCount=0; % keeps track of number of settings for experiment
        for freq=begFreq:deltaFreq:endFreq; % this is where files are extracted
            settingCount=settingCount+1;
            trialCount=0;   % keeps track of number of trials
            for trial=1:1:numTrials
                trialCount=trialCount+1;
                %% Load Files by generating filenames
                trialSTR=num2str(trial);
                freqSTR=num2str(freq);
                fileName=strcat(folderLocation,'\',trialSTR,'trial_',expSetup,'_rawSignal_',freqSTR,'freq_',...
                    amp,'amp_',pitch,'pitch_',flex,'flex_',shimColor,'Color','.MAT');
                load(fileName);
                data=rawSignal; % In some tests, structured is named "raw"
                % Call raw Calibration Functions to calibrate loaded raw signal
                data=funcPrepStructuresForRawSigCalib(data);
                assignin('base','data',data);
                %% Call modules to perform analysis here
                % here these pushbutton functions are called to do what we
                % would otherwise do individually
                if data.flapFrequency~=0
                    pushbtn_PhaseAvgCycles_Callback()
                end
                pushbtn_PerformanceMetrics_Callback()
                %% Save files by generating filenames
                %{
                data=evalin('base','data');
                data.dateOfSigProcess=datestr(now,'dd-mmm-yyyy');
                data.timeOfSigProcess=datestr(now,'HH:MM:SS PM');
                % MAT filename generation
                fileName=strcat(folderLocation,'\',trialSTR,'trial_',expSetup,'_data_',freqSTR,'freq_',...
                    amp,'amp_',pitch,'pitch_',flex,'flex_',shimColor,'Color','.MAT');
                save(fileName,'data');
                assignin('base','data',data);
                %}
                %% Store important parameters from multiple/all trials and all settings
                % so it can be analyzed upon post processing
                data=evalin('base','data');
                if data.flapFrequency~=0
                    results.perErrAmp(trialCount,settingCount,wingSettingCount,expTypeCount)=data.perErrAmp;
                    results.perErrFreq(trialCount,settingCount,wingSettingCount,expTypeCount)=data.perErrFreq;
                else
                    results.perErrAmp(trialCount,settingCount,wingSettingCount,expTypeCount)=0;
                    results.perErrFreq(trialCount,settingCount,wingSettingCount,expTypeCount)=0;
                end
                results.shimColor(trialCount,settingCount,wingSettingCount,expTypeCount)=cellstr(data.shimColor);
                results.flexionRatio(trialCount,settingCount,wingSettingCount,expTypeCount)=data.flexionRatio;
                results.wingSpan(trialCount,settingCount,wingSettingCount,expTypeCount)=data.wingSpan;
                results.chordLength(trialCount,settingCount,wingSettingCount,expTypeCount)=data.chordLength;
                results.frequency(trialCount,settingCount,wingSettingCount,expTypeCount)=data.flapFrequency;
                results.reducedFreq(trialCount,settingCount,wingSettingCount,expTypeCount)=data.reducedFreq;
                results.airDensity(trialCount,settingCount,wingSettingCount,expTypeCount)=data.airDensity;
                results.airVelocity(trialCount,settingCount,wingSettingCount,expTypeCount)=data.airVelocity;
                results.reynoldsNum(trialCount,settingCount,wingSettingCount,expTypeCount)=data.reynoldsNum;
                results.strouhalNum(trialCount,settingCount,wingSettingCount,expTypeCount)=data.strouhalNum;
                [~,peakTorqueIndex]=max(abs(data.phaseAvgRawTorque));
                results.peakTorque(trialCount,settingCount,wingSettingCount,expTypeCount)=abs(data.phaseAvgRawTorque(peakTorqueIndex));
                results.timeAvgOfPhzAvgRawForce(trialCount,settingCount,wingSettingCount,expTypeCount)=data.timeAvgOfPhzAvgRawForce;
                results.timeAvgOfPhzAvgRawPower(trialCount,settingCount,wingSettingCount,expTypeCount)=data.timeAvgOfPhzAvgRawPower;
                clear processedData raw rawSignal
            end
        end
        %     currentShimColor=results.shimColor(trialCount,settingCount,expCount);
        %     currentFlexionRatio=results.flexionRatio(trialCount,settingCount,expCount);
        if expSetupProcessing==3 && expTypeCount<2
            expSetup='vacuumchamber';
            expTypeCount=2;
            uiwait(warndlg('Now, Load vacuumchamber files directory',...
                'Warning!!!'));
        else
            resultMatrixCntr=0;
        end
    end
    %% Dialog box to process another folder of data
    fileSaveChoice = questdlg('Would you like to process another Wing data set?',...
        'Bundle Data Processing Complete!','YES','NO','YES');
    if strcmp(fileSaveChoice,'YES')==1
        loadFolder=1;
    else
        loadFolder=0;
    end
end
assignin('base','results',results);
[xDim,~,zDim,dim4th]=size(results.frequency); %zDim gives the # of different set of wings
% dim4th = 1 means EITHER vacuumchamber or windtunnel data but NOT BOTH
% dim4th = 2 means both vacuumchamber and windtunnel data, hence later Net is calculated
meanCntr=0;
for wingSettingCntr=1:zDim
    for dim4thCntr=1:dim4th
        meanCntr=meanCntr+1;
        meanResults.perErrAmp(meanCntr,:)=mean(results.perErrAmp(:,:,wingSettingCntr,dim4thCntr));
        meanResults.perErrFreq(meanCntr,:)=mean(results.perErrFreq(:,:,wingSettingCntr,dim4thCntr));
        meanResults.shimColor(meanCntr,:)=results.shimColor(1,1,wingSettingCntr,dim4thCntr);
        meanResults.flexionRatio(meanCntr,:)=mean(results.flexionRatio(:,:,wingSettingCntr,dim4thCntr));
        meanResults.chordLength(meanCntr,:)=mean(results.chordLength(:,:,wingSettingCntr,dim4thCntr));
        meanResults.wingSpan(meanCntr,:)=mean(results.wingSpan(:,:,wingSettingCntr,dim4thCntr));
        meanResults.frequency(meanCntr,:)=mean(results.frequency(:,:,wingSettingCntr,dim4thCntr));
        meanResults.reducedFreq(meanCntr,:)=mean(results.reducedFreq(:,:,wingSettingCntr,dim4thCntr));
        meanResults.reynoldsNum(meanCntr,:)=mean(results.reynoldsNum(:,:,wingSettingCntr,dim4thCntr));
        meanResults.strouhalNum(meanCntr,:)=mean(results.strouhalNum(:,:,wingSettingCntr,dim4thCntr));
        meanResults.errStrouhalNum(meanCntr,:)=std(results.strouhalNum(:,:,wingSettingCntr,dim4thCntr))/sqrt(xDim);
        meanResults.airVelocity(meanCntr,:)=mean(results.airVelocity(:,:,wingSettingCntr,dim4thCntr));
        meanResults.errAirVelocity(meanCntr,:)=std(results.airVelocity(:,:,wingSettingCntr,dim4thCntr))/sqrt(xDim);
        meanResults.airDensity(meanCntr,:)=mean(results.airDensity(:,:,wingSettingCntr,dim4thCntr));
        meanResults.errAirDensity(meanCntr,:)=std(results.airDensity(:,:,wingSettingCntr,dim4thCntr))/sqrt(xDim);
        meanResults.peakTorque(meanCntr,:)=mean(results.peakTorque(:,:,wingSettingCntr,dim4thCntr));
        meanResults.errPeakTorque(meanCntr,:)=std(results.peakTorque(:,:,wingSettingCntr,dim4thCntr))/sqrt(xDim);
        meanResults.timeAvgOfPhzAvgRawForce(meanCntr,:)=mean(results.timeAvgOfPhzAvgRawForce(:,:,wingSettingCntr,dim4thCntr));
        meanResults.errTimeAvgOfPhzAvgRawForce(meanCntr,:)=std(results.timeAvgOfPhzAvgRawForce(:,:,wingSettingCntr,dim4thCntr))/sqrt(xDim);
        meanResults.timeAvgOfPhzAvgRawPower(meanCntr,:)=mean(results.timeAvgOfPhzAvgRawPower(:,:,wingSettingCntr,dim4thCntr));
        meanResults.errTimeAvgOfPhzAvgRawPower(meanCntr,:)=std(results.timeAvgOfPhzAvgRawPower(:,:,wingSettingCntr,dim4thCntr))/sqrt(xDim);
        meanResults.coeffForce(meanCntr,:)=(meanResults.timeAvgOfPhzAvgRawForce(meanCntr,:))./...
            (0.5.*meanResults.airDensity(meanCntr,:).*(meanResults.airVelocity(meanCntr,:)).^2.*...
            meanResults.chordLength(meanCntr,:).*meanResults.wingSpan(meanCntr,:));
        if dim4thCntr==1
            airVelocity=meanResults.airVelocity(meanCntr,:);
        elseif dim4thCntr==2
            airVelocity=meanResults.airVelocity(meanCntr-1,:);
        end
        meanResults.coeffPower(meanCntr,:)=(meanResults.timeAvgOfPhzAvgRawPower(meanCntr,:))./...
            (0.5.*meanResults.airDensity(meanCntr,:).*airVelocity.^3.*...
            meanResults.chordLength(meanCntr,:).*meanResults.wingSpan(meanCntr,:));
        meanResults.propEff(meanCntr,:)=(meanResults.coeffForce(meanCntr,:))./...
            (meanResults.coeffPower(meanCntr,:));
        % Propagated Error
        singleRowProcessing=dim4thCntr; % singleRowProcessing=1 if it has its own windtunnel data
        meanResults.errCoeffForce(meanCntr,:)=funcSimplePropErr(1,meanResults,meanCntr,1,singleRowProcessing);
        meanResults.errCoeffPower(meanCntr,:)=funcSimplePropErr(2,meanResults,meanCntr,1,singleRowProcessing);
        meanResults.errPropEff(meanCntr,:)=funcSimplePropErr(3,meanResults,meanCntr,1,singleRowProcessing);
    end
    if dim4th==2 % If following the Wind-Vacuum data procedure and dim4th=2
        % This section calculates only NET values of Wind-Vacuum Data
        % therefore, numbered accordingly
        netCntr=meanCntr/2;
        meanResults.netTimeAvgOfPhzAvgRawPower(netCntr,:)=meanResults.timeAvgOfPhzAvgRawPower(meanCntr-1,:)-...
            meanResults.timeAvgOfPhzAvgRawPower(meanCntr,:);
        meanResults.errNetTimeAvgOfPhzAvgRawPower(netCntr,:)=sqrt((meanResults.errTimeAvgOfPhzAvgRawPower(meanCntr-1,:)).^2+...
            (meanResults.errTimeAvgOfPhzAvgRawPower(meanCntr,:)).^2);
        meanResults.netCoeffPower(netCntr,:)=meanResults.netTimeAvgOfPhzAvgRawPower(netCntr,:)./...
            (0.5.*meanResults.airDensity(meanCntr-1,:).*meanResults.airVelocity(meanCntr-1,:).^3.*...
            meanResults.chordLength(meanCntr,:).*meanResults.wingSpan(meanCntr,:));
        meanResults.netPropEff(netCntr,:)=meanResults.coeffForce(meanCntr-1,:)./...
            meanResults.netCoeffPower(netCntr,:);
        % Propagated Error
        meanResults.errNetCoeffPower(netCntr,:)=funcSimplePropErr(2,meanResults,meanCntr,dim4th,singleRowProcessing);
        meanResults.errNetPropEff(netCntr,:)=funcSimplePropErr(3,meanResults,meanCntr,dim4th,singleRowProcessing);
    end
end
assignin('base','meanResults',meanResults);
%% Plot of Air Velocity vs. Reduced Frequency
%{
figure()
errorbar(meanResults.reducedFreq,meanResults.meanAirVel,meanResults.errAirVel);
xlabel('Reduced Frequency');
ylabel('Air Velocity (m/s)');
title('Air Velocity vs. Reduced Frequency');
grid on
figure()
errorbar(meanResults.reducedFreq,meanResults.meanCoeffThrust,meanResults.errCoeffThrust);
xlabel('Reduced Frequency');
ylabel('Coeff of Thrust');
title('Coeff of Thrust vs. Reduced Frequency');
grid on
figure()
errorbar(meanResults.strouhalNum,meanResults.meanCoeffThrust,meanResults.errCoeffThrust);
xlabel('Strouhal Number');
ylabel('Coeff of Thrust');
title('Coeff of Thrust vs. Strouhal Number');
grid on
figure()
errorbar(meanResults.reducedFreq,meanResults.coeffPower,meanResults.errCoeffPower);
xlabel('Reduced Frequency');
ylabel('Coeff of Power');
title('Coeff of Power vs. Reduced Frequency');
grid on
figure()
errorbar(meanResults.strouhalNum,meanResults.coeffPower,meanResults.errCoeffPower);
xlabel('Strouhal Number');
ylabel('Coeff of Power');
title('Coeff of Power vs. Strouhal Number');
grid on
figure()
errorbar(meanResults.reducedFreq,meanResults.propEff,meanResults.errCoeffThrust);
xlabel('Reduced Frequency');
ylabel('Prop Efficiency');
title('Prop Efficiency vs. Reduced Frequency');
grid on
figure()
errorbar(meanResults.strouhalNum,meanResults.propEff,meanResults.errCoeffThrust);
xlabel('Strouhal Number');
ylabel('Prop Efficiency');
title('Prop Efficiency vs. Strouhal Number');
grid on
%}
% Post Processing Graphs Function End Begins Here
%}
uiwait(warndlg('Bundle Analysis Successfully Completed!','Program Completion!!!'));

% --- Executes on button press in pushbtn_ListCurrentData.
function pushbtn_ListCurrentData_Callback(hObject, eventdata, handles)
clc
pushbtn_AllinOneAnalysis_Callback;
data=evalin('base','data')

% --- Executes on button press in pushbtn_SaveProcessedData.
function pushbtn_SaveProcessedData_Callback(hObject, eventdata, handles)
%% presaving evaluations
data=evalin('base','data');
data.dateOfSigProcess=datestr(now,'dd-mmm-yyyy');
data.timeOfSigProcess=datestr(now,'HH:MM:SS PM');
%% MAT filename generation
freq=num2str(data.flapFrequency);
amp=num2str(data.idealAmp);
pitch=num2str(data.pitchAngle);
flex=num2str(data.flexionRatio);
expSetup=num2str(data.expSetup);
shimColor=num2str(data.shimColor);
fileName=strcat('trial_',expSetup,'_data_',freq,'freq_',...
    amp,'amp_',pitch,'pitch_',flex,'flex_',shimColor,'Color','.MAT');
uisave('data',fileName);

assignin('base','data',data);

% --- Executes on button press in pushbutton_ClearMemory.
function pushbutton_ClearMemory_Callback(hObject, eventdata, handles)
% clears all variable from the base workspace
evalin('base','clear all');
clc

% --- Executes on button press in pushbtn_DataGrapher.
function pushbtn_DataGrapher_Callback(hObject, eventdata, handles)
handles=guidata(hObject);
data=evalin('base','data');
%% Non-FFT Graphing
rawPositionState=get(handles.chkbox_Grph_RawPosition,'Value');
rawForceState=get(handles.chkbox_Grph_RawForce,'Value');
rawTorqueState=get(handles.chkbox_Grph_RawTorque,'Value');
rawPressureState=get(handles.chkbox_Grph_RawPressure,'Value');
filtForceState=get(handles.chkbox_Grph_FiltForce,'Value');
filtTorqueState=get(handles.chkbox_Grph_FiltTorque,'Value');
phzAvgPositionState=get(handles.chkbox_Grph_PhzAvgPosition,'Value');
phzAvgAngularVelState=get(handles.chkbox_Grph_PhzAvgAngularVel,'Value');
phzAvgForceState=get(handles.chkbox_Grph_PhzAvgRawForce,'Value');
phzAvgFiltForceState=get(handles.chkbox_Grph_PhzAvgFiltForce,'Value');
phzAvgTorqueState=get(handles.chkbox_Grph_PhzAvgRawTorque,'Value');
phzAvgFiltTorqueState=get(handles.chkbox_Grph_PhzAvgFiltTorque,'Value');
phzAvgPowerState=get(handles.chkbox_Grph_PhzAvgRawPower,'Value');
phzAvgFiltPowerState=get(handles.chkbox_Grph_PhzAvgFiltPower,'Value');

%% Full raw Graphs
if rawPositionState==1
    if isfield(data,'rawPosition')==1
        figure()
        plot(data.runTime,data.rawPosition);
        grid on
        xlim('auto');
        xlabel('Time [s]');
        ylabel('Angular position [deg.]');
        title('Raw Angular position [deg.] vs Time [s]');
    else
        warndlg('No Raw Position signal was found, so it''s not plotted.','Warning');
    end
end

if rawPressureState==1
    if isfield(data,'rawPressure')==1
        figure()
        plot(data.runTime,data.rawPressure);
        xlim('auto');
        xlabel('Time [s]');
        ylabel('Pressure [Pa]');
        ylim([-2 5])
        title('Raw Pressure [Pa] vs Time [s]');
    else
        warndlg('No Raw Pressure signal was found, so it''s not plotted.','Warning');
    end
end

if rawForceState==1
    if isfield(data,'rawForce')==1
        figure()
        forceGageLimit(1:length(data.runTime),1)=9;
        plot(data.runTime,-forceGageLimit,'r-');
        hold on
        plot(data.runTime,forceGageLimit,'r-');
        hold on
        plot(data.runTime,data.rawForce);
        xlim('auto');
        xlabel('Time [s]');
        ylabel('Force [N]');
        title('Raw Force [N] vs Time [s]');
    else
        warndlg('No Raw Force signal was found, so it''s not plotted.','Warning');
    end
end

if filtForceState==1
    if isfield(data,'filtForce')==1
        figure()
        forceGageLimit(1:length(data.runTime),1)=9;
        plot(data.runTime,-forceGageLimit,'r-');
        hold on
        plot(data.runTime,forceGageLimit,'r-');
        hold on
        plot(data.runTime,data.filtForce);
        xlim('auto');
        xlabel('Time [s]');
        ylabel('Filtered Force [N]');
        title('Filtered Force [N] vs Time [s]');
    else
        warndlg('No Filtered Force signal was found, so it''s not plotted.','Warning');
    end
end

if rawTorqueState==1
    if isfield(data,'rawTorque')==1
        figure()
        torqueGageLimit(1:length(data.runTime),1)=5.6;
        plot(data.runTime,-torqueGageLimit,'r-');
        hold on
        plot(data.runTime,torqueGageLimit,'r-');
        hold on
        plot(data.runTime,data.rawTorque);
        xlim('auto');
        xlabel('Time [s]');
        ylabel('Torque [N.m]');
        title('Raw Torque [N.m] vs Time [s]');
    else
        warndlg('No Raw Torque signal was found, so it''s not plotted.','Warning');
    end
end

if filtTorqueState==1
    if isfield(data,'filtTorque')==1
        figure()
        torqueGageLimit(1:length(data.runTime),1)=5.6;
        plot(data.runTime,-torqueGageLimit,'r-');
        hold on
        plot(data.runTime,torqueGageLimit,'r-');
        hold on
        plot(data.runTime,data.filtTorque);
        xlim('auto');
        xlabel('Time [s]');
        ylabel('Filtered Torque [N.m]');
        title('Filtered Torque [N.m] vs Time [s]');
    else
        warndlg('No Filtered Torque signal was found, so it''s not plotted.','Warning');
    end
end

%% Phase Average Graphs
if phzAvgPositionState==1
    if isfield(data,'phaseAvgPosition')==1
        figure()
        normalizedCycleTime=data.cycleTime/data.realPeriod;
        plot(normalizedCycleTime,data.phaseAvgPosition,'r')
        hold on
        plot(normalizedCycleTime,data.phaseAvgPosition-data.phaseAvgStdPosition,'Linewidth',1,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot(normalizedCycleTime,data.phaseAvgPosition+data.phaseAvgStdPosition,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot([0 1],[data.timeAvgOfPhzAvgPoz data.timeAvgOfPhzAvgPoz],'g');
        xlim([0 1])
        grid on
        title('Phase Average Position')
        xlabel('Phase Average Cycle'),ylabel('Position [deg]')
        legend('Phase Average Position','Phase Avg. Position +/- Std Error');
    else
        warndlg('No Phase Averaged Raw Position signal was found, so it''s not plotted.','Warning');
    end
end

if phzAvgAngularVelState==1
    if isfield(data,'phaseAvgAngularVel')==1
        figure()
        normalizedCycleTime=data.cycleTime/data.realPeriod;
        plot(normalizedCycleTime,data.phaseAvgAngularVel,'r')
        hold on
        plot(normalizedCycleTime,data.phaseAvgAngularVel-data.phaseAvgStdErrAngularVel,'Linewidth',1,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot(normalizedCycleTime,data.phaseAvgAngularVel+data.phaseAvgStdErrAngularVel,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot([0 1],[data.timeAvgOfPhzAvgAngularVel data.timeAvgOfPhzAvgAngularVel],'g');
        xlim([0 1])
        title('Phase Average Angular Velocity')
        xlabel('Phase Average Cycle'),ylabel('Angular Velocity [rad/s]')
        legend('Phase Average Angular Velocity','Phase Avg. Angular Velocity +/- Std Error');
    else
        warndlg('No Phase Averaged Raw Angular Velocity signal was found, so it''s not plotted.','Warning');
    end
end


if phzAvgForceState==1
    if isfield(data,'phaseAvgRawForce')==1
        figure()
        normalizedCycleTime=data.cycleTime/data.realPeriod;
        plot(normalizedCycleTime,data.phaseAvgRawForce,'r')
        hold on
        plot(normalizedCycleTime,data.phaseAvgRawForce-data.phaseAvgErrRawForce,'Linewidth',1,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot(normalizedCycleTime,data.phaseAvgRawForce+data.phaseAvgErrRawForce,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot([0 1],[data.timeAvgOfPhzAvgRawForce data.timeAvgOfPhzAvgRawForce],'g');
        xlim([0 1])
        title('Phase Average Raw Force')
        xlabel('Phase Average Cycle'),ylabel('Force [N]')
        legend('Phase Average Raw Force','Phase Avg. Raw Force +/- Std Error');
    else
        warndlg('No Phase Averaged Raw Force signal was found, so it''s not plotted.','Warning');
    end
end

if phzAvgTorqueState==1
    if isfield(data,'phaseAvgRawTorque')==1
        figure()
        normalizedCycleTime=data.cycleTime/data.realPeriod;
        plot(normalizedCycleTime,data.phaseAvgRawTorque,'r')
        hold on
        plot(normalizedCycleTime,data.phaseAvgRawTorque-data.phaseAvgErrRawTorque,'Linewidth',1,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot(normalizedCycleTime,data.phaseAvgRawTorque+data.phaseAvgErrRawTorque,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot([0 1],[data.timeAvgOfPhzAvgRawTorque data.timeAvgOfPhzAvgRawTorque],'g');
        xlim([0 1])
        title('Phase Average Raw Torque')
        xlabel('Phase Average Cycle'),ylabel('Torque [N.m]')
        legend('Phase Average Raw Torque','Phase Avg. Raw Torque +/- Std Error');
    else
        warndlg('No Phase Averaged Raw Torque signal was found, so it''s not plotted.','Warning');
    end
end

if phzAvgPowerState==1
    if isfield(data,'phaseAvgRawPower')==1
        figure()
        normalizedCycleTime=data.cycleTime/data.realPeriod;
        plot(normalizedCycleTime,data.phaseAvgRawPower,'r')
        hold on
        plot(normalizedCycleTime,data.phaseAvgRawPower-data.phaseAvgStdErrRawPower,'Linewidth',1,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot(normalizedCycleTime,data.phaseAvgRawPower+data.phaseAvgStdErrRawPower,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot([0 1],[data.timeAvgOfPhzAvgRawPower data.timeAvgOfPhzAvgRawPower],'g');
        xlim([0 1])
        title('Phase Average Raw Power')
        xlabel('Phase Average Cycle'),ylabel('Power [W]')
        legend('Phase Average Raw Power','Phase Avg. Raw Power +/- Std Error');
    else
        warndlg('No Phase Averaged Raw Power signal was found, so it''s not plotted.','Warning');
    end
end

if phzAvgFiltForceState==1
    if isfield(data,'phaseAvgFiltForce')==1
        figure()
        normalizedCycleTime=data.cycleTime/data.realPeriod;
        plot(normalizedCycleTime,data.phaseAvgFiltForce,'r')
        hold on
        plot(normalizedCycleTime,data.phaseAvgFiltForce-data.phaseAvgErrFiltForce,'Linewidth',1,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot(normalizedCycleTime,data.phaseAvgFiltForce+data.phaseAvgErrFiltForce,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot([0 1],[data.timeAvgOfPhzAvgFiltForce data.timeAvgOfPhzAvgFiltForce],'g');
        xlim([0 1])
        title('Phase Average Filtered Force')
        xlabel('Phase Average Cycle'),ylabel('Force [N]')
        legend('Phase Average Filtered Force','Phase Avg. Filtered Force +/- Std Error');
    else
        warndlg('No Phase Averaged Filtered Force signal was found, so it''s not plotted.','Warning');
    end
end

if phzAvgFiltTorqueState==1
    if isfield(data,'phaseAvgFiltTorque')==1
        figure()
        normalizedCycleTime=data.cycleTime/data.realPeriod;
        plot(normalizedCycleTime,data.phaseAvgFiltTorque,'r')
        hold on
        plot(normalizedCycleTime,data.phaseAvgFiltTorque-data.phaseAvgErrFiltTorque,'Linewidth',1,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot(normalizedCycleTime,data.phaseAvgFiltTorque+data.phaseAvgErrFiltTorque,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot([0 1],[data.timeAvgOfPhzAvgFiltTorque data.timeAvgOfPhzAvgFiltTorque],'g');
        xlim([0 1])
        title('Phase Average Filtered Torque')
        xlabel('Phase Average Cycle'),ylabel('Torque [N.m]')
        legend('Phase Average Filtered Torque','Phase Avg. Filtered Torque +/- Std Error');
    else
        warndlg('No Phase Averaged Filtered Torque signal was found, so it''s not plotted.','Warning');
    end
end

if phzAvgFiltPowerState==1
    if isfield(data,'phaseAvgFiltPower')==1
        figure()
        normalizedCycleTime=data.cycleTime/data.realPeriod;
        plot(normalizedCycleTime,data.phaseAvgFiltPower,'r')
        hold on
        plot(normalizedCycleTime,data.phaseAvgFiltPower-data.phaseAvgStdErrFiltPower,'Linewidth',1,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot(normalizedCycleTime,data.phaseAvgFiltPower+data.phaseAvgStdErrFiltPower,'LineStyle',':','color',[0.5 0.5 0.5])
        hold on
        plot([0 1],[data.timeAvgOfPhzAvgFiltPower data.timeAvgOfPhzAvgFiltPower],'g');
        xlim([0 1])
        title('Phase Average Filtered Power')
        xlabel('Phase Average Cycle'),ylabel('Power [W]')
        legend('Phase Average Filtered Power','Phase Avg. Filtered Power +/- Std Error');
    else
        warndlg('No Phase Averaged Filtered Power signal was found, so it''s not plotted.','Warning');
    end
end

%% FFT Graphing
rawForceState=get(handles.chkbox_FFT_RawForce,'Value');
filtForceState=get(handles.chkbox_FFT_FiltForce,'Value');
rawTorqueState=get(handles.chkbox_FFT_RawTorque,'Value');
filtTorqueState=get(handles.chkbox_FFT_FiltTorque,'Value');

if rawForceState == 1
    figure()
    if isfield(data,'rawForce')==1
        rawForceLength=length(data.rawForce);
        rawNFFT = 2^nextpow2(rawForceLength); % Next power of 2 from length of y
        rawFreq = 1000/2*linspace(0,1,rawNFFT/2+1);
        rawForceMag = fft(data.rawForce,rawNFFT)/rawForceLength;
        plot(rawFreq,2*abs(rawForceMag(1:rawNFFT/2+1)),'r');
        legend('Raw Force')
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|')
        xlim([0 30])
        hold all
    else
        warndlg('Raw Force signal wasn''t found, so it''s not plotted.','Warning');
    end
end
if filtForceState == 1
    figure()
    if isfield(data,'filtForce')==1
        filtForceLength=length(data.rawForce);
        filtNFFT = 2^nextpow2(filtForceLength); % Next power of 2 from length of y
        filtFreq = 1000/2*linspace(0,1,filtNFFT/2+1);
        filtForceMag = fft(data.filtForce,filtNFFT)/filtForceLength;
        plot(filtFreq,2*abs(filtForceMag(1:filtNFFT/2+1)),'r');
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|')
        xlim([0 30])
        legend('Filtered Force')
    else
        warndlg('Filtered Force signal wasn''t found, so it''s not plotted.','Warning');
    end
end

if rawTorqueState == 1
    figure()
    if isfield(data,'rawTorque')==1
        rawTorqueLength=length(data.rawForce);
        rawNFFT = 2^nextpow2(rawTorqueLength); % Next power of 2 from length of y
        rawFreq = 1000/2*linspace(0,1,rawNFFT/2+1);
        rawTorqueMag = fft(data.rawTorque,rawNFFT)/rawTorqueLength;
        plot(rawFreq,2*abs(rawTorqueMag(1:rawNFFT/2+1)),'r');
        legend('Raw Torque')
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|')
        xlim([0 30])
        hold on
    else
        warndlg('Raw Torque signal wasn''t found, so it''s not plotted.','Warning');
    end
end
if filtTorqueState == 1
    figure()
    if isfield(data,'filtTorque')==1
        filtTorqueLength=length(data.filtTorque);
        filtNFFT = 2^nextpow2(filtTorqueLength); % Next power of 2 from length of y
        filtFreq = 1000/2*linspace(0,1,filtNFFT/2+1);
        filtTorqueMag = fft(data.filtTorque,filtNFFT)/filtTorqueLength;
        plot(filtFreq,2*abs(filtTorqueMag(1:filtNFFT/2+1)),'b');
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|')
        xlim([0 30])
        legend('Filtered Torque')
    else
        warndlg('Filtered Torque signal wasn''t found, so it''s not plotted.','Warning');
    end
end

%%
guidata(hObject, handles);

% --- Executes on button press in chkbox_Grph_RawPosition.
function chkbox_Grph_RawPosition_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_RawVel.
function chkbox_Grph_RawForce_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_RawTorque.
function chkbox_Grph_RawTorque_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_RawPressure.
function chkbox_Grph_RawPressure_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_FiltForce.
function chkbox_Grph_FiltForce_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_FiltTorque.
function chkbox_Grph_FiltTorque_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_PhzAvgPosition.
function chkbox_Grph_PhzAvgPosition_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_PhzAvgAngularVel.
function chkbox_Grph_PhzAvgAngularVel_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_PhzAvgRawForce.
function chkbox_Grph_PhzAvgRawForce_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_PhzAvgFiltForce.
function chkbox_Grph_PhzAvgFiltForce_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_PhzAvgRawTorque.
function chkbox_Grph_PhzAvgRawTorque_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_PhzAvgFiltTorque.
function chkbox_Grph_PhzAvgFiltTorque_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_PhzAvgRawPower.
function chkbox_Grph_PhzAvgRawPower_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_Grph_PhzAvgFiltPower.
function chkbox_Grph_PhzAvgFiltPower_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_FFT_RawForce.
function chkbox_FFT_RawForce_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_FFT_RawTorque.
function chkbox_FFT_RawTorque_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_FFT_FiltForce.
function chkbox_FFT_FiltForce_Callback(hObject, eventdata, handles)
% --- Executes on button press in chkbox_FFT_FiltTorque.
function chkbox_FFT_FiltTorque_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbtn_CloseAllFig.
function pushbtn_CloseAllFig_Callback(hObject, eventdata, handles)
set(handles.output, 'HandleVisibility', 'off');
close all;
set(handles.output, 'HandleVisibility', 'on');

% --- Executes on button press in pushbtn_amplitudeCalibrator.
function pushbtn_amplitudeCalibrator_Callback(hObject, eventdata, handles)
pushbtn_AllinOneAnalysis_Callback;
data=evalin('base','data');
correctedAmplitude=((1-data.realAmp/data.idealAmp)*data.idealAmp)+data.idealAmp;
msgbox(sprintf('The Corrected Input Amplitude for currently loaded data is %4.2f degrees.', correctedAmplitude),'Amplitude Correction');

% --- Executes on button press in pushbtn_tGageCalibrator.
function pushbtn_tGageCalibrator_Callback(hObject, eventdata, handles)
clc
clear all
% calibration.aluminumCoulplerShaftGap=(1-0.25-0.4)*0.0254; % [inches to meters]
% calibration.shaftLength=0.9*0.0254; % [m] distance between force applied and shaft
% calibration.armLength=calibration.aluminumCoulplerShaftGap+calibration.shaftLength;
calibration.armLength=.0325;    % [meters]
%% Dialog box asking whether or not to zero out sensors for before starting
calibration.tareData = [0 0 0 0 0 0 0 0 0 0];
% Default Taring value for Time + 4 sensor data
sensorZeroingChoice = questdlg('First, would you like to zero out sensors?',...
    'Zero Out Sensors', ...
    'YES','NO','YES');
if strcmp(sensorZeroingChoice,'YES')==1
    uiwait(warndlg('MUST remove any calibration weights loaded on the setup',...
        '!! Warning !!'));
    autoRun=0;
    [tareArg1,tareArg2]=funcSensorTaring(autoRun);   % If Yes, Calls SensorDataZero function
    if tareArg1>0
        calibration.tareData=tareArg2
    end
elseif strcmp(sensorZeroingChoice,'NO')==1
end     % If No, continues without zeroing sensors
tgTareData = calibration.tareData(3); %torque gage tare factor is second element of TareData
daq_ses = daq.createSession('ni');
torqueGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai1','Voltage');   % torque gage
torqueGageChann.Range=[-10,10];
torqueGageChann.TerminalConfig = 'SingleEnded';
daq_ses.DurationInSeconds = 5; % time [s] to record each calibration for
daq_ses.Rate = 1000;
counter = 0;
continueExp = 1;
%%
while continueExp == 1
    %% Dialog box asking mass
    counter=counter+1;
    window_title = 'Torque Gage Calibration';
    prompt = {'Mass [g]'};
    num_lines = 1;
    defAns = {''};
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='none';
    calibLoad = inputdlg(prompt,window_title,num_lines,defAns,options);
    % if user presses Cancel
    if isempty(calibLoad)
        return
    end
    % assigns the numeric values entered by the user to appropriate variables
    massLoad = str2num(calibLoad{1})
    % condition to check if all inputs are numerical
    % if inputs are non-numerical, then the input window is redisplayed
    if size(massLoad) == 0
        continue
    end
    %% Calibration Data Acquisition Begins
    putWeights = questdlg({'Load calibration weight';...
        'and hit OK to start'},'Begin Calibration','OK','OK');
    sensorData(counter) = 0;
    if strcmp(putWeights,'OK') == 1
        mass(counter) = massLoad;
        sensorAllData = startForeground(daq_ses);
        dataTotalSize = size(sensorAllData);
        dataSize = dataTotalSize(1);
        sensorData(counter) = mean(sensorAllData(1001:dataSize));
        %% Dialog box asking whether or not to add another weight
        nextCalibLoad = questdlg({'Data Recording successful.';...
            'Would you like to load another weight?'},...
            'Continue Calibration', ...
            'Yes please','No! Calibration Completed','Yes please');
        if strcmp(nextCalibLoad,'Yes please')==1
            continue
        end
    else
        mass = 0;
        msgbox('Calibration Terminated','Calibration Terminated');
    end
    continueExp = 0;
end

if mass~=0
    calibration.calibData = sensorData - tgTareData;
    calibration.mass=mass;
    calibration.force=mass*9.8065/1000; % grams to Newton
    calibration.torque=calibration.force*calibration.armLength;
    calibrationCurves=polyfit(calibration.torque,calibration.calibData,1);
    calibration.tg_m=calibrationCurves(1);
    calibration.tg_c=calibrationCurves(2);
    figure();
    plot(calibration.torque,calibration.calibData,'ro-');
    title('Torque Gage Calibration: Voltage[V] vs Torque [N-m]');
    xlabel('Torque [N-m]');ylabel('voltave[V]');
    legend(['slope(m) = ',num2str(calibration.tg_m),' | intercept(c) = ',num2str(calibration.tg_c)],'Location', 'NorthWest');
    uisave('calibration','tgCalibration');
    assignin('base','calibration',calibration);
end

% --- Executes on button press in pushbtn_tGageCalibrator.
function pushbtn_pGageCalibrator_Callback(hObject, eventdata, handles)
clc
%% Dialog box asking air properties for the day
continueAirReading = 1;
while continueAirReading == 1
    window_title = 'Pressure Gage Calibration';
    prompt = {'Temperature [C]', 'Humidity [%]'};
    num_lines = 1;
    defAns = {'',''};
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='none';
    airReading = inputdlg(prompt,window_title,num_lines,defAns,options);
    % if user presses Cancel
    if isempty(airReading)
        return
    end
    % assigns the numeric values entered by the user to appropriate variables
    roomTemp = str2num(airReading{1});    % wind tunnel frequency
    relHumidity = str2num(airReading{2});  % pressure reading from the gage
    % condition to check if all inputs are numerical
    % if inputs are non-numerical, then the input window is redisplayed
    if size(roomTemp) == 0 | size(relHumidity) == 0
        continue
    end
    
    calibration.roomTemp=roomTemp+273.15;     % Celcius to Kelvin
    calibration.relHumidity=relHumidity;          % just for record
    R_specific=287.058; % J/(kg.K)
    calibration.elevation=70.104; % [meters] == 230 ft;
    calibration.atmPressure=101325*(1-2.25577*10^(-5)*calibration.elevation)^5.25588; % Pa
    calibration.airDensity=calibration.atmPressure/(R_specific*calibration.roomTemp);
    continueAirReading=0;
end

% Dialog box asking whether or not to zero out sensors for before starting
calibration.tareData = [0 0 0 0 0 0 0 0 0 0]; % Default Taring value for Time + 4 sensor data

% Taring value for downwards calibration of windtunnel
% get this taring value from the upwards calibration tareData done earlier
calibration.tareData = [0 0 0 0 0 0 0 0 0.0008 0.0025];
% if doing downwards calibration and above tareData values are updated
% then select NO in the following menu
sensorZeroingChoice = questdlg('First, would you like to zero out sensors?',...
    'Zero Out Sensors', ...
    'YES','NO','YES');
if strcmp(sensorZeroingChoice,'YES')==1
    uiwait(warndlg('The wind tunnel must be at 0 Hz or not be running!',...
        '!! Warning !!'));
    autoRun=0;
    [tareArg1,tareArg2]=funcSensorTaring(autoRun);   % If Yes, Calls SensorDataZero function
    if tareArg1>0
        calibration.tareData=tareArg2
    end
elseif strcmp(sensorZeroingChoice,'NO')==1
end     % If No, continues without zeroing sensors
pgTareData = calibration.tareData(4); % pressure gage tare factor is second element of TareData
daq_ses = daq.createSession('ni');
daq_ses.addAnalogInputChannel('Dev1','ai4','Voltage');   % torque gage
daq_ses.DurationInSeconds = 5; % time [s] to record each calibration for
daq_ses.Rate = 1000;
counter = 0;
continueExp = 1;
while continueExp == 1
    counter=counter+1;
    %% Begin Calibration Data Acquisition
    runWindtunnel = questdlg({'Run windtunnel at desired frequency and';...
        '                 hit OK to start'},'Begin Calibration','OK','OK');
    if strcmp(runWindtunnel,'OK') == 1
        sensorAllData = startForeground(daq_ses);
        dataSize = length(sensorAllData);
        sensorData(counter) = mean(sensorAllData(1001:dataSize));
        
        %% Dialog box asking pressure reading and wind tunnel frequency
        continueWindLoad = 1;
        while continueWindLoad == 1
            
            window_title = 'Pressure Gage Calibration';
            prompt = {'Windtunnel Frequency [Hz]', 'Output Pressure Reading [Pa]'};
            num_lines = 1;
            defAns = {'',''};
            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='none';
            windLoad = inputdlg(prompt,window_title,num_lines,defAns,options);
            % if user presses Cancel
            if isempty(windLoad)
                return
            end
            % assigns the numeric values entered by the user to appropriate variables
            tunnelFreq = str2num(windLoad{1});    % wind tunnel frequency
            pressReading = str2num(windLoad{2});  % pressure reading from the gage
            % condition to check if all inputs are numerical
            % if inputs are non-numerical, then the input window is redisplayed
            if size(tunnelFreq) == 0 | size(pressReading) == 0
                continue
            end
            continueWindLoad=0;
        end
        calibration.tunnelFreq(counter)=tunnelFreq;
        calibration.pressReading(counter)=pressReading;
        %% Dialog box asking whether or not to add another weight
        nextCalibLoad = questdlg({'Data Recording successful.';...
            'Would you like to run another windtunnel frequency?'},...
            'Continue Calibration', ...
            'Yes please','No! Calibration Completed','Yes please');
        if strcmp(nextCalibLoad,'Yes please')==1
            continue
        end
    else
        calibration.tunnelFreq = 0;
        msgbox('Calibration Terminated','Calibration Terminated');
    end
    continueExp = 0;
end

if calibration.tunnelFreq>0
    if pgTareData <= 0
        calibration.calibData = sensorData + abs(pgTareData);
    else
        calibration.calibData = sensorData - abs(pgTareData);
    end
    calibration.airVelocity=sqrt(2*calibration.pressReading/calibration.airDensity);
    uisave('calibration','pgCalibration');
    assignin('base','calibration',calibration);
end

% --- Executes on button press in pushbtn_WindtunnelCalibrator.
function pushbtn_WindtunnelCalibrator_Callback(hObject, eventdata, handles)
clc
clear global pressureSensorData pressureSensorTime airDensity handlePlot
global airDensity
global zeroWindTareData
global calibData
calibData=funcCalibrationCurves; %Calls AllCalibrationCurves function
calibData=calibData(2);
global maxVelocityToTest
maxVelocityToTest=10;
%% First pressure gage is tared without windtunnel on.
uiwait(warndlg({'First, make sure the windtunnel is switched off, that is,'...
    'wind speed should be 0 m/s'},'Zero windspeed (0 m/s) sensor taring'));
autoRun=0;
[tareArg1,tareArg2]=funcSensorTaring(autoRun); % Always Zeroes Sensor first
if tareArg1>0
    tareData=tareArg2;
end
zeroWindTareData=tareData(4); % Tare value is negated then subtracted from data
if zeroWindTareData>0
    zeroWindTareData=-zeroWindTareData;
end

%% Parameters to load files
windSetting=1;
while windSetting==1
    window_title = 'Wind Parameters';
    prompt = {'Air Temperature [C]','Humidity'};
    num_lines = [1 47];
    defAns = {'30','30'};
    options.WindowStyle='normal';
    expSettings = inputdlg(prompt,window_title,num_lines,defAns,options);
    % if user presses Cancel
    if isempty(expSettings)
        return
    end
    % assigns the numeric values entered by the user to appropriate variables
    airTemp = str2num(expSettings{1});
    relHumidity=str2num(expSettings{2});
    
    % condition to check if all inputs are numerical
    % if inputs are non-numerical, then the input window is redisplayed
    if size(airTemp) == 0 | size(relHumidity) == 0
        continue
    end
    airDensity=funcAirPropertiesCalculator(airTemp,relHumidity);
    windSetting=0;
end

%% Data Acquisition and plotting happens here
global handlePlot
daq_ses=daq.createSession ('ni');
daq_ses.addAnalogInputChannel('Dev1','ai4','Voltage');
daq_ses.Rate = 1000;
daq_ses.IsContinuous=true;
lh=daq_ses.addlistener('DataAvailable', @funcVelocityPlotter);
figure()
daq_ses.startBackground;
handleStop=uicontrol('style','pushbutton');
set(handleStop,'position',[1 1,80,25])
set(handleStop,'string','Stop Plotting')
set(handleStop,'callback',{@funcStopVelocityPlot,handlePlot,lh})
handleValue=uicontrol('style','text');
set(handleValue,'position',[100 1,135,24])
set(handleValue,'String','Average Velocity [m/s]:')

% --- Executes on button press in edit_Callback.
function edit_WingVerticalAligner_Callback(hObject, eventdata, handles)
degPoz=str2double(get(hObject,'String'));
assignin('base','offsetAngle',degPoz);
if isnan(degPoz) == 0
    pozInTime = round((degPoz*10+1496)*4);
    lowPozTarget = bitand(pozInTime,127);
    highPozTarget = bitshift(bitand(pozInTime,16256),-7);
    pololuServo = serial('COM5',...
        'Baudrate',38400, ...
        'DataBits',8, ...
        'Parity','none');
    fopen(pololuServo);
    fwrite(pololuServo,[132,0,lowPozTarget,highPozTarget,'uint8']);
    fclose(pololuServo);
    delete(pololuServo);
end

% --- Executes during object creation, after setting all properties.
function edit_WingVerticalAligner_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_WingVerticalAligner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit_WingVerticalAligner controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%% GUI CALLBACK FUNCTIONS END HERE %%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%% CUSTOM FUNCTIONS BEGIN HERE %%%%%%%%%%%%%%%%%%%%%%%

% Experiment Parameters Function Begins Here
function expPara=funcExperimentParameters
expPara.forceSetup='thrust'; % 'lift' or 'thrust' or 'inertial'
expPara.wingType='chordwiseFlexion'; % 'SpanwiseFlexion' or 'chordwiseFlexion'
expPara.chordLength=3.75*0.0254; % [inces to meters]
expPara.wingSpan=7.5*0.0254; % [inces to meters]
expPara.aluminumCouplerMass=0.008; % [kg]
expPara.wingShaft=(5.46+0.25/2)*0.0254; % [inches to meters]
expPara.wingBase2PeakLength = expPara.wingShaft + expPara.wingSpan/2;
expPara.platformInclination=1; % [degrees]
expPara.actuationSetupMass=2242; % [grams]
% expPara.actuationSetupInclineMass=(expPara.actuationSetupMass...
%     +expPara.wingMass)*sind(expPara.platformInclination); % [grams]
expPara.platformInclinedMass=0;
expPara.offCenterMass=500; % [grams] Additional offcenter mass added
expPara.offsetLoad=(expPara.offCenterMass... %total offcenter load
    +expPara.platformInclinedMass)/1000*9.80665; %[grams to Newton]
% Experiment Parameters Function Ends Here

% Experiment Control Function Begins Here
function rawSignal=experimentControl(temp)
%% Initialization
clear global sensorData sensorTime
clear allRawData allData allSensorData calibratedSignal rawSignal tareData
clc
rawSignal=temp;
%% calls airPropertiesCalculator function to calculate air Properties
rawSignal.airDensity=funcAirPropertiesCalculator(rawSignal.roomTemp,rawSignal.relHumidity);
%% Arguments for servo path generating function
if rawSignal.flapFrequency~=0 % Case: static wing under aerodynamic load
    maxFlapFreq=5; % maximum flapping frequency for servo
    rawSignal.flapFrequency=min(rawSignal.flapFrequency,maxFlapFreq);
    maxPk2PkAmp=60; % maximum peak-2-peak amplitude for servo in degrees
    rawSignal.correctedAmp=min(rawSignal.correctedAmp,maxPk2PkAmp);
    [lowPozTarget,highPozTarget,dt,pozCount,endTime]=...
        funcServoPathGen(rawSignal.flapFrequency,rawSignal.correctedAmp,...
        rawSignal.cycleNum,rawSignal.ramp,rawSignal.offsetAngle);
end

%% In-process taring
rawSignal.inProcessTaring=[0 0 0 0 0 0 0 0 0 0];  % For inprocess taring, if any
if rawSignal.aeroLoadTaring==1 && rawSignal.autoRun==1 && strcmp(rawSignal.expSetup,'windtunnel')==1
    % if automated experiment with aero load taring
    autoRun=rawSignal.autoRun;
    [tareArg1,tareArg2]=funcSensorTaring(autoRun); % Always Zeroes Sensor first
    if tareArg1>0
        rawSignal.inProcessTaring=tareArg2-rawSignal.onWindTareData;
    end
elseif strcmp(rawSignal.expSetup,'vacuumchamber')==1
    % if automated experiment with aero load taring
    autoRun=rawSignal.autoRun;
    [tareArg1,tareArg2]=funcSensorTaring(autoRun); % Always Zeroes Sensor first
    if tareArg1>0
        rawSignal.inProcessTaring=tareArg2+rawSignal.zeroWindTareData;
    end
end

%% DATA ACQUISITION and MAIN CONTROL where servo is moved
global sensorData;
global sensorTime;
rawSignal.samplingRate = 1000;
daq_ses = daq.createSession('ni');
daq_ses.Rate = rawSignal.samplingRate; % Sampling Rate
addCounterInputChannel(daq_ses,'Dev1','ctr0','Position');% optical encoder

% addAnalogInputChannel(daq_ses,'Dev1','ai1','Voltage');   % torque gage
torqueGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai1','Voltage');   % torque gage
torqueGageChann.Range=[-10,10];
torqueGageChann.TerminalConfig = 'SingleEnded';

pressureGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai4','Voltage');   % pressure gage
pressureGageChann.Range=[-10,10];
pressureGageChann.TerminalConfig = 'Differential';

fgCh1=addAnalogInputChannel(daq_ses,'Dev1','ai16','Voltage');   % force gage
fgCh1.TerminalConfig = 'Differential';
fgCh2=addAnalogInputChannel(daq_ses,'Dev1','ai17','Voltage');   % force gage
fgCh2.TerminalConfig = 'Differential';
fgCh3=addAnalogInputChannel(daq_ses,'Dev1','ai18','Voltage');   % force gage
fgCh3.TerminalConfig = 'Differential';
fgCh4=addAnalogInputChannel(daq_ses,'Dev1','ai19','Voltage');   % force gage
fgCh4.TerminalConfig = 'Differential';
fgCh5=addAnalogInputChannel(daq_ses,'Dev1','ai20','Voltage');   % force gage
fgCh5.TerminalConfig = 'Differential';
fgCh6=addAnalogInputChannel(daq_ses,'Dev1','ai21','Voltage');   % force gage
fgCh6.TerminalConfig = 'Differential';

% Dialog box asking to turn compressed gas off

if rawSignal.autoRun==0
    uiwait(warndlg('TURN COMPRESSED GAS ON','WARNING!!!','modal'));
end

if rawSignal.flapFrequency~=0 % Case: dynamic wing under aerodynamic load
    daq_ses.IsContinuous=true;
    daq_handle = daq_ses.addlistener('DataAvailable',@funcDataAcqBackground);
    daq_ses.startBackground;
    funcServoMotion(lowPozTarget,highPozTarget,dt,endTime,pozCount);
    pause(0.25);
    delete(daq_handle); % delete daq_handle;
    stop(daq_ses); % stop daq_ses;
    clear daq_handle
    clear daq_ses
    clear torqueGageChann pressuregageChann fgCh1 fgCh2 fgCh3 fgCh4 fgCh5 fgCh6
elseif rawSignal.flapFrequency==0 % Case: static wing under aerodynamic load
    daq_ses.DurationInSeconds=30;
    [sensorData,sensorTime]=daq_ses.startForeground;
    clear daq_ses
    clear torqueGageChann pressuregageChann fgCh1 fgCh2 fgCh3 fgCh4 fgCh5 fgCh6
end

% Dialog box asking to turn compressed gas off
if rawSignal.autoRun==0
    uiwait(warndlg('TURN COMPRESSED GAS OFF','WARNING!!!','modal'));
end

%% Optical Encoder Position to degrees
encoderCPR = 5000;
counterNBits = 32;
signedThreshold = 2^(counterNBits-1);
signedData = sensorData(:,1);
signedData(signedData > signedThreshold) =...
    signedData(signedData > signedThreshold) - 2^counterNBits;
sensorData(:,1) = signedData * 360/encoderCPR;

%% combines timestamps and sensor data together into a big matrix
allRawData=[sensorTime sensorData];

%% Tares the forcegage and torquegage sensor data
%{
Here stationary load is added. To do so,
the in process tare value is subracted,
and the aero load tare value is added, which is given by,
= windTare.onWindTareData-windTare.zeroWindTareData.
However, only zero wind taring for pressuregage
%}
% Torque Gage
allRawData(:,3) = allRawData(:,3)-rawSignal.inProcessTaring(3)...
    -rawSignal.zeroWindTareData(3);
% Pressure Gage
allRawData(:,4) = allRawData(:,4)-rawSignal.zeroWindTareData(4);
% Force Gage
allRawData(:,5:10) = bsxfun(@minus,allRawData(:,5:10),(rawSignal.inProcessTaring(1,5:10)...
    +rawSignal.zeroWindTareData(1,5:10)));
forceReading=allRawData(:,5:10);
ATIcalibMatrix=funcATIcalibMatrix;
calibForceTorque=(ATIcalibMatrix*forceReading')';
calibForce=calibForceTorque(:,3);
allRawData(:,5:10)=[];
allRawData(:,5)=calibForce; % only 1 column of Fz force gage data left

%% Converts all negative voltage of pressure gage to ZERO(0)
pgData=allRawData(:,4);
pgData(pgData<0)=0;
allRawData(:,4)=pgData;
%{
 % Same thing as above but using for loop
for count=1:1:length(allRawData(:,4))
    if allRawData(count,5)<0
        allRawData(count,5)=0;
    end
end
%}

%% raw signal calibration to plot them for quick view
% all Raw signals are calibrated Here to view quickly
if rawSignal.autoRun==0
    calibratedSignal=funcRawSignalCalibrator(allRawData,rawSignal.airDensity);
    offsetLoad=rawSignal.offsetLoad;
    funcRawDataAnalyzer(calibratedSignal,offsetLoad);
end

%% Creates a structure to save experimental data & Parameters
rawSignal.runTime=allRawData(:,1);
rawSignal.rawPosition=allRawData(:,2);
rawSignal.rawTorque=(-1)*allRawData(:,3);
rawSignal.rawPressure=allRawData(:,4);
rawSignal.rawForce=(-1)*allRawData(:,5);
if strcmp(rawSignal.expSetup,'vacuum')
    rawSignal.pressDiff=pressDiff*3386.389; % inHg to Pa
end
rawSignal.dateOfExp=datestr(now,'dd-mmm-yyyy');
rawSignal.timeOfExp=datestr(now,'HH:MM:SS PM');
% Experiment Control Function Ends Here

% Servo Path Generator Function Begins Here
function [lowPozTarget,highPozTarget,dt,pozCount,endTime]=...
    funcServoPathGen(frequency,amplitude,cycleNumber,ramp,offsetAngle)
endTime = round((cycleNumber+2*ramp)/frequency);
RampUpEnd=ramp/frequency;
RampDownBegin = endTime-ramp/frequency;
dt=min(.001,(1/(2*frequency*amplitude)));
countData=endTime/dt;
pozInTime = zeros(1,countData);
lowPozTarget = zeros(1,countData);
highPozTarget = zeros(1,countData);
time = zeros(1,countData);
pozCount=1;
for instantTime=0:0.001:endTime
    pozCount=pozCount+1;
    time(pozCount) = instantTime;
    if instantTime<RampUpEnd
        degPoz = offsetAngle+((instantTime/RampUpEnd)*((amplitude/2)...
            *sin(2*pi*frequency*instantTime)));
    elseif instantTime<=RampDownBegin && instantTime>=RampUpEnd
        degPoz = offsetAngle+(((amplitude/2)*sin(2*pi*frequency*instantTime)));
    else
        degPoz = offsetAngle+(((endTime-instantTime)/(endTime-RampDownBegin))...
            *((amplitude/2)*sin(2*pi*frequency*instantTime)));
    end
    pozInTime(pozCount) = round((degPoz*10+1496)*4);
    lowPozTarget(pozCount)= bitand(pozInTime(pozCount),127);
    highPozTarget(pozCount)...
        = bitshift(bitand(pozInTime(pozCount),16256),-7);
end
% Servo Path Generator Function Ends Here

% Servo Motion Function Begins Here
function funcServoMotion(lowPozTarget,highPozTarget,dt,endTime,pozCount)
%% Pololu Microcontroller settigns
pololuServo = serial('COM5',...
    'Baudrate',38400, ...
    'DataBits',8, ...
    'Parity','none');
fopen(pololuServo);

%{
%% Motion Method 1
for index=1:1:pozCount
    fwrite(pololuServo,[132,0,lowPozTarget(index),highPozTarget(index)],'uint8');
end
%}
%% Motion Method 2
index=1;
runTime=0;
pause(0.5);
while runTime<endTime
    fwrite(pololuServo,[132,0,lowPozTarget(index),highPozTarget(index)],'uint8');
    runTime = runTime+dt;
    index=index+1;
end

%%
fclose(pololuServo);
delete(pololuServo);
% Servo Motion Function Ends Here

% Background Data Acquisition Function Begins Here
function funcDataAcqBackground(src,event)
global sensorData
global sensorTime
sensorData = [sensorData;event.Data];
sensorTime = [sensorTime;event.TimeStamps];
% Background Data Acquisition Function Ends here

% Air Properties Calculator Function Begins Here
function airDensity=funcAirPropertiesCalculator(roomTemp,relHumidity)
%% Setting up air properties
elevation=70.104;               % [meters] = 230 ft;
molarMassDryAir=0.028964;       % kg/mol
molarMassWaterVapor=0.018016;   % kg/mol
universalGasConstant=8.314;
relHumidity=relHumidity/100;
roomTemp=roomTemp+273.15; % Celcius to Kelvin conversion
atmPressure=101325*(1-2.25577*10^(-5)*elevation)^5.25588; % Pa
saturationVaporPressure=6.1078*10^(7.5*roomTemp/(roomTemp+237.3));
vaporPressureWater=relHumidity*saturationVaporPressure;
partialPressureDryAir=atmPressure-vaporPressureWater;
airDensity=(partialPressureDryAir*molarMassDryAir+...
    vaporPressureWater*molarMassWaterVapor)/(universalGasConstant*roomTemp);
% Air Properties Calculator Function Ends Here

% Windtunnel Velocity Plotter Function Begins Here
function funcVelocityPlotter(src,event)
global pressureSensorData
global pressureSensorTime
global airDensity
global handlePlot
global meanValue
global zeroWindTareData
global calibData
global maxVelocityToTest
plotLength = 10000; % generates 10 seconds window for 1000 sampling rate
pressureSensorTime = [pressureSensorTime;event.TimeStamps];
pressureSensorData = [pressureSensorData;event.Data];
if length(pressureSensorTime) > plotLength
    pressureSensorTime = pressureSensorTime(end-plotLength:end);
    pressureSensorData = pressureSensorData(end-plotLength:end);
end
xMin = pressureSensorTime(1);
xMax = pressureSensorTime(end);
pressure=abs(pressureSensorData+zeroWindTareData)*calibData;
velocity=sqrt(2*pressure/airDensity);
meanValue=mean(sqrt(2*abs(event.Data+zeroWindTareData)*calibData/airDensity));
handlePlot=plot(pressureSensorTime,velocity);
grid on
title('Real Time Air Velocity')
xlabel('        Time [s]')
ylabel('Wind Velocity [m/s]')
xlim([xMin xMax])
ylim([0 maxVelocityToTest]);
handleValue=uicontrol('style','text');
set(handleValue,'position',[235 1,40,24])
set(handleValue,'String',num2str(meanValue,'%0.3f'))
% Windtunnel Velocity Plotter Function Ends Here

% Windtunnel Velocity Plotter STOP Function Begins Here
function funcStopVelocityPlot(handleStop,~,handlePlot,lh)
delete(lh)
% Windtunnel Velocity Plotter STOP Function Ends Here

% Sensor Zeroing Function Begins Here
function [varargout]=funcSensorTaring(autoRun)
clc
% autoRun=0 means that gas line is to be manually turned on/off
% create a session to initialize and acquire date from all gages
daq_SensorZeroSes = daq.createSession('ni');

tgChannZeroSes=addAnalogInputChannel(daq_SensorZeroSes,'Dev1','ai1','Voltage');   % torque gage
tgChannZeroSes.Range=[-10,10];
tgChannZeroSes.TerminalConfig = 'SingleEnded';

pgChannZeroSes=addAnalogInputChannel(daq_SensorZeroSes,'Dev1','ai4','Voltage');   % pressure gage
pgChannZeroSes.Range=[-10,10];
pgChannZeroSes.TerminalConfig = 'Differential';

fgCh1=addAnalogInputChannel(daq_SensorZeroSes,'Dev1','ai16','Voltage');   % force gage
fgCh1.TerminalConfig = 'Differential';
fgCh2=addAnalogInputChannel(daq_SensorZeroSes,'Dev1','ai17','Voltage');   % force gage
fgCh2.TerminalConfig = 'Differential';
fgCh3=addAnalogInputChannel(daq_SensorZeroSes,'Dev1','ai18','Voltage');   % force gage
fgCh3.TerminalConfig = 'Differential';
fgCh4=addAnalogInputChannel(daq_SensorZeroSes,'Dev1','ai19','Voltage');   % force gage
fgCh4.TerminalConfig = 'Differential';
fgCh5=addAnalogInputChannel(daq_SensorZeroSes,'Dev1','ai20','Voltage');   % force gage
fgCh5.TerminalConfig = 'Differential';
fgCh6=addAnalogInputChannel(daq_SensorZeroSes,'Dev1','ai21','Voltage');   % force gage
fgCh6.TerminalConfig = 'Differential';

if autoRun==0
    tareSess=1;
    while tareSess==1   % loop to input tare session time and does num check
        % window_title = title of the Tare Session window
        % promt = Input fields to display on the window
        % num_lines = space for each field
        % defAns = default answers/values(if any) to be displayed in fields
        % options = options to manipulate the dialog box window
        % answer = inputdlg() creates a dialog box to take control inputs
        window_title = 'Tare Time';
        prompt = 'Enter time period (seconds) to tare sensors';
        num_lines = 1;
        defAns = {'10'};
        expSettings = inputdlg(prompt,window_title,num_lines,defAns);
        
        % IF user presses Cancel, taring Cancels
        % condition to check if all inputs are numerical
        % ELSEIF inputs are non-numerical, then the input window is redisplayed
        % ELSEIF tareDuration<.002 then the input window is redisplayed
        if isempty(expSettings)
            tareDuration = 0;
            break;
        end
        tareDuration = str2num(expSettings{1});
        if size(tareDuration) == 0
            continue
        end
        tareSess=0;
    end
else
    tareDuration=5;
end

if tareDuration>=3
    daq_SensorZeroSes.DurationInSeconds=tareDuration;
    daq_SensorZeroSes.Rate = 1000;
    %% Dialog box asking to turn compressed gas on
    if autoRun==0
        uiwait(warndlg('TURN COMPRESSED GAS ON','WARNING!!!','modal'));
    end
    [sensorZeroData] = startForeground(daq_SensorZeroSes);
    if autoRun==0
        uiwait(warndlg('TURN COMPRESSED GAS OFF','WARNING!!!','modal'));
    end
    tareData = mean(sensorZeroData);
    tareData = horzcat(0,0,tareData);
    varargout{1}=tareDuration;
    varargout{2}=tareData;
elseif tareDuration>0 && tareDuration<3
    daq_SensorZeroSes.DurationInSeconds=3;
    daq_SensorZeroSes.Rate = 1000;
    %% Dialog box asking to turn compressed gas on
    if autoRun==0
        uiwait(warndlg('TURN COMPRESSED GAS ON','WARNING!!!','modal'));
    end
    [sensorZeroData] = startForeground(daq_SensorZeroSes);
    if autoRun==0
        uiwait(warndlg('TURN COMPRESSED GAS OFF','WARNING!!!','modal'));
    end
    tareData = mean(sensorZeroData);
    tareData = horzcat(0,0,tareData);
    varargout{1}=tareDuration;
    varargout{2}=tareData;
else
    tareData=[0 0 0 0 0 0 0 0 0 0];
    varargout{1}=tareDuration;
    varargout{2}=tareData;
end
release(daq_SensorZeroSes);
delete(daq_SensorZeroSes);
% Sensor Zeroing Function Ends Here

function [data]=funcStaticWingPerformance(data)
data.timeAvgForceSS=mean(data.rawForce);
data.timeAvgTorqueSS=mean(data.rawTorque);
data.timeAvgOfPhzAvgRawForce=data.timeAvgForceSS;
data.timeAvgOfPhzAvgFiltForce=data.timeAvgForceSS;
data.timeAvgOfPhzAvgRawTorque=data.timeAvgTorqueSS;
data.timeAvgOfPhzAvgFiltTorque=data.timeAvgTorqueSS;
% In static wing case, all Angular Velocity derivatives are zero
data.phaseAvgRawTorque=0;
data.phaseAvgFiltTorque=0;
data.timeAvgOfPhzAvgRawPower=0;
data.timeAvgOfPhzAvgFiltPower=0;

% Raw signal Calibration Structure Preparation Function Begins Here
function data=funcPrepStructuresForRawSigCalib(data)
airDensity=data.airDensity;
% N-by-5 array is created to be sent to the raw calibrator function
allRawData(:,1)=data.runTime;
allRawData(:,2)=data.rawPosition;
allRawData(:,3)=-data.rawTorque;
allRawData(:,4)=data.rawPressure;
allRawData(:,5)=data.rawForce;
% Raw signal Calibrated and assigned to Fields here
calibratedSignal=funcRawSignalCalibrator(allRawData,airDensity);
data.rawTorque=calibratedSignal(:,3);
if strcmp(data.expSetup,'windtunnel')==1
    data.airVelocity=mean(calibratedSignal(:,4));
elseif strcmp(data.expSetup,'vacuumchamber')==1
    data.airVelocity=0;
else
    uiwait(warndlg('Experimental Setup is misconfigured','WARNING!!!','modal'));
end
% Raw Signal Calibration Structure Preparation Function Ends Here

% Raw Signal Calibrator Function Begins Here
function allRawData=funcRawSignalCalibrator(allRawData,airDensity)
%% Calibrated: Voltage to Respective Units: x = (y-c)/m
calibData=funcCalibrationCurves; %Calls funcCalibrationCurves function
% Retrieve slope(m) and intercept(c) calibration values for y=mx+c
% then calibrates the sensor data x=(y-c)/m but c=0 because sensors zeroed
% torque gage data calibration to N-m
allRawData(:,3)=allRawData(:,3)./calibData(1);
% pressure gage data calibration to N/m^2 first then to m/s
allRawData(:,4)=allRawData(:,4).*calibData(2);
allRawData(:,4)=sqrt(allRawData(:,4)./airDensity.*2); % pressure to velocity
% Raw Signal Calibrator Function Ends Here

% Calibration Curves Data Function Begins Here
function calibData=funcCalibrationCurves
clc
% calibration factors   y=mx+c
tg_m = -3.6762;      % V/Nm torque gage calibration slope
pg_m = 5.02;            % Pa/V pressure gage calibration slope
% vel_a = 2.9508;          % vel(y)=a*volt(x)^b pressure gage velocity coeff
% vel_b = 0.501;          % vel(y)=a*volt(x)^b pressure gage velocity coeff
calibData=[tg_m,pg_m];
% Calibration Curves Data Function Ends Here

function ATIcalibMatrix=funcATIcalibMatrix
ATIcalibMatrix=[0.001861654 -0.004931746 -0.050609194 1.107614259 0.007645064 -1.129741579;
    0.018642269 -1.278520506 -0.034300501 0.623009899 -0.005985224 0.662327281;
    0.752223341 0.018153979 0.736665002	0.011211723	0.75722896	0.010438799;
    -3.80988e-06 -0.005616117 0.01070197 0.002970122 -0.010999514 0.002710155;
    -0.012596082 -0.000291486 0.006370314 -0.004809468 0.006281259 0.00514206;
    0.00021306 -0.009241542 0.000346716 -0.009200107 0.000164034 -0.009495897];

% Raw Data Analyzer Function Begins Here
function funcRawDataAnalyzer(allRawData,offsetLoad)
figure;
subplot(2,2,1)
plot(allRawData(:,1), allRawData(:,2));
grid on
xlabel('Time [s]');
ylabel('Angular position [deg.]');
title('Angular position [deg.] vs Time [s]');

subplot(2,2,2)
forceGageLimit(1:length(allRawData(:,1)),1)=9;
plot(allRawData(:,1),-forceGageLimit-offsetLoad,'r-');
hold on
plot(allRawData(:,1),forceGageLimit-offsetLoad,'r-');
hold on
plot(allRawData(:,1), allRawData(:,5));
xlabel('Time [s]');
ylabel('Force [N]');
title('Force [N] vs Time [s]');

subplot(2,2,3)
torqueGageLimit(1:length(allRawData(:,1)),1)=5.6;
plot(allRawData(:,1),-torqueGageLimit,'r-');
hold on
plot(allRawData(:,1),torqueGageLimit,'r-');
hold on
plot(allRawData(:,1), allRawData(:,3));
xlabel('Time [s]');
ylabel('Torque [N-m]');
title('Torque [N-m] vs Time [s]');

subplot(2,2,4)
plot(allRawData(:,1), allRawData(:,4));
grid on
xlabel('Time [s]');
ylabel('Velocity [m/s]');
yLowLim=.95*mean(allRawData(:,4));
yUpLim=1.05*mean(allRawData(:,4));
ylim([yLowLim yUpLim])
title('Velocity [m/s] vs Time [s]');
drawnow;
set(get(handle(gcf),'JavaFrame'),'Maximized',1);
% Raw Data Analyzer Function Ends Here

% Steady State Isolator Function Begins Here
function [data,pozPerCycle,forcePerCycle,torquePerCycle]...
    =funcSteadyStateIsolator(data,force,torque)
%% Deleting Ramp Up and Ramp Down to isolate Main Cycles
rawPosition=data.rawPosition;
firstNonZero=find(rawPosition,1);
nonZeroTime=data.runTime(firstNonZero);
rampUpTime=(data.ramp+1)/data.flapFrequency;
SSBegTime=nonZeroTime+rampUpTime;
SSCycleTime=(data.cycleNum-1)/data.flapFrequency;
SSEndTime=SSBegTime+SSCycleTime;
diff1=abs(data.runTime-SSBegTime);
data.diff1=diff1;
diff2=abs(data.runTime-SSEndTime);
[~,begID]=min(diff1); % begID is where SS cycles begin
[~,endID]=min(diff2); % endID is where SS cycles end
sigLength=length(data.rawPosition);
rawPosition(endID:sigLength)=[];
rawPosition(1:begID)=[];
force(endID:sigLength)=[];
force(1:begID)=[];
torque(endID:sigLength)=[];
torque(1:begID)=[];
% no need to find phase average velocity, coz it's always constant
% so only SS velocity is found
pressSS=data.rawPressure;
pressSS(endID:sigLength)=[];
pressSS(1:begID)=[];
data.rawPressureSS=pressSS;

%% Store Only Steady State Cycle for evaluation
%
data.forceSS=[];     % alocate memory
data.torqueSS=[];    % alocate memory
data.forceSS=force;
data.timeAvgForceSS=mean(data.forceSS);
data.torqueSS=torque;
data.timeAvgTorqueSS=mean(data.torqueSS);
data.positionSS=rawPosition;
runTimeSS=data.runTime;
runTimeSS(endID:sigLength)=[];
runTimeSS(1:begID)=[];
data.runTimeSS=runTimeSS;
%}
%%
% set the peak to peak distance about/less than
% the number of data points between two peaks
MPD = round((data.samplingRate/data.flapFrequency)*.95);
MPH=0.75*data.correctedAmp/2;
sigAvg = mean(rawPosition);
% finds local peaks
[allSSPeaks,allSSPeaksID] = findpeaks(rawPosition,'MINPEAKDISTANCE',MPD,'MINPEAKHEIGHT',MPH);
meanSSPeak=mean(allSSPeaks);    % time average of SS cycles; ideally 0
percentile=0.02;    % Percentage tightness to determine the amplitude
upSSPeakLimit=meanSSPeak+percentile*meanSSPeak;
lowSSPeakLimit=meanSSPeak-percentile*meanSSPeak;
counter=0;
for i=1:1:length(allSSPeaks) % find all peaks within the defined range
    if allSSPeaks(i)<upSSPeakLimit && allSSPeaks(i)>lowSSPeakLimit
        counter=counter+1;
        peakAmpSS(counter)=allSSPeaks(i);  % SS Peak Values
        peakAmpSSLoc(counter)=allSSPeaksID(i);    % SS Peak Value Locations in SS cycles vector
    end
end

%{
% UNCOMMENT ONLY TO OBSERVE PLOTS NEEDED
% Plots the isolated peaks and identifies peaks of interest
runTime=data.runTime;
runTime(endID:sigLength)=[];
runTime(1:begID)=[];
timebeg=runTime(1);
timeend=runTime(length(runTime));
figure()
plot(runTime,rawPosition,runTime(peakAmpSSLoc),peakAmpSS,'or')
hold on
plot([timebeg timeend],[meanSSPeak meanSSPeak],'--g')
hold on
plot([timebeg timeend],[upSSPeakLimit upSSPeakLimit],'--r')
hold on
plot([timebeg timeend],[lowSSPeakLimit lowSSPeakLimit],'--r')
%}

%% Finding Sinewave parameters based on experiment data
numPeaks=length(peakAmpSS);
peakJump=zeros(numPeaks-1,1);
for b=1:1:numPeaks-1 % Finds Peak Jump
    peakJump(b)=round((peakAmpSSLoc(b+1)-...
        peakAmpSSLoc(b))/(data.samplingRate/data.flapFrequency));
end

Periods=zeros(numPeaks-1,1);
for c=1:(numPeaks-1) % Average of Peak to Peak time period
    Periods(c) = abs(peakAmpSSLoc(c)-...
        peakAmpSSLoc(c+1))/(data.samplingRate*peakJump(c));
end
data.realPeriod = mean(Periods);
data.realFreq = 1/data.realPeriod;
data.realAmp = 2*(mean(peakAmpSS)-sigAvg);
data.realCycles = length(peakAmpSS);
data.dataPerCycle=round(data.realPeriod*data.samplingRate);
data.distPeak2Zero=round(data.dataPerCycle/4);

data.perErrFreq=abs((data.realFreq-data.flapFrequency)/data.flapFrequency*100);
data.perErrAmp=abs((data.realAmp-data.idealAmp)/data.idealAmp*100);

%% Selecting Steady State Cycles of Filtered Data
counter=0;
for cyc=2:1:data.realCycles-1  % first and last two grace cycles cycles removed
    counter=counter+1;
    spot=((peakAmpSSLoc(cyc)-data.distPeak2Zero):(peakAmpSSLoc(cyc)+3*data.distPeak2Zero)).';
    pozPerCycle(:,counter)=rawPosition(spot);
    forcePerCycle(:,counter)=force(spot);
    torquePerCycle(:,counter)=torque(spot);
end
% Steady State Isolator Function Ends Here

% Average and StdDev Calculator Function Begins Here
function varargout = funcAvgStdCalculator(rawSignal)
% Phase Average and error
phaseAverage=mean(rawSignal,2); %avg
% phaseAvgErr=std(rawSignal,0,2); %std dev
phaseAvgErr=std(rawSignal,0,2)/sqrt(size(rawSignal,2)); %std error
% pd = fitdist(rawSignal,'Normal') % normal distribution;
% phaseAvgStdErr = paramci(pd); % 95% confidence interval
% phaseAvgStdErr=phaseAvgStdErr(1);

% Average per Cycle
avgPerCycle=mean(rawSignal);
cycleAverage=mean(avgPerCycle);
%cycleAvgErr=std(rawSignal); %std dev
cycleAvgErr=std(rawSignal)/sqrt(length(rawSignal)); %std error
% pd = fitdist(rawSignal,'Normal') % normal distribution;
% phaseAvgStdErr = paramci(pd); % 95% confidence interval
% phaseAvgStdErr=phaseAvgStdErr(1);

varargout{1}=phaseAverage;
varargout{2}=phaseAvgErr;
varargout{3}=cycleAverage;
varargout{4}=cycleAvgErr;
% Average and StdDev Calculator Function Ends Here

% Power Calculation Function Begins Here
function [data]=funcPowerCalculator(data)
% Converting optical encoder position to omega
theta=data.rawPozPerCycle;
time=data.cycleTime;
pozRad =(pi/180)*theta; %Convert degrees to radians
numCycs = size(theta,2); %Each column from the imported pozPerCycle matrix is a single cycle
numInd = size(time,1); %We want to know how many data points we have in a cycle
omegaPerCycle = zeros(numInd,numCycs);
for y=1:numCycs
    for z=1:numInd
        if z==1 %Must use forward differentiation for first omega value
            omegaPerCycle(1,y)=(pozRad(2,y)-pozRad(1,y))/(time(2,1)-time(1,1));
        elseif z==numInd %Must use backward differentiation for final omega value
            omegaPerCycle(numInd,y)=(pozRad(numInd,y)-pozRad(numInd-1,y))/(time(numInd,1)-time(numInd-1,1));
        else %Use central differentiation for all omega values in between
            omegaPerCycle(z,y)=(pozRad(z+1,y)-pozRad(z-1,y))/(time(z+1,1)-time(z-1,1));
        end
    end
end
[data.phaseAvgAngularVel,data.phaseAvgStdErrAngularVel] =...
    funcAvgStdCalculator(omegaPerCycle);
data.timeAvgOfPhzAvgAngularVel=mean(data.phaseAvgAngularVel);
%Power = Torque * Omega
data.rawPowerPerCycle = data.rawTorquePerCycle.*omegaPerCycle;
[data.phaseAvgRawPower,data.phaseAvgStdErrRawPower] =...
    funcAvgStdCalculator(data.rawPowerPerCycle);
data.timeAvgOfPhzAvgRawPower=mean(data.phaseAvgRawPower);
if isfield(data,'filtTorquePerCycle')==1
    data.filtPowerPerCycle=data.filtTorquePerCycle.*omegaPerCycle;
    [data.phaseAvgFiltPower,data.phaseAvgStdErrFiltPower] =...
        funcAvgStdCalculator(data.filtPowerPerCycle);
    data.timeAvgOfPhzAvgFiltPower=mean(data.phaseAvgFiltPower);
end
% Power Calculation Function Ends Here

% Shim Properties Function Begins Here
function [data]=funcShimProperties(data)
if strcmp(data.shimColor,'silver')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.0075;    % inches
elseif strcmp(data.shimColor,'gold')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.010;    % inches
elseif strcmp(data.shimColor,'amber')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.005;    % inches
elseif strcmp(data.shimColor,'purple')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.003;    % inches
elseif strcmp(data.shimColor,'red')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.000;    % inches
elseif strcmp(data.shimColor,'green')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
elseif strcmp(data.shimColor,'tan')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
elseif strcmp(data.shimColor,'blue')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
elseif strcmp(data.shimColor,'transmatte')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
elseif strcmp(data.shimColor,'brown')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
elseif strcmp(data.shimColor,'black')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
elseif strcmp(data.shimColor,'pink')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
elseif strcmp(data.shimColor,'yellow')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
elseif strcmp(data.shimColor,'white')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
elseif strcmp(data.shimColor,'gold')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
elseif strcmp(data.shimColor,'none')==1
    elasticModulus=69;  % GPa
    poissonsRatio=0.33;
    shimThick=0.015;    % inches
else
    warndlg('Shim color didn''t match with database.','Warning');
end
data.shimThick=shimThick*0.0254;     % inces to Meter
data.elasticModulus=elasticModulus;  % GPa to Pa
data.poissonRatio=poissonsRatio;     % unitless
% Shim Properties Function Ends Here

% Error Propagation Function Begins Here
function dy=funcSimplePropErr(propErrID,temp,rowNum,dim4th,singleRowProcessing)
%{
ErrorPropagation ID              Items
1                             Coefficient of Lift or Thrus
2                             Coefficient of Power
3                             Efficiency

Entry Format: propErrID, then enter independent variables and standard errors

%}
if propErrID == 1;
    %% Coefficient of Lift or Thrust (1)
    force=temp.timeAvgOfPhzAvgRawForce(rowNum,:);
    errForce=temp.errTimeAvgOfPhzAvgRawForce(rowNum,:);
    U=temp.airVelocity(rowNum,:);
    errU=temp.errAirVelocity(rowNum,:);
    row=temp.airDensity(rowNum,:);
    errRow=temp.errAirDensity(rowNum,:);
    wingSpan=temp.wingSpan(rowNum,:);
    chordLength=temp.chordLength(rowNum,:);
    %Defining the equations for the different partial derivatives
    dCFdF = 2./(row.*wingSpan.*chordLength.*U.^2);
    dCFdU = (-4.*force)./(row.*wingSpan.*chordLength.*U.^3);
    dCFdRow = (-2.*force)./(row.*wingSpan.*chordLength.*U.^2);
    sumterm1=(dCFdF.*errForce).^2;
    sumterm2=(dCFdU.*errU).^2;
    sumterm3=(dCFdRow.*errRow).^2;
    dy=sqrt(sumterm1+sumterm2+sumterm3);
elseif propErrID ==2;
    %% Coefficient of Power (2)
    if dim4th==1
        power=temp.timeAvgOfPhzAvgRawPower(rowNum,:);
        errPower=temp.errTimeAvgOfPhzAvgRawPower(rowNum,:);
    else
        power=temp.netTimeAvgOfPhzAvgRawPower(rowNum/2,:);
        errPower=temp.errNetTimeAvgOfPhzAvgRawPower(rowNum/2,:);
    end
    if singleRowProcessing==1
        U=temp.airVelocity(rowNum,:);
        errU=temp.errAirVelocity(rowNum,:);
        row=temp.airDensity(rowNum,:);
        errRow=temp.errAirDensity(rowNum,:);
        wingSpan=temp.wingSpan(rowNum,:);
        chordLength=temp.chordLength(rowNum,:);
    elseif singleRowProcessing==2
        U=temp.airVelocity(rowNum-1,:);
        errU=temp.errAirVelocity(rowNum-1,:);
        row=temp.airDensity(rowNum-1,:);
        errRow=temp.errAirDensity(rowNum-1,:);
        wingSpan=temp.wingSpan(rowNum-1,:);
        chordLength=temp.chordLength(rowNum-1,:);
    end
    %Defining the equations for the different partial derivatives
    dCPdPow=2./(row.*wingSpan.*chordLength.*U.^3);
    dCPdU=(-6.*power)./(row.*wingSpan.*chordLength.*U.^4);
    dCPdRow=(-2.*power)./(row.^2.*wingSpan.*chordLength.*U.^3);
    sumterm1=(dCPdPow.*errPower).^2;
    sumterm2=(dCPdU.*errU).^2;
    sumterm3=(dCPdRow.*errRow).^2;
    dy=sqrt(sumterm1+sumterm2+sumterm3);
elseif propErrID == 3;
    %% Efficiency (3)
    if dim4th==1
        coeffPower=temp.coeffPower(rowNum,:);
        errCoeffPower=temp.errCoeffPower(rowNum,:);
    else
        coeffPower=temp.netCoeffPower(rowNum/2,:);
        errCoeffPower=temp.errNetCoeffPower(rowNum/2,:);        
    end    
    if singleRowProcessing==1
        coeffForce=temp.coeffForce(rowNum,:);
        errCoeffForce=temp.errCoeffForce(rowNum,:);
    elseif singleRowProcessing==2
        coeffForce=temp.coeffForce(rowNum-1,:);
        errCoeffForce=temp.errCoeffForce(rowNum-1,:);
    end
    %Defining the equations for the different partial derivatives
    dndCF=1./coeffPower;
    dndCp=(-coeffForce)./(coeffPower.^2);
    sumterm1=(dndCF.*errCoeffForce).^2;
    sumterm2=(dndCp.*errCoeffPower).^2;
    dy=sqrt(sumterm1+sumterm2);
end
% Error Propagation Function Ends Here

%%%%%%%%%%%%%%%%%%%%%%%% CUSTOM FUNCTIONS END HERE %%%%%%%%%%%%%%%%%%%%%%%%
