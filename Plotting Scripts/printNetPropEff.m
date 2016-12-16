clear all
flexionRatio=50;
shimColor='blue';
filename=strcat('results_',num2str(flexionRatio),'_',shimColor);
load(filename)
numFreq=length(meanResults.reducedFreq);
figure()
grid on
errorbar(meanResults.reducedFreq(1,2:numFreq),meanResults.netPropEff(1,2:numFreq),...
    meanResults.errNetPropEff(1,2:numFreq),'-ro','LineWidth',1)
hold on
errorbar(meanResults.reducedFreq(3,2:numFreq),meanResults.netPropEff(2,2:numFreq),...
    meanResults.errNetPropEff(2,2:numFreq),'-gs','LineWidth',1)
hold on
errorbar(meanResults.reducedFreq(5,2:numFreq),meanResults.netPropEff(3,2:numFreq),...
    meanResults.errNetPropEff(3,2:numFreq),'-bp','LineWidth',1)
hold on

legend('Net Propulsive Eff - Trial 1',...
    'Net Propulsive Eff - Trial 2',...
    'Net Propulsive Eff - Trial 3',...
    'Location','NorthWest')
title('Net Propulsive Efficiency vs Reduced Freq')
ylabel('Net Propulsive Efficiency')
xlabel('Reduced Freq')