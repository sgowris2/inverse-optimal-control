global A;
global b;
global Aeq;
global beq;
global simTime;
global arrivalRate;
global departureRate;
global lInitial;
global noOfLinks;
global noOfPhases;
global weights;
global noOfPhasesInACycle;
global noOfDataSets;
global expertWeights;
global weightsSize;
global minWeight;
global minPhaseLength;
global maxPhaseLength;
global xExpertCombined;
global agentPolicy;
global featureSelection;
global featureSelectionIndex;
global mandatoryPhases;
global phaseSequence;
global observedPhases;
global agentNoOfCycles;
global numberOfIterations;
global allQueuesPower;
global allPhaseLengthsPower;
global generalizedObj;
global intersectionName;
global xIndex;
global policyIndex;
global t;
global l;
global delta;
global r3;
global r4;
global eo;
global ef;
global ep;
global eJ;
global edelta;
global eq;
global ew;
global HExpert;
global expertFlag;
global solverName;
global maxPhases;
global maxLinks;
global bestDataSet;
global besteJ;
global experimentalData;

numberOfIterations = 0;
minWeight = 0.001;
agentNoOfCycles = 3;

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
objIndex = 15;