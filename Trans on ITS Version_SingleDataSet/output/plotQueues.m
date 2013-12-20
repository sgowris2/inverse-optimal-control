function [] = plotQueues(dataSet,j,lInitial,overlay)

global xIndex;
global simTimeIndex;
global policyIndex;
global alphaIndex;
global noOfLinks;
global noOfPhasesInACycle;
global noOfCyclesIndex;

[l] = xIndexing(noOfLinks,dataSet{noOfCyclesIndex}*noOfPhasesInACycle);

if overlay == 0
    figure;
    style = '-';
else
    hold on;
    style = 'r--';
end

phase = 1;

simTime = dataSet{simTimeIndex};
i = 1;
x(i) = i;
y(i) = lInitial;

for i = 2:simTime
    if i<dataSet{policyIndex}(phase)
        x(i) = i;
        y(i) = y(i-1) + dataSet{alphaIndex}(j,phase);
        if y(i) < 0
            y(i) = 0;
        end
    else
        x(i) = i;
        y(i) = dataSet{xIndex}(l(j,phase));
        phase = phase + 1;
    end
end

plot(x,y,style);
str = sprintf('Queue evolution on Link %i',j);
title(str);
xlabel('Time(s)');
ylabel('Number of vehicles in queue');
