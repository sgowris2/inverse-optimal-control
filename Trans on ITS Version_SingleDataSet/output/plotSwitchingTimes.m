function [] = plotSwitchingTimes(expertSwitchingTimes, agentSwitchingTimes)

global noOfPhases;
figure;

plot(0:15, expertSwitchingTimes, '+');
hold on;
plot(0:15, agentSwitchingTimes, 'rs');

title('Switching times as a function of time for the true system and agent');
xlabel('Phase switch');
ylabel('Time of switch');
legend('True system', 'Agent');