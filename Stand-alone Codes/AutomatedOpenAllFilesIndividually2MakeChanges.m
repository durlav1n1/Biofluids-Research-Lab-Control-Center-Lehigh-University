clc
clear all
close all
loadFolder=1;
while loadFolder==1
    fileLoad=1;
    while fileLoad==1
        window_title = 'Test Settings';
        prompt = {'Number of trials for each setting'...
            'Starting Frequency [Hz]','Ending Frequency [Hz]','Frequency Increment [Hz]'...
            'Peak-to-Peak Amplitude [deg]','Pitch Angle [deg]','Flexion Ratio',...
            'Shim Color','Experimental Setup [windtunnel or vacuumchamber]'};
        num_lines = [1 50];
        defaultAns = {'3','0','4.75','0.25','40','0','100','none','windtunnel'};
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
        expSetup = lower(expSettings{9});
        % condition to check if all inputs are numerical and
        % the color of shimstock match with database
        % if inputs are non-numerical, then the input window is redisplayed
        if strcmp(expSetup,'windtunnel')==1 | strcmp(expSetup,'vacuumchamber')==1
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
            end
        else
            continue
        end
        fileLoad=0;
    end
    pitch=num2str(pitchAngle);
    amp=num2str(amplitude);
    %% Main action happens here
    uiwait(warndlg('Open the folder with all files!','WARNING!!!','modal'));
    folderLocationOpen=uigetdir;
    uiwait(warndlg('Now, open the folder to save all modified files','WARNING!!!','modal'));
    folderLocationSave=uigetdir;
    settingCount=0; % keeps track of number of settings for experiment
    for freq=begFreq:deltaFreq:endFreq; % this is where files are extracted
        settingCount=settingCount+1;
        trialCount=0;   % keeps track of number of trials
        for trial=1:1:numTrials
            trialCount=trialCount+1;
            %% Load Files by generating filenames
            flex=num2str(flexion);
            trialSTR=num2str(trial);
            freqSTR=num2str(freq);
            fileName=strcat(folderLocationOpen,'\',trialSTR,'trial_',expSetup,'_rawSignal_',freqSTR,'freq_',...
                amp,'amp_',pitch,'pitch_',flex,'flex_',shimColor,'Color','.MAT');
            load(fileName);
            %% Do what needs to be done to individual files
            rawSignal.rawForce=(-1)*rawSignal.rawForce;
            %% Save files by generating filenames
%             data.dateOfSigProcess=datestr(now,'dd-mmm-yyyy');
%             data.timeOfSigProcess=datestr(now,'HH:MM:SS PM');
            % MAT filename generation
            fileName=strcat(folderLocationSave,'\',trialSTR,'trial_',expSetup,'_rawSignal_',freqSTR,'freq_',...
                amp,'amp_',pitch,'pitch_','40flex_',shimColor,'Color','.MAT');
            save(fileName,'rawSignal');
            clear rawSignal
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
uiwait(warndlg('Operation Completed','WARNING!!!','modal'));