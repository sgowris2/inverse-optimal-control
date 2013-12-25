function [] = visualize(DataSet, agentDataSet)

global noOfDataSets;
global xIndex;
global policyIndex;
global weights;

overlay = 1;
separate = 0;

for d = 1:noOfDataSets
    [noOfLinks, noOfPhasesInACycle, minPhaseLength, maxPhaseLength, noOfCycles, ...
    simTime, arrivalRate, departureRate, lInitial, phaseSets, phaseSequence,...
    zeroTimePhases] = unpackDataSet(DataSet{d});

    plotArrivalDepartureBars(arrivalRate, departureRate);       % Plots a chart of arrival and departure rates for each link at each phase.
%     plotCumulativeQueues(DataSet{d},separate);     % Plots the cumulative queue evolution and phase switches for all links in dataset d
%     plotCumulativeQueues(agentDataSet, overlay);
%     plotObjectiveFunction(weights, DataSet{d}{xIndex},'b');     % Plots a bar chart that shows all weights, featureValues and weights*featureValues
%     plotObjectiveFunction(weights,agentDataSet{xIndex},'r');
    for j = 1:noOfLinks
        plotQueues(DataSet{d}, j, lInitial(j),separate);    % Plots the queue evolution and phase switches for link j in dataset d
        plotQueues(agentDataSet{d}, j, lInitial(j),overlay);                  
    end
    plotPolicy(DataSet{d}, agentDataSet{d});
end