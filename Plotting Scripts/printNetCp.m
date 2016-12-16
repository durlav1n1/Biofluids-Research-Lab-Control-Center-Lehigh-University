clear all
flexionRatio=33;
shimColor='black';
filename=strcat('results_',num2str(flexionRatio),'_',shimColor);
load(filename)
meanNetCoeffPower=mean(meanResults.netCoeffPower(:,:));
errNetCoeffPower=mean(meanResults.errNetCoeffPower(:,:));

meanCoeffPowerWind=(meanResults.coeffPower(1,:)+meanResults.coeffPower(3,:)+meanResults.coeffPower(5,:))/3;
errCoeffPowerWind=(meanResults.errCoeffPower(1,:)+meanResults.errCoeffPower(3,:)+meanResults.errCoeffPower(5,:))/3;

meanCoeffPowerVac=(meanResults.coeffPower(2,:)+meanResults.coeffPower(4,:)+meanResults.coeffPower(6,:))/3;
errCoeffPowerVac=(meanResults.errCoeffPower(2,:)+meanResults.errCoeffPower(4,:)+meanResults.errCoeffPower(6,:))/3;

figure('units','normalized','outerposition',[0 0 1 1])
errorbar(meanResults.reducedFreq(1,:),meanCoeffPowerWind,...
    errCoeffPowerWind,'-.rd','LineWidth',1)
hold on
errorbar(meanResults.reducedFreq(1,:),meanCoeffPowerVac,...
    errCoeffPowerVac,':g*','LineWidth',1)
hold on
errorbar(meanResults.reducedFreq(1,:),meanNetCoeffPower,errNetCoeffPower,...
    '-ko','LineWidth',1)

grid on
legend('Wind tunnel Cp with Standard Error',...
    'Vacuum Chamber Cp with Standard Error',...
    'Net Cp with Standard Error',...
    'Location','NorthWest')
% title('Coefficient of Power vs Reduced Frequency - 33% Rigid Black Wing','FontSize',14)
set(gca, 'FontName', 'Arial')
set(gca, 'FontSize', 16)
ylabel('Coefficient of Power (Cp)','FontSize',16)
xlabel('Reduced Frequency','FontSize',16)
