clear all
clc
daq_ses = daq.createSession('ni');
daq_ses.addAnalogInputChannel('Dev1','ai1','Voltage');   % force gage
daq_ses.addAnalogInputChannel('Dev1','ai2','Voltage');   % torque gage
daq_ses.addAnalogInputChannel('Dev1','ai4','Voltage');   % pressure gage
daq_ses.DurationInSeconds=1;
daq_ses.Rate = 1000;
trialCntr=0;
trialFlag=1;
while trialFlag==1
    trialCntr=trialCntr+1;
    clearvars yy tare
    %% TARING OF SENSOR
    uiwait(warndlg({'TURN WINDTUNNEL OFF,'
        'BUT TURN GAS ON AND HIT OK TO START'},'WARNING!!!','modal'));
    %     daq_ses = daq.createSession('ni');
    %     daq_ses.addAnalogInputChannel('Dev1','ai1','Voltage');   % force gage
    %     daq_ses.addAnalogInputChannel('Dev1','ai2','Voltage');   % torque gage
    %     daq_ses.addAnalogInputChannel('Dev1','ai4','Voltage');   % pressure gage
    %     daq_ses.DurationInSeconds=15;
    %     daq_ses.Rate = 1000;
    yy = startForeground(daq_ses);
    tare=mean(yy);
    
    %% DATA ACQ BEGINS
    numFreq=0;
    freqCntr=0;
    freqFlag=1;
    while freqFlag==1
        clearvars yy
        freqCntr=freqCntr+1;
        uiwait(warndlg({'SET THE WINDTUNNEL TO DESIRED SPEED,'
            'AND THEN TURN GAS ON AND HIT OK TO START'},'WARNING!!!','modal'));
        %         daq_ses = daq.createSession('ni');
        %         daq_ses.addAnalogInputChannel('Dev1','ai1','Voltage');   % force gage
        %         daq_ses.addAnalogInputChannel('Dev1','ai2','Voltage');   % torque gage
        %         daq_ses.addAnalogInputChannel('Dev1','ai4','Voltage');   % pressure gage
        %         daq_ses.DurationInSeconds=15;
        %         daq_ses.Rate = 1000;
        yy = startForeground(daq_ses);
        
        yy(:,1)=yy(:,1)-tare(1,1);
        yy(:,2)=yy(:,2)-tare(1,2);
        yy(:,3)=yy(:,3)-tare(1,3);
        for count=1:1:length(yy(:,3))
            if yy(count,3)<0
                yy(count,3)=0;
            end
        end
        data(freqCntr,:,trialCntr)=mean(yy);
        if trialCntr==1
            %% Post Completion Dialog Box
            nextTrialChoice = questdlg('What would you like to do next?',...
                'Experiment Completed!', ...
                'Next Frequency!','Next Trial!','Next Frequency!');
            % if user presses Cancel
            if isempty(nextTrialChoice)
                freqFlag=0;
                continue
            end
            if strcmp(nextTrialChoice,'Next Frequency!')==1
                continue
            elseif strcmp(nextTrialChoice,'Next Trial!')==1
                freqFlag=0;
                continue
            end
        else
            [numFreq,~,~]=size(data);
            if freqCntr==numFreq
                freqFlag=0;
            end
        end
    end
    %% Post Completion Dialog Box
    if trialCntr>1
        nextTrialChoice = questdlg('What would you like to do next?',...
            'Experiment Completed!', ...
            'Next Trial!','Terminate Program!','Next Trial!');
        %% if user presses Cancel
        if isempty(nextTrialChoice)
            trialFlag=0;
            continue
        end
        if strcmp(nextTrialChoice,'Next Trial!')==1
            continue
        elseif strcmp(nextTrialChoice,'Terminate Program!')==1
            trialFlag=0;
            continue
        end
    end
end

%% Setting up air properties
roomTemp=22+273.15; % Celcius to Kelvin conversion
R_specific=287.058; % J/(kg.K)
elevation=70.104; % [meters] == 230 ft;
atmPressure=101325*(1-2.25577*10^(-5)*elevation)^5.25588; % Pa
airDensity=atmPressure/(R_specific*roomTemp);
%% Calibrating Forces
data(:,1,:)=data(:,1,:)/(3.0043e-04);
data(:,2,:)=data(:,2,:)/(-3.305e-03);
data(:,3,:)=sqrt(2*data(:,3,:).*(5.02)./airDensity);
%% Find Means and SD
meanTrials=mean(data(:,3));
stdTrials=std(data(:,3));
meanForce=meanTrials(:,1);
stdForce=stdTrials(:,3);
meanVelocity=meanTrials(:,3);
errorbar(meanVelocity,meanForce,stdForce);