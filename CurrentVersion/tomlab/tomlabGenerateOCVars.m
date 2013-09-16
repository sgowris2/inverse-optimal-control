function [A,bL,bU,cL,cU,xL,xU] = tomlabGenerateOCVars(dataSet,expertFlag,experiment)

global weights;
global expertWeights;
global phaseSequence;
global noOfPhasesInACycle;
global ds;

ds = dataSet;

if expertFlag == 1
    localWeights = expertWeights;
else
    localWeights = weights;
end

[noOfLinks, noOfPhasesInACycle, minPhaseLength, ...
maxPhaseLength, noOfCycles, simTime, arrivalRate,...
departureRate, lInitial, phaseSets, phaseSequence, zeroTimePhases] = unpackDataSet(dataSet);

m = noOfLinks;
n = noOfPhasesInACycle*noOfCycles;
tf = simTime;
t0 = 0;
deltaMin = minPhaseLength;
deltaMax = maxPhaseLength;
l0 = lInitial;
alpha = createAlpha(m, noOfPhasesInACycle, arrivalRate, departureRate, phaseSets, noOfCycles, phaseSequence);

persistent l;       % indexed by (link#, phase#)
persistent t;       % indexed by (phase#)    
persistent delta;   % indexed by (phase#)
global agentSimTime;

[l,t,delta] = xIndexing(m,n);    % Index l,t and delta within the vector x

% The objective J(x) is defined in the function: J.m

[A,bL,bU,cL,cU,xL,xU] = tomlabGenerateOCConstSet(m,n,l,t,delta,alpha,minPhaseLength,maxPhaseLength,zeroTimePhases,lInitial,simTime,agentSimTime,expertFlag);