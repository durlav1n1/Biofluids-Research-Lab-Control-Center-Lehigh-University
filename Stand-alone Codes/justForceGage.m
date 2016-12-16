clear all
%% First Tare
trialNum=0;
trial=1;
while trial==1
    trialNum=trialNum+1;
    cntr=0;
    runs=1;
    while runs==1
        cntr=cntr+1;
        clearvars -except trialNum trial cntr runs coeffThrust airVelocity...
            WindOffVolt WindOnVolt WindDeltaVolt WindOffForce WindOnForce WindDeltaForce
        daq_ses = daq.createSession('ni');
        forceGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai2','Voltage');   % force gage
        forceGageChann.Range=[-10,10];
        forceGageChann.TerminalConfig = 'SingleEnded';
        pressureGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai4','Voltage');   % pressure gage
        pressureGageChann.Range=[-10,10];
        pressureGageChann.TerminalConfig = 'Differential';
        daq_ses.Rate = 500;
        daq_ses.DurationInSeconds=30.0;
        uiwait(warndlg('Press OK to start after gas is on for taring'));
        [data,time] = startForeground(daq_ses);
        uiwait(warndlg('Tare recording complete. Turn Gas off now'));
        % plot(time,data)
        taringForce=mean(data(:,1)); %/0.33084;
        taringPressure=mean(data(:,2));
        % tareVal=mean(data);
        %% Actual data recording
        clearvars -except trialNum trial cntr runs coeffThrust airVelocity...
            coeffThrust cntr tareVal taringPressure taringForce data time...
            WindOffVolt WindOnVolt WindDeltaVolt WindOffForce WindOnForce WindDeltaForce
        daq_ses = daq.createSession('ni');
        % addCounterInputChannel(daq_ses,'Dev1','ctr0','Position');% optical encoder
        forceGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai2','Voltage');   % force gage
        forceGageChann.Range=[-10,10];
        forceGageChann.TerminalConfig = 'SingleEnded';
        pressureGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai4','Voltage');   % pressure gage
        pressureGageChann.Range=[-10,10];
        pressureGageChann.TerminalConfig = 'Differential';
        daq_ses.Rate = 500;
        daq_ses.DurationInSeconds=30;
        uiwait(warndlg('After wind is steady state, Turn Gas ON and press OK to start'));
        [sensorData,sensorTime] = startForeground(daq_ses);
        uiwait(warndlg('Data recording complete. TURN GAS AND WINDTUNNEL OFF'));
        %{
%%Optical encoder stuff
encoderCPR = 5000;
counterNBits = 32;
signedThreshold = 2^(counterNBits-1);
signedData = sensorData(:,1);
signedData(signedData > signedThreshold) =...
    signedData(signedData > signedThreshold) - 2^counterNBits;
sensorData(:,1) = signedData * 360/encoderCPR;
allRawData=[sensorTime sensorData];
% data=allRawData(:,3)-tare;
% plot(allRawData(:,1),allRawData(:,2),'b',allRawData(:,1),allRawData(:,3),'r');
% grid on
% ylim([-25 25]);
        %}
        % Other Parameters
        untaredForce=sensorData(:,1);
        taredForce=untaredForce-taringForce;
        %
        pressure=sensorData(:,2)-taringPressure;
        meanTaredForce=mean(taredForce)/11.305;
        meanTaredPressure=mean(pressure)*5.02;
        relHumidity=23/100;
        roomTemp=32.9+273.15; % Celcius to Kelvin conversion
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
        airVelocity(trialNum,cntr)=sqrt(2*meanTaredPressure/airDensity);
        chordLength=3.4*0.0254; % in to m
        wingSpan=8.125*0.0254; % in to m
        coeffThrust(trialNum,cntr)=meanTaredForce/(0.5*airDensity*...
            airVelocity(trialNum,cntr)^2*chordLength*wingSpan);
        %}
        %
        % generate table of taring and tared volts and forces
        WindOffVolt(trialNum,1)=taringForce;
        WindOnVolt(trialNum,1)=mean(untaredForce);
        WindDeltaVolt(trialNum,1)=mean(taredForce);
        WindOffForce(trialNum,1)=taringForce/11.305;
        WindOnForce(trialNum,1)=mean(untaredForce)/11.305;
        WindDeltaForce(trialNum,1)=mean(taredForce)/11.305;
        %}
        
        runs=input('\nEnter 1 to continue next RUN or 0 to end: ');
    end
    trial=input('\nEnter 1 to continue next set of TRIALS or 0 to end: ');
end

ForcesChart=table(WindOffVolt,WindOnVolt,WindDeltaVolt,...
    WindOffForce,WindOnForce,WindDeltaForce)

% meanCoeffThrust=mean(coeffThrust);
% errCoeffThrust=std(coeffThrust)/sqrt(trialNum);
% meanAirVel=round(mean(airVelocity));
% figure()
% errorbar(meanAirVel,meanCoeffThrust,errCoeffThrust);

% cntr=1:cntr;
% figure()
% subplot(2,1,1);
% plot(cntr,coeffThrust,'o-')
% ylabel('coeffThrust')
% subplot(2,1,2);
% plot(cntr,untaredForce,'o-',cntr,taredForce,'*-')
% ylabel('forces')


% plot(time,data(:,1),'-r')
% ylim([-10 10]);
% figure()
% plot(time,data(:,2),'--g')
% ylim([0 0.02])

% %%
% assignin('base','windTare',windTare);
% data(:,1)=data(:,1)-windTare.zeroWindTareData(3);
% data(:,2)=data(:,2)-windTare.zeroWindTareData(4);
%}