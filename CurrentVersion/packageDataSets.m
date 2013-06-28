function [DataSet] = packageDataSets(dataSetIndex, noOfLinks, noOfPhasesInACycle,...
                                    minPhaseLength, maxPhaseLength, noOfCycles,...
                                    simTime, arrivalRate, departureRate, lInitial,...
                                    phaseSets, phaseSequence, zeroTimePhases,alpha)

global noOfPhasesInACycleIndex;
global minPhaseLengthIndex;
global maxPhaseLengthIndex;
global noOfCyclesIndex;
global simTimeIndex;
global arrivalRateIndex;
global departureRateIndex;
global lInitialIndex;
global phaseSequenceIndex;
global xIndex;
global policyIndex;
global phaseSetsIndex;
global zeroTimePhasesIndex;
global alphaIndex;

noOfPhasesInACycleIndex = 1;
minPhaseLengthIndex = 2;
maxPhaseLengthIndex = 3;
noOfCyclesIndex = 4;
simTimeIndex = 5;
arrivalRateIndex = 6;
departureRateIndex = 7;
lInitialIndex = 8;
phaseSetsIndex = 9;
phaseSequenceIndex = 10;
zeroTimePhasesIndex = 11;
xIndex = 12;
policyIndex = 13;
alphaIndex = 14;


DataSet{noOfPhasesInACycleIndex} = noOfPhasesInACycle;
DataSet{minPhaseLengthIndex} = minPhaseLength;
DataSet{maxPhaseLengthIndex} = maxPhaseLength;
DataSet{noOfCyclesIndex} = noOfCycles;
DataSet{simTimeIndex} = simTime;
DataSet{arrivalRateIndex} = arrivalRate;
DataSet{departureRateIndex} = departureRate;
DataSet{lInitialIndex} = lInitial;
DataSet{phaseSetsIndex} = phaseSets;
DataSet{phaseSequenceIndex} = phaseSequence;
DataSet{zeroTimePhasesIndex} = zeroTimePhases;
DataSet{alphaIndex} = alpha;

