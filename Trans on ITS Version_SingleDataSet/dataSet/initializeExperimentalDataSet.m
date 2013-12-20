function [DataSet] = initializeExperimentalDataSet(filenames)

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
global xIndex;
global policyIndex;
global mandatoryPhases;
global phaseSequence;
global noOfCycles;
global leftTurnLinks;
global observedPhases;
global maneuvers;
global intersectionName;
global alphaIndex;
global avgPhaseLength;
global zeroTimePhases;

loadIntersection(intersectionName);

noOfDataSets = numel(filenames);
noOfPhasesInACycle = numel(unique(phaseSequence));
minPhaseLength = 0;        % Common to all datasets
maxPhaseLength = 100;       % Common to all datasets

noOfCycles = cell(noOfDataSets,1);
noOfPhases = cell(noOfDataSets,1);
simTime = cell(noOfDataSets,1);
arrivalRate = cell(noOfDataSets,1);    % per second
departureRate = cell(noOfDataSets,1);


for i = 1:noOfDataSets
    noOfCycles{i} = zeros(noOfDataSets,1);
    noOfPhases{i} = zeros(noOfDataSets,1);
    simTime{i} = zeros(noOfDataSets,1);
    arrivalRate{i} = zeros(noOfDataSets,noOfLinks);
    departureRate{i} = zeros(noOfDataSets,noOfLinks);  % per second
end

for i = 1:numel(filenames)
    [NUM{i} TXT{i} RAW{i}] = xlsread(filenames{i});
    noOfPhases{i} = deduceNoOfPhases(RAW{i});     % This only works for TT files from phone with wrong swipes for phase changes             
    simTime{i} = deduceSimTime(RAW{i});
    
    zeroTimePhases{i} = deduceZeroTimePhases(observedPhases{i}, phaseSequence);
    noOfCycles{i} = ((numel(observedPhases{i}) + numel(zeroTimePhases{i}))/numel(phaseSequence));
    if mod(noOfCycles{i}, 1) > 0
        error('noOfCycles must be a positive integer.');
    end
    [arrivalRate{i}, departureRate{i}] = deduceArrivalDepartureRates(RAW{i},simTime{i},...
                                                                    observedPhases{i}, maneuvers);
%     [arrivalRate{i}, departureRate{i}] = deduceArrivalDepartureRates(RAW{i},simTime{i},...
%                                                                     observedPhases{i}, maneuvers,noOfCycles{i});
    [t{i},delta{i}] = deducePolicy(RAW{i}, zeroTimePhases{i});
    [lIndex] = xIndexing(noOfLinks,noOfCycles{i}*noOfPhasesInACycle);
    [alpha{i}] = createAlpha(noOfLinks, noOfPhasesInACycle, arrivalRate{i}, departureRate{i}, phaseSets, noOfCycles{i}, phaseSequence);
    l{i} = simulateQueues(lIndex,delta{i}, alpha{i}, lInitial{i}, noOfLinks, noOfCycles{i}, noOfPhasesInACycle);
    [pass] = checkDataSets(noOfLinks, noOfPhasesInACycle, noOfCycles{i}, ...
                                simTime{i}, arrivalRate{i}, departureRate{i}, lInitial{i},...
                                phaseSets, phaseSequence, mandatoryPhases,...
                                observedPhases{i});
    if pass ~= 1
        error('DataSet check failed. Something is seriously wrong.');
    end
    DataSet{i} = packageDataSets(i, noOfLinks, noOfPhasesInACycle, minPhaseLength,...
                                maxPhaseLength, noOfCycles{i}, simTime{i}, arrivalRate{i},...
                                departureRate{i}, lInitial{i}, phaseSets, phaseSequence, zeroTimePhases{i},alpha{i});
    
    DataSet{i}{xIndex} = [l{i}';t{i}';delta{i}'];
    DataSet{i}{policyIndex} = [t{i}'];
    %[DataSet{i}{alphaIndex}] = optimizeAlpha(i,DataSet);
    avgPhaseLength{i} = deduceAveragePhaseLengths(DataSet{i}, delta{i});
end

