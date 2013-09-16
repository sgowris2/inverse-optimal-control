function [] = plotErrorGraphs(averageWeightError, averageQueueError, averageDeltaError, ErrorStdDev)

figure;
plot(ErrorStdDev, averageWeightError, 'x');
xlabel('Standard Deviation on Error Term in Vehicles/Hour');
ylabel('Average Percent Error over 100 runs');
title('Weight Sensitivity To Arrival Rate Error');

% figure;
% plot(ErrorStdDev, averagePolicyError, 'LineWidth', 1);
% xlabel('Standard Deviation on Error Term');
% ylabel('2-Norm Error on switching time sequence');
% title('Policy sensitivity to Arrival Rate Error');

figure;
plot(ErrorStdDev, averageDeltaError, 'x');
xlabel('Standard Deviation on Error Term in Vehicles/Hour');
ylabel('Average 1-Norm Error Over 100 Runs');
title('Phase Length Sensitivity To Arrival Rate Error');

figure;
plot(ErrorStdDev, averageQueueError, 'x');
xlabel('Standard Deviation on Error Term in Vehicles/Hour');
ylabel('Average 1-Norm Error Over 100 Runs');
title('Queue Length Sensitivity To Arrival Rate Error');