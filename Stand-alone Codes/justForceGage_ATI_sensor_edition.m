clear all
%% First Tare
calMatrix=[0.001861654 -0.004931746 -0.050609194 1.107614259 0.007645064 -1.129741579;
            0.018642269 -1.278520506 -0.034300501 0.623009899 -0.005985224 0.662327281;
            0.752223341 0.018153979 0.736665002	0.011211723	0.75722896	0.010438799;
            -3.80988e-06 -0.005616117 0.01070197 0.002970122 -0.010999514 0.002710155;
            -0.012596082 -0.000291486 0.006370314 -0.004809468 0.006281259 0.00514206;
            0.00021306 -0.009241542 0.000346716 -0.009200107 0.000164034 -0.009495897];
trialNum=0;
trial=1;
while trial==1
    trialNum=trialNum+1;
        clearvars -except trialNum trial cntr runs airVelocity...
            WindOffVolt WindOnVolt WindDeltaVolt WindOffForce WindOnForce...
            WindDeltaForce calMatrix
        daqSes = daq.createSession('ni');
        fgCh1=addAnalogInputChannel(daqSes,'Dev1','ai16','Voltage');   % force gage
        fgCh1.TerminalConfig = 'Differential';
        fgCh2=addAnalogInputChannel(daqSes,'Dev1','ai17','Voltage');   % force gage
        fgCh2.TerminalConfig = 'Differential';
        fgCh3=addAnalogInputChannel(daqSes,'Dev1','ai18','Voltage');   % force gage
        fgCh3.TerminalConfig = 'Differential';
        fgCh4=addAnalogInputChannel(daqSes,'Dev1','ai19','Voltage');   % force gage
        fgCh4.TerminalConfig = 'Differential';
        fgCh5=addAnalogInputChannel(daqSes,'Dev1','ai20','Voltage');   % force gage
        fgCh5.TerminalConfig = 'Differential';
        fgCh6=addAnalogInputChannel(daqSes,'Dev1','ai21','Voltage');   % force gage
        fgCh6.TerminalConfig = 'Differential';
        pressureGageChann=addAnalogInputChannel(daqSes,'Dev1','ai4','Voltage');   % pressure gage
        pressureGageChann.Range=[-10,10];
        pressureGageChann.TerminalConfig = 'Differential';
        daqSes.Rate = 500;
        daqSes.DurationInSeconds=15;
        uiwait(warndlg('Press OK to start after gas is on for taring'));
        data = startForeground(daqSes);
        uiwait(warndlg('Tare recording complete. Turn Gas off now'));
        taringForceReading=-mean(data(:,1:6));
        calibTaringForce=(calMatrix*taringForceReading')';
        meanTaringForce=calibTaringForce(3);
        taringPressure=mean(data(:,7));
        %% Actual data recording
        clearvars -except trialNum trial cntr runs airVelocity...
            cntr  taringPressure taringForce...
            WindOffVolt WindOnVolt WindDeltaVolt...
            WindOffForce WindOnForce WindDeltaForce...
            calMatrix taringForceReading untaredForceReading...
            taredForceReading meanTaringForce meanUntaredForce...
            meanTaredForce
        daqSes = daq.createSession('ni');
        % addCounterInputChannel(daq_ses,'Dev1','ctr0','Position');% optical encoder
        fgCh1=addAnalogInputChannel(daqSes,'Dev1','ai16','Voltage');   % force gage
        fgCh1.TerminalConfig = 'Differential';
        fgCh2=addAnalogInputChannel(daqSes,'Dev1','ai17','Voltage');   % force gage
        fgCh2.TerminalConfig = 'Differential';
        fgCh3=addAnalogInputChannel(daqSes,'Dev1','ai18','Voltage');   % force gage
        fgCh3.TerminalConfig = 'Differential';
        fgCh4=addAnalogInputChannel(daqSes,'Dev1','ai19','Voltage');   % force gage
        fgCh4.TerminalConfig = 'Differential';
        fgCh5=addAnalogInputChannel(daqSes,'Dev1','ai20','Voltage');   % force gage
        fgCh5.TerminalConfig = 'Differential';
        fgCh6=addAnalogInputChannel(daqSes,'Dev1','ai21','Voltage');   % force gage
        fgCh6.TerminalConfig = 'Differential';
        pressureGageChann=addAnalogInputChannel(daqSes,'Dev1','ai4','Voltage');   % pressure gage
        pressureGageChann.Range=[-10,10];
        pressureGageChann.TerminalConfig = 'Differential';
        daqSes.Rate = 500;
        daqSes.DurationInSeconds=30;
        uiwait(warndlg('After wind is steady state, Turn Gas ON and press OK to start'));
        sensorData = startForeground(daqSes);
        uiwait(warndlg('Data recording complete. TURN GAS AND WINDTUNNEL OFF'));
        
        pressure=sensorData(:,7)-taringPressure;
        meanTaredPressure=mean(pressure)*5.02;
        untaredForceReading=-mean(sensorData(:,1:6));
        meanUntaredForce=(calMatrix*untaredForceReading')';
        taredForceReading=untaredForceReading-taringForceReading;
        calibForce=(calMatrix*taredForceReading')';
        meanTaredForce=calibForce(3);
        
        relHumidity=input('Enter relative humidity percentage: ');
        relHumidity=relHumidity/100;
        roomTemp=input('Enter room temperature in Celcius: ');
        roomTemp=roomTemp+273.15; % Celcius to Kelvin conversion
        elevation=70.104;               % [meters] = 230 ft;
        molarMassDryAir=0.028964;       % kg/mol
        molarMassWaterVapor=0.018016;   % kg/mol
        universalGasConstant=8.314;
        atmPressure=101325*(1-2.25577*10^(-5)*elevation)^5.25588; % Pa
        saturationVaporPressure=6.1078*10^(7.5*roomTemp/(roomTemp+237.3));
        vaporPressureWater=relHumidity*saturationVaporPressure;
        partialPressureDryAir=atmPressure-vaporPressureWater;
        airDensity=(partialPressureDryAir*molarMassDryAir+...
            vaporPressureWater*molarMassWaterVapor)/(universalGasConstant*roomTemp);
        airVelocity(trialNum,1)=sqrt(2*meanTaredPressure/airDensity);
        WindOffVolt(trialNum,1)=taringForceReading(3);
        WindOnVolt(trialNum,1)=untaredForceReading(3);
        WindDeltaVolt(trialNum,1)=taredForceReading(3);
        WindOffForce(trialNum,1)=meanTaringForce;
        WindOnForce(trialNum,1)=meanUntaredForce(3);
        WindDeltaForce(trialNum,1)=meanTaredForce;
        trial=input('\nEnter 1 to continue next set of TRIALS or 0 to end: ');
end

ForcesChart=table(WindOffVolt,WindOnVolt,WindDeltaVolt,...
    WindOffForce,WindOnForce,WindDeltaForce)