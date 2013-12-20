function [noOfLinks, noOfPhasesInACycle, minPhaseLength, maxPhaseLength, noOfCycles, ...
            simTime, arrivalRate, departureRate, lInitial, phaseSets, phaseSequence,...
            zeroTimePhases] = unpackDataSet(localDataSet)

global noOfPhasesInACycleIndex;
global minPhaseLengthIndex;
global maxPhaseLengthIndex;
global noOfCyclesIndex;
global simTimeIndex;
global arrivalRateIndex;
global departureRateIndex;
global lInitialIndex;
global phaseSetsIndex;
global phaseSequenceIndex;
global zeroTimePhasesIndex;
global objIndex;

noOfPhasesInACycle = localDataSet{noOfPhasesInACycleIndex};
minPhaseLength = localDataSet{minPhaseLengthIndex};
maxPhaseLength = localDataSet{maxPhaseLengthIndex};
noOfCycles = localDataSet{noOfCyclesIndex};
simTime = localDataSet{simTimeIndex};
arrivalRate = localDataSet{arrivalRateIndex};
departureRate = localDataSet{departureRateIndex};
lInitial = localDataSet{lInitialIndex};
noOfLinks = size(localDataSet{lInitialIndex},2);
phaseSets = localDataSet{phaseSetsIndex};
phaseSequence = localDataSet{phaseSequenceIndex};
zeroTimePhases = localDataSet{zeroTimePhasesIndex};