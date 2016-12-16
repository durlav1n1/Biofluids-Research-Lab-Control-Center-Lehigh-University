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
        clearvars -except trialNum trial cntr runs coeffThrust...
            airVelocity tunnelFreq pressure
        daq_ses = daq.createSession('ni');
        forceGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai2','Voltage');   % torque gage
        forceGageChann.Range=[-10,10];
        forceGageChann.TerminalConfig = 'SingleEnded';
        daq_ses.Rate = 100;
        daq_ses.DurationInSeconds=15;
        uiwait(warndlg('Press OK to start after gas is on for taring'));
        [data,time] = startForeground(daq_ses);
        uiwait(warndlg('Tare recording complete. Turn Gas off now'));
        % plot(time,data)
        taredForce=mean(data(:,1)); %/0.33084;
        %% Actual data recording
        clearvars -except trialNum trial cntr runs coeffThrust...
            airVelocity coeffThrust cntr tareVal taredPressure...
            taredForce tunnelFreq pressure
        daq_ses = daq.createSession('ni');
        forceGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai2','Voltage');   % torque gage
        forceGageChann.Range=[-10,10];
        forceGageChann.TerminalConfig = 'SingleEnded';
        daq_ses.Rate = 100;
        daq_ses.DurationInSeconds=3*60;
        testSettings=1;
        while testSettings==1
            window_title = 'Test Settings';
            prompt = {'Windtunnel Frequency','Pressure Reading [kPa]','Temperature [C]','Humidity [%]'};
            num_lines = [1 47];
            defaultAns = {'11','0.0','32','26'};
            options.WindowStyle='normal';
            expSettings = inputdlg(prompt,window_title,num_lines,defaultAns,options);
            if isempty(expSettings) % if user presses Cancel
                return
            end
            tunnelFrequency = str2num(expSettings{1})
            pressureReading = str2num(expSettings{2});
            roomTemp = str2num(expSettings{3});
            relHumidity = str2num(expSettings{4});
            if size(tunnelFrequency) == 0 | size(pressureReading) == 0 |...
                    size(roomTemp) == 0 | size(relHumidity) == 0
                continue % condition to check if all inputs are numerical
            else
                testSettings=0;
            end
        end
        uiwait(warndlg('After wind is steady state, Turn Gas ON and press OK to start'));
        [sensorData,sensorTime] = startForeground(daq_ses);
        uiwait(warndlg('Data recording complete. TURN GAS AND WINDTUNNEL OFF'));
        tunnelFreq(trialNum,cntr)=tunnelFrequency;
        pressure(trialNum,cntr)=pressureReading;
        force=sensorData(:,1)-taredForce;
        meanTaredForce=mean(force)/0.33084;
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
        airVelocity(trialNum,cntr)=sqrt(2*1000*pressure(trialNum,cntr)/airDensity);
        chordLength=3.4*0.0254; % in to m
        wingSpan=8.125*0.0254; % in to m
        coeffThrust(trialNum,cntr)=meanTaredForce/(0.5*airDensity*airVelocity(trialNum,cntr)^2*chordLength*wingSpan);
        button=questdlg('Continue for next windspeed RUN ???','Windspeed Run','YES','NO','YES');
        if strcmp(button,'YES')==1
            runs=1;
        else
            runs=0;
        end
    end
    button=questdlg('Continue for next set of TRIALS ???','Windspeed Sweep Trial','YES','NO','YES');
    if strcmp(button,'YES')==1
        trial=1;
    else
        trial=0;
    end
end
meanCoeffThrust=mean(coeffThrust);
errCoeffThrust=std(coeffThrust)/sqrt(trialNum);
meanAirVel=mean(airVelocity);
% figure()
% errorbar(meanAirVel,meanCoeffThrust,errCoeffThrust);
test.coeffThrust=coeffThrust;
test.pressure=pressure;
test.tunnelFreq=tunnelFreq;
test.airVelocity=airVelocity;
test.meanAirVel=meanAirVel;
test.meanCoeffThrust=meanCoeffThrust;
test.errCoeffThrust=errCoeffThrust;










