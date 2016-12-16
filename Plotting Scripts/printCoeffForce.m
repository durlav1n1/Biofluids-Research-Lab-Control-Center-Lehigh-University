clear all
flexionRatio=100;
shimColor='none';
filename=strcat('results_',num2str(flexionRatio),'_',shimColor);
load(filename)
figure('units','normalized','outerposition',[0 0 1 1])
errorbar(meanResults.reducedFreq(1,:),meanResults.coeffForce(1,:),...
    meanResults.errCoeffForce(1,:),'-ro','LineWidth',1)
hold on
errorbar(meanResults.reducedFreq(3,:),meanResults.coeffForce(3,:),...
    meanResults.errCoeffForce(3,:),'-gs','LineWidth',1)
hold on
errorbar(meanResults.reducedFreq(5,:),meanResults.coeffForce(5,:),...
    meanResults.errCoeffForce(5,:),'-bp','LineWidth',1)
hold on

grid on
legend('Wind tunnel Ct - Mean of Set 1',...
    'Wind tunnel Ct - Mean of Set 2',...
    'Wind tunnel Ct - Mean of Set 3',...
    'Location','NorthWest')
%title('Coefficient of Thrust vs Reduced Frequency - 50% Rigid Blue Wing')
set(gca, 'FontName', 'Arial')
set(gca, 'FontSize', 16)
ylabel('Coefficient of Thrust (Ct)','FontSize',16)
xlabel('Reduced Frequency','FontSize',16)