clc
clear all
amplitudeMap.idealAmp=input('Enter Ideal Peak-to-Peak Amplitude: ');
amplitudeMap.flexionRatio=input('Enter wing Flexion ratio: ');
amplitudeMap.shimColor=input('Enter shim color: ','s');
begFreq=input('Enter Beginning flapping frequency: ');
endFreq=input('Enter End flapping frequency: ');
deltaFreq=input('Enter flapping frequency Increment: ');
numElements=(endFreq-begFreq)/deltaFreq+1;
flapFrequency=zeros(1,numElements);
correctedAmp=zeros(1,numElements);
cntr=0;
for frequency=begFreq:deltaFreq:endFreq
    cntr=cntr+1;
    flapFrequency(1,cntr)=frequency;
    fprintf('\nFor wing of %d flexion ratio at %.2f Hz',...
        amplitudeMap.flexionRatio,frequency)
    correctedAmp(1,cntr)=input('\nEnter corrected Amplitude: ');
end
amplitudeMap.ampMap=containers.Map(flapFrequency,correctedAmp);
%% MAT filename generation
begFreq=num2str(begFreq);
endFreq=num2str(endFreq);
idealAmp=num2str(amplitudeMap.idealAmp);
flexionRatio=num2str(amplitudeMap.flexionRatio);
fileName=strcat('AmplitudeMap_',begFreq,'to',endFreq,'Hz_',...
    idealAmp,'amp_',flexionRatio,'flex_',...
    amplitudeMap.shimColor,'Color','.mat');
uisave('amplitudeMap',fileName);