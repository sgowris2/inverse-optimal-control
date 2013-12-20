function [dataSet] = initializeNumericalDataSet()

global arrivalRate;
global departureRate;
global lInitial;
global noOfLinks;
global noOfPhasesInACycle;
global noOfDataSets;
global minPhaseLength;
global maxPhaseLength;
global phaseSets;
global observedPhases;
global noOfCycles;
global mandatoryPhases;
global zeroTimePhases;
global intersectionName;
global phaseSequence;

loadIntersection(intersectionName);

minPhaseLength = 20;     % Common to all datasets
maxPhaseLength = 100;     % Common to all datasets
noOfPhasesInACycle = numel(phaseSequence);

for i = 1:noOfDataSets
    
    zeroTimePhases{i} = deduceZeroTimePhases(observedPhases{i}, phaseSequence);
    noOfCycles{i} = ((numel(observedPhases{i}) + numel(zeroTimePhases{i}))/numel(phaseSequence));
    agentSimTime{i} = 500;
    arrivalRate{i} =  (0.2+0.1*rand(1,1))*ones(noOfLinks,(noOfCycles{i}*noOfPhasesInACycle));
    % for j = 1:numel(arrivalRate{1})
    %     arrivalRate{1}(j) = arrivalRate{1}(j)*rand(1,1);
    % end
    departureRate{i} = 0.5*ones(noOfLinks,noOfPhasesInACycle);
    lInitial{i} = 15*ones(1,noOfLinks);
    lInitial{i}(1) = 0;
    lInitial{i}(3) = 0;

    [pass] = checkDataSets(noOfLinks, noOfPhasesInACycle, noOfCycles{i}, ...
                                    agentSimTime{i}, arrivalRate{i}, departureRate{i}, lInitial{i},...
                                    phaseSets, phaseSequence, mandatoryPhases,...
                                    observedPhases{i});
    if pass ~= 1
        error('DataSet check failed. Something is seriously wrong.');
    end
    alpha{i} = createAlpha(noOfLinks, noOfPhasesInACycle, arrivalRate{i}, departureRate{i}, phaseSets, noOfCycles{i}, phaseSequence); 
    dataSet{i} = packageDataSets(i, noOfLinks, noOfPhasesInACycle, minPhaseLength,...
                                    maxPhaseLength, noOfCycles{i}, agentSimTime{i}, arrivalRate{i},...
                                    departureRate{i}, lInitial{i}, phaseSets, phaseSequence, zeroTimePhases{i}, alpha{i});
end
