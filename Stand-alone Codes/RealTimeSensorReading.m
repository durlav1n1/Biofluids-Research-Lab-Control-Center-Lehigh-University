function RealTime_LiftToDragRatio
%% Data Acquisition and plotting happens here
clc;
clear all;
close all;
global handlePlot1
global handlePlot2
global handlePlot3
global handlePlot4
% Real-time Data Acquisition and Plotting
homeDegree=0; % Home position in degrees
pozInTime = round((homeDegree*10+1496)*4);
lowPozTarget = bitand(pozInTime,127);
highPozTarget = bitshift(bitand(pozInTime,16256),-7);
pololuServo = serial('COM5','Baudrate',38400,'DataBits',8,'Parity','none');
fopen(pololuServo);
fwrite(pololuServo,[132,0,lowPozTarget,highPozTarget,'uint8']);
fclose(pololuServo);
delete(pololuServo);
daqSes = daq.createSession('ni');
daqSes.Rate=1000;
addCounterInputChannel(daqSes,'Dev1','ctr0','Position');% optical encoder
% forceGageChann=addAnalogInputChannel(daqSes,'Dev1','ai2','Voltage');   % force gage
forceGageChann=addAnalogInputChannel(daqSes,'Dev1','ai18','Voltage');   % force gage
forceGageChann.Range=[-10,10];
forceGageChann.TerminalConfig = 'SingleEnded';
% torqueGageChann=addAnalogInputChannel(daqSes,'Dev1','ai1','Voltage');   % torque gage
torqueGageChann=addAnalogInputChannel(daqSes,'Dev1','ai17','Voltage');   % torque gage
torqueGageChann.Range=[-10,10];
torqueGageChann.TerminalConfig = 'SingleEnded';
% pressureGageChann=addAnalogInputChannel(daqSes,'Dev1','ai4','Voltage');   % pressure gage
pressureGageChann=addAnalogInputChannel(daqSes,'Dev1','ai20','Voltage');   % pressure gage
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
% handleStop.HandleVisibility = 'off';

handleValue1=uicontrol('style','text');
% handleValue1.HandleVisibility = 'off';
set(handleValue1,'units','normalized','position',[0.01 0.83,0.075,0.025])
set(handleValue1,'String','Position [Deg]:')
set(handleValue1,'fontsize',10)
% handleValue1.HandleVisibility = 'off';

handleValue2=uicontrol('style','text');
% handleValue2.HandleVisibility = 'off';
set(handleValue2,'units','normalized','position',[0.01 0.61,0.075,0.025])
set(handleValue2,'String','Force [V]:')
set(handleValue2,'fontsize',10)
% handleValue2.HandleVisibility = 'off';

handleValue3=uicontrol('style','text');
% handleValue3.HandleVisibility = 'off';
set(handleValue3,'units','normalized','position',[0.01 0.40,0.075,0.025])
set(handleValue3,'String','Torque [V]:')
set(handleValue3,'fontsize',10)
% handleValue3.HandleVisibility = 'off';

handleValue4=uicontrol('style','text');
% handleValue4.HandleVisibility = 'off';
set(handleValue4,'units','normalized','position',[0.01 0.19,0.075,0.025])
set(handleValue4,'String','Pressure [V]:')
set(handleValue4,'fontsize',10)
% handleValue4.HandleVisibility = 'off';

function funcVelocityPlotter(src,event)
global handlePlot1
global handlePlot2
global handlePlot3
global handlePlot4
global Time
global Data
plotLength = 5000;
Time = [Time;event.TimeStamps];
Data = [Data;event.Data];
if length(Time) > plotLength
    Time = Time(end-plotLength:end);
    Data = Data(end-plotLength:end,:);
end
xmin = Time(1);
xmax = Time(end);
opticalEncoderCPR = 5000;
counterNBits = 32;
signedThreshold = 2^(counterNBits-1);
signedData = Data(:,1);
signedData(signedData > signedThreshold) =...
    signedData(signedData > signedThreshold) - 2^counterNBits;
positionReading = signedData * 360/opticalEncoderCPR;
forceReading = Data(:,2);
torqueReading = Data(:,3);
pressureReading = Data(:,4);
meanPosition=mean(event.Data(:,1));
meanForce=mean(event.Data(:,2));
meanTorque=mean(event.Data(:,3));
meanPressure=mean(event.Data(:,4));
clf;
subplot(4,1,1)
handlePlot1=plot(Time,positionReading,'k-');
grid on
title('Optical Encoder Position Reading')
xlabel('        Time [s]')
ylabel('Angle (Deg)')
xlim([xmin xmax])
ylim([-50 50])
subplot(4,1,2)
handlePlot2=plot(Time,forceReading,'r-');
grid on
title('Force Gage Voltage Reading')
xlabel('        Time [s]')
ylabel('Votlage [V]')
xlim([xmin xmax])
ylim([-10 10])
subplot(4,1,3)
handlePlot3=plot(Time,torqueReading,'g-');
grid on
title('Torque Gage Voltage Reading')
xlabel('        Time [s]')
ylabel('Votlage [V]')
xlim([xmin xmax])
ylim([-10 10])
subplot(4,1,4)
handlePlot4=plot(Time,pressureReading,'b-');
grid on
title('Pressure Gage Voltage Reading')
xlabel('        Time [s]')
ylabel('Votlage [V]')
xlim([xmin xmax])
ylim([-10 10])
handleValue1=uicontrol('style','text');
set(handleValue1,'units','normalized','position',[0.01 0.815,0.075,0.025])
set(handleValue1,'String',num2str(meanPosition,'%0.3f'))
set(handleValue1,'fontsize',10)
handleValue2=uicontrol('style','text');
set(handleValue2,'units','normalized','position',[0.01 0.595,0.075,0.025])
set(handleValue2,'String',num2str(meanForce,'%0.3f'))
set(handleValue2,'fontsize',10)
handleValue3=uicontrol('style','text');
set(handleValue3,'units','normalized','position',[0.01 0.385,0.075,0.025])
set(handleValue3,'String',num2str(meanTorque,'%0.3f'))
set(handleValue3,'fontsize',10)
handleValue4=uicontrol('style','text');
set(handleValue4,'units','normalized','position',[0.01 0.175,0.075,0.025])
set(handleValue4,'String',num2str(meanPressure,'%0.3f'))
set(handleValue4,'fontsize',10)

function funcStopVelocityPlot(~,~,~,lh)
delete(lh)