function RealTime_LiftToDragRatio
%% Data Acquisition and plotting happens here
clc;
clear all;
close all;
global handlePlot1
global handlePlot2
global handlePlot3
global handlePlot4
global handlePlot5
global handlePlot6
global handlePlot7
global airDensity

relHumidity=28/100;
        roomTemp=32.6+273.15; % Celcius to Kelvin conversion
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
        
% Real-time Data Acquisition and Plotting

daqSes = daq.createSession('ni');
daqSes.Rate=1000;

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

% pressureGageChann=addAnalogInputChannel(daqSes,'Dev1','ai4','Voltage');   % pressure gage
pressureGageChann=addAnalogInputChannel(daqSes,'Dev1','ai4','Voltage');   % pressure gage
pressureGageChann.Range=[-10,10];
pressureGageChann.TerminalConfig = 'Differential';
daqSes.IsContinuous=true;
lh=daqSes.addlistener('DataAvailable', @funcVelocityPlotter);
figure()
daqSes.startBackground;
handleStop=uicontrol('style','pushbutton');
% handleStop.HandleVisibility = 'off';
set(handleStop,'position',[1 1 80 25]);
set(handleStop,'string','Stop Plotting')
set(handleStop,'callback',{@funcStopVelocityPlot,handlePlot1,lh})
set(handleStop,'callback',{@funcStopVelocityPlot,handlePlot2,lh})
set(handleStop,'callback',{@funcStopVelocityPlot,handlePlot3,lh})
set(handleStop,'callback',{@funcStopVelocityPlot,handlePlot4,lh})
set(handleStop,'callback',{@funcStopVelocityPlot,handlePlot5,lh})
set(handleStop,'callback',{@funcStopVelocityPlot,handlePlot6,lh})
set(handleStop,'callback',{@funcStopVelocityPlot,handlePlot7,lh})
% handleStop.HandleVisibility = 'off';
%{
handleValue1=uicontrol('style','text');
% handleValue1.HandleVisibility = 'off';
set(handleValue1,'units','normalized','position',[0.01 0.83,0.075,0.025])
set(handleValue1,'String','Fx [N]:')
set(handleValue1,'fontsize',10)
% handleValue1.HandleVisibility = 'off';

handleValue2=uicontrol('style','text');
% handleValue2.HandleVisibility = 'off';
set(handleValue2,'units','normalized','position',[0.01 0.73,0.075,0.025])
set(handleValue2,'String','Fy [N]:')
set(handleValue2,'fontsize',10)
% handleValue2.HandleVisibility = 'off';

handleValue3=uicontrol('style','text');
% handleValue3.HandleVisibility = 'off';
set(handleValue3,'units','normalized','position',[0.01 0.61,0.075,0.025])
set(handleValue3,'String','Fz [N]:')
set(handleValue3,'fontsize',10)
% handleValue3.HandleVisibility = 'off';

handleValue4=uicontrol('style','text');
% handleValue1.HandleVisibility = 'off';
set(handleValue1,'units','normalized','position',[0.01 0.51,0.075,0.025])
set(handleValue1,'String','Tx [N*m]:')
set(handleValue1,'fontsize',10)
% handleValue1.HandleVisibility = 'off';

handleValue5=uicontrol('style','text');
% handleValue2.HandleVisibility = 'off';
set(handleValue2,'units','normalized','position',[0.01 0.40,0.075,0.025])
set(handleValue2,'String','Ty [N*m]:')
set(handleValue2,'fontsize',10)
% handleValue2.HandleVisibility = 'off';

handleValue6=uicontrol('style','text');
% handleValue3.HandleVisibility = 'off';
set(handleValue3,'units','normalized','position',[0.01 0.30,0.075,0.025])
set(handleValue3,'String','Tz [N*m]:')
set(handleValue3,'fontsize',10)
% handleValue3.HandleVisibility = 'off';

handleValue7=uicontrol('style','text');
% handleValue4.HandleVisibility = 'off';
set(handleValue4,'units','normalized','position',[0.01 0.19,0.075,0.025])
set(handleValue4,'String','Velocity [m/s]:')
set(handleValue4,'fontsize',10)
% handleValue4.HandleVisibility = 'off';
%}
function funcVelocityPlotter(src,event)
global handlePlot1
global handlePlot2
global handlePlot3
global handlePlot4
global handlePlot5
global handlePlot6
global handlePlot7
global airDensity
global Time
global Data
plotLength = 5000;
Time = [Time;event.TimeStamps];
calMatrix=[0.001861654 -0.004931746 -0.050609194 1.107614259 0.007645064 -1.129741579;
    0.018642269 -1.278520506 -0.034300501 0.623009899 -0.005985224 0.662327281;
    0.752223341 0.018153979 0.736665002	0.011211723	0.75722896	0.010438799;
    -3.80988e-06 -0.005616117 0.01070197 0.002970122 -0.010999514 0.002710155;
    -0.012596082 -0.000291486 0.006370314 -0.004809468 0.006281259 0.00514206;
    0.00021306 -0.009241542 0.000346716 -0.009200107 0.000164034 -0.009495897];
forceCalibData=event.Data(:,1:6);
forceCalibData=(calMatrix*forceCalibData')';

pressureCalibData=event.Data(:,7);  
pressureCalibData(pressureCalibData<0)=0;
airVelocityData=sqrt(2*pressureCalibData*5.02/airDensity);
             
totalData=[forceCalibData airVelocityData];
Data = [Data;totalData];
if length(Time) > plotLength
    Time = Time(end-plotLength:end);
    Data = Data(end-plotLength:end,:);
end
xmin = Time(1);
xmax = Time(end);
FxReading = Data(:,1);
FyReading = Data(:,2);
FzReading = Data(:,3);
TxReading = Data(:,4);
TyReading = Data(:,5);
TzReading = Data(:,6);
velocityReading = Data(:,7);
meanFx=mean(totalData(:,1));
meanFy=mean(totalData(:,2));
meanFz=mean(totalData(:,3));
meanTx=mean(totalData(:,4));
meanTy=mean(totalData(:,5));
meanTz=mean(totalData(:,6));
meanVelocity=mean(totalData(:,7));

subplot(7,1,1)
handlePlot1=plot(Time,FxReading,'k-');
grid on
title('Force Gage Fx Reading')
xlabel('        Time [s]')
ylabel('Force [N]')
xlim([xmin xmax])
ylim([0 5])

subplot(7,1,2)
handlePlot2=plot(Time,FyReading,'r-');
grid on
title('Force Gage Fy Reading')
xlabel('        Time [s]')
ylabel('Force [N]')
xlim([xmin xmax])
ylim([-2.95 -2.85])

subplot(7,1,3)
handlePlot3=plot(Time,FzReading,'g-');
grid on
title('Force Gage Fz Reading')
xlabel('        Time [s]')
ylabel('Force [N]')
xlim([xmin xmax])
ylim([-7 0])

subplot(7,1,4)
handlePlot4=plot(Time,TxReading,'b-');
grid on
title('Force Gage Tx Reading')
xlabel('        Time [s]')
ylabel('Torque [N*m]')
xlim([xmin xmax])
ylim([-10 10])

subplot(7,1,5)
handlePlot5=plot(Time,TyReading,'b-');
grid on
title('Force Gage Ty Reading')
xlabel('        Time [s]')
ylabel('Torque [N*m]')
xlim([xmin xmax])
ylim([-10 10])

subplot(7,1,6)
handlePlot6=plot(Time,TzReading,'b-');
grid on
title('Force Gage Tz Reading')
xlabel('        Time [s]')
ylabel('Torque [N*m]')
xlim([xmin xmax])
ylim([-10 10])

subplot(7,1,7)
handlePlot7=plot(Time,velocityReading,'b-');
grid on
title('Pressure Gage Velocity Reading')
xlabel('        Time [s]')
ylabel('Velocity [m/s]')
xlim([xmin xmax])
ylim([0 10])
%{
handleValue3=uicontrol('style','text');
set(handleValue3,'units','normalized','position',[0.01 0.585,0.075,0.025])
set(handleValue3,'String',num2str(meanFz,'%0.3f'))
set(handleValue3,'fontsize',10)
%}
%{
handleValue1=uicontrol('style','text');
set(handleValue1,'units','normalized','position',[0.01 0.815,0.075,0.025])
set(handleValue1,'String',num2str(meanFx,'%0.3f'))
set(handleValue1,'fontsize',10)
handleValue2=uicontrol('style','text');
set(handleValue2,'units','normalized','position',[0.01 0.695,0.075,0.025])
set(handleValue2,'String',num2str(meanFy,'%0.3f'))
set(handleValue2,'fontsize',10)
handleValue3=uicontrol('style','text');
set(handleValue3,'units','normalized','position',[0.01 0.585,0.075,0.025])
set(handleValue3,'String',num2str(meanFz,'%0.3f'))
set(handleValue3,'fontsize',10)
handleValue4=uicontrol('style','text');
set(handleValue4,'units','normalized','position',[0.01 0.475,0.075,0.025])
set(handleValue4,'String',num2str(meanTx,'%0.3f'))
set(handleValue4,'fontsize',10)
handleValue5=uicontrol('style','text');
set(handleValue5,'units','normalized','position',[0.01 0.375,0.075,0.025])
set(handleValue5,'String',num2str(meanTy,'%0.3f'))
set(handleValue5,'fontsize',10)
handleValue6=uicontrol('style','text');
set(handleValue6,'units','normalized','position',[0.01 0.275,0.075,0.025])
set(handleValue6,'String',num2str(meanTz,'%0.3f'))
set(handleValue6,'fontsize',10)
handleValue7=uicontrol('style','text');
set(handleValue7,'units','normalized','position',[0.01 0.175,0.075,0.025])
set(handleValue7,'String',num2str(meanVelocity,'%0.3f'))
set(handleValue7,'fontsize',10)
%}
function funcStopVelocityPlot(~,~,~,lh)
delete(lh)