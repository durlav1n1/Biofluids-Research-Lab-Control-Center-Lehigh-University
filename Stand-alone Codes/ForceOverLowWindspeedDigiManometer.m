clear all
clc

%% First Tare
trialNum=0;
trial=1;
while trial==1
    trialNum=trialNum+1;
    cntr=0;
    runs=1;
    while runs==1
        cntr=cntr+1;
        clearvars -except trialNum trial cntr runs coeffThrust airVelocity
        daq_ses = daq.createSession('ni');
        forceGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai2','Voltage');   % torque gage
        forceGageChann.Range=[-10,10];
        forceGageChann.TerminalConfig = 'SingleEnded';
        pressureGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai4','Voltage');   % pressure gage
        pressureGageChann.Range=[-10,10];
        pressureGageChann.TerminalConfig = 'Differential';
        daq_ses.Rate = 100;
        daq_ses.DurationInSeconds=20;
        uiwait(warndlg('Press OK to start after gas is on for taring'));
        [data,time] = startForeground(daq_ses);
        uiwait(warndlg('Tare recording complete. Turn Gas off now'));
        % plot(time,data)
        taredForce=mean(data(:,1));
        taredPressure=mean(data(:,2));
        % tareVal=mean(data);
        %% Actual data recording
        clearvars -except trialNum trial cntr runs coeffThrust airVelocity coeffThrust cntr tareVal taredPressure taredForce
        daq_ses = daq.createSession('ni');
        forceGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai2','Voltage');   % torque gage
        forceGageChann.Range=[-10,10];
        forceGageChann.TerminalConfig = 'SingleEnded';
        pressureGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai4','Voltage');   % pressure gage
        pressureGageChann.Range=[-10,10];
        pressureGageChann.TerminalConfig = 'Differential';
        daq_ses.Rate = 100;
        daq_ses.DurationInSeconds=100;
        uiwait(warndlg('After wind is steady state, Turn Gas ON and press OK to start'));
        [sensorData,sensorTime] = startForeground(daq_ses);
        uiwait(warndlg('Data recording complete. TURN GASS AND WINDTUNNEL OFF'));
        
        force=sensorData(:,1)-taredForce;
        pressure=sensorData(:,2)-taredPressure;
        meanTaredForce=mean(force)/11.305;
        meanTaredPressure=mean(pressure)*5.02;
        airDensity=1.1745; %kg/m^3
        airVelocity(trialNum,cntr)=sqrt(2*meanTaredPressure/airDensity)
        chordLength=3.4*0.0254; % in to m
        wingSpan=8.125*0.0254; % in to m
        coeffThrust(trialNum,cntr)=meanTaredForce/(0.5*airDensity*airVelocity(trialNum,cntr)^2*chordLength*wingSpan);
        button=questdlg('Continue for next windspeed RUN','Windspeed Run','YES','NO','YES');
        if strcmp(button,'YES')==1
            runs=1;
        else
            runs=0;
        end
    end
    button=questdlg('Continue for next set of TRIALS','Windspeed Sweep Trial','YES','NO','YES');
    if strcmp(button,'YES')==1
        trial=1;
    else
        trial=0;
    end
end
meanCoeffThrust=mean(coeffThrust);
errCoeffThrust=std(coeffThrust)/sqrt(trialNum);
meanAirVel=round(mean(airVelocity));
figure()
errorbar(meanAirVel,meanCoeffThrust,errCoeffThrust);