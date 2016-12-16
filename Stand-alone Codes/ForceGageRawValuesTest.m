clc;
clear all;

daq_ses = daq.createSession('ni');
forceGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai2','Voltage');   % force gage
forceGageChann.Range=[-10,10];
forceGageChann.TerminalConfig = 'SingleEnded';
daq_ses.Rate = 500;
daq_ses.DurationInSeconds=10.0;

uiwait(warndlg('Press OK to start after gas is on for taring'));
tareData = startForeground(daq_ses);
tareData=mean(tareData)
uiwait(warndlg('Tare recording complete. Turn Gas off now'));
clearvars -except tareData

daq_ses = daq.createSession('ni');
forceGageChann=addAnalogInputChannel(daq_ses,'Dev1','ai2','Voltage');   % force gage
forceGageChann.Range=[-10,10];
forceGageChann.TerminalConfig = 'SingleEnded';
daq_ses.Rate = 500;
daq_ses.DurationInSeconds=30.0;
uiwait(warndlg('Load the weight and Turn Gas ON and press OK to start'));
sensorData = startForeground(daq_ses);
sensorData=mean(sensorData)
uiwait(warndlg('Data recording complete. TURN GASS OFF'));
clearvars -except tareData sensorData
force=(sensorData-tareData)/11.305/9.81*1000