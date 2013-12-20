function [] = plotCumulativeQueues(dataSet,overlay)

global xIndex;
global noOfLinks;
global noOfPhasesInACycle;
global noOfCyclesIndex;

[l,t,delta] = xIndexing(noOfLinks,dataSet{noOfCyclesIndex}*noOfPhasesInACycle);
cumulativeQueues = zeros(1,numel(l)/noOfLinks);

if overlay == 0
    figure;
    style = 'o-';
else
    hold on;
    style = 'sr--';
end
for k = 1:numel(l)/noOfLinks
    for i = 1:noOfLinks
        cumulativeQueues(k) = cumulativeQueues(k) + dataSet{xIndex}(l(i,k));
    end
end

plot(dataSet{xIndex}(t(1:end)),cumulativeQueues,style);