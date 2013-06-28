function [] = plotSwitchingTimes(xExpert, yAgent)

global noOfPhases;


figure;
expertSwitchingTimes = zeros(noOfPhases+1, 1);
for j = 1:noOfPhases+1
    expertSwitchingTimes(j, 1) = xExpert(j+2*noOfPhases - 1, 1);
end

agentSwitchingTimes = zeros(noOfPhases+1, 1);
agentSwitchingTimes(1, 1) = 0;
for j = 1:noOfPhases+1
    agentSwitchingTimes(j, 1) = yAgent(j+2*noOfPhases - 1, 1);
end

plot(0:15, expertSwitchingTimes, '+');
hold on;
plot(0:15, agentSwitchingTimes, 'rs');

title('Switching times as a function of time for the true system and agent');
xlabel('Phase switch');
ylabel('Time of switch');
legend('True system', 'Agent');