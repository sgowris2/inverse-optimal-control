function [DataSet] = initializeDataSet()

global simTime;
global arrivalRate;
global departureRate;
global lInitial;
global noOfLinks;
global noOfPhases;
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

noOfDataSets = 1;

minPhaseLength = 0;     % Common to all datasets
maxPhaseLength = 90;     % Common to all datasets
noOfPhasesInACycle = numel(phaseSequence);

i = 1;
zeroTimePhases{i} = deduceZeroTimePhases(observedPhases{i}, phaseSequence);
noOfCycles{i} = ((numel(observedPhases{i}) + numel(zeroTimePhases{i}))/numel(phaseSequence));
agentSimTime{1} = 600;
arrivalRate{1} = 0.4*ones(noOfLinks,1);
for j = 1:numel(arrivalRate{1})
    arrivalRate{1}(j) = arrivalRate{1}(j)*rand(1,1);
end
departureRate{1} = 0.4*ones(noOfLinks,noOfPhasesInACycle);
lInitial{1} = 5*ones(1,noOfLinks);
[pass] = checkDataSets(noOfLinks, noOfPhasesInACycle, noOfCycles{i}, ...
                                agentSimTime{i}, arrivalRate{i}, departureRate{i}, lInitial{i},...
                                phaseSets, phaseSequence, mandatoryPhases,...
                                observedPhases{i});
if pass ~= 1
    error('DataSet check failed. Something is seriously wrong.');
end
alpha{i} = createAlpha(noOfLinks, noOfPhasesInACycle, arrivalRate{i}, departureRate{i}, phaseSets, noOfCycles{i}, phaseSequence); 
DataSet{i} = packageDataSets(i, noOfLinks, noOfPhasesInACycle, minPhaseLength,...
                                maxPhaseLength, noOfCycles{i}, agentSimTime{i}, arrivalRate{i},...
                                departureRate{i}, lInitial{i}, phaseSets, phaseSequence, zeroTimePhases{i}, alpha{i});
