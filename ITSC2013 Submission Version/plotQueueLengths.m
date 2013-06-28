function [] = plotQueueLengths(xExpert, yAgent, linkNumber)

global noOfPhases;
global lInitial;
global simTime;
global alpha;

expertSwitchQueueLengths = zeros(noOfPhases+1, 1);
expertSwitchQueueLengths(1, 1) = lInitial(linkNumber);
for j = 2:noOfPhases+1
    expertSwitchQueueLengths(j, 1) = xExpert(2*(j-1)-mod(linkNumber,2), 1);
    expertSwitchingTimes(j, 1) = xExpert(j-1+noOfPhases*2);
end

agentSwitchQueueLengths = zeros(noOfPhases+1, 1);
agentSwitchQueueLengths(1, 1) = lInitial(linkNumber);
for j = 2:noOfPhases+1
    agentSwitchQueueLengths(j, 1) = yAgent(2*(j-1)-mod(linkNumber,2), 1);
    agentSwitchingTimes(j, 1) = yAgent(j-1+noOfPhases*2);
end

for i = 0:simTime-1
    time(i+1) = i;
end

k = 0;
for i = 1:simTime    
    if i >= expertSwitchingTimes(k+1)
        k = k + 1;
        expertQueueLength(i) = expertSwitchQueueLengths(k);
    else
        expertQueueLength(i) = max(expertQueueLength(i-1) + alpha(linkNumber, k)*1, 0);            
    end
end

k = 0;
for i = 1:simTime
    if i >= agentSwitchingTimes(k+1)
        k = k + 1;
        agentQueueLength(i) = agentSwitchQueueLengths(k);        
    else
        agentQueueLength(i) = max(agentQueueLength(i-1) + alpha(linkNumber, k)*1, 0);            
    end
end

% plot(expertSwitchingTimes, expertQueueLengths,'-rs', 'LineWidth', 1);
% hold on;
% plot(agentSwitchingTimes, agentQueueLengths, '--o', 'LineWidth', 1.5);

figure;
plot(time/60, expertQueueLength,'-r', 'LineWidth', 1);
hold on;
plot(time/60, agentQueueLength, '--', 'LineWidth', 1.5);
plot(expertSwitchingTimes/60, expertSwitchQueueLengths,'rs', 'LineWidth', 1);
plot(agentSwitchingTimes/60, agentSwitchQueueLengths, 'o', 'LineWidth', 1.5);

title('Queue length as a function of time');
xlabel('Time (mins)');
ylabel('Number of vehicles in queue on link 1');
legend('True system', 'Agent');