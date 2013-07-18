function [H,F,A,b,Aeq,beq,lb,ub,x0] = cplexGenerateOCvars(dataSet, expertFlag, experiment)

global weights;
global expertWeights;
global featureSelectionIndex;
global phaseSequence;
global xIndex;
global zeroTimePhasesIndex;
global mandatoryPhases;

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
xSize = numel(l) + numel(t) + numel(delta);

J{1} = objJ1_allQ(l,xSize);
J{2} = objJ2_cycleLength(delta,noOfCycles,noOfPhasesInACycle,xSize);
for i = 1:m
    J{i+2} = objJ_queueLength(i,l,xSize);
end
for i = 1:numel(phaseSequence)
    J{i+10} = objJ_phaseLength(i,dataSet{zeroTimePhasesIndex},phaseSequence,delta,noOfCycles,xSize);
end
for i = 1:numel(phaseSequence)
    [J{i+26} f{i+26}] = objJ_phaseLengthL1(i,phaseSequence,delta,xSize);
end
if expertFlag == 0
    for i = 1:numel(phaseSequence)
        [J{i+18} f{i+18}] = objJ_phaseAvgLength(i,dataSet{xIndex},phaseSequence,delta,xSize);
    end
else
    for i = 1:numel(phaseSequence)
        J{i+18} = 0;
    end
    f = {0};
end
for i = 1:m
    [J{i+34} f{i+34}] = objJ_queueLengthL1(i,l,xSize);
end
for i = 1:m
    [J{i+42} f{i+42}] = objJ_leftTurnPenalty(i,mandatoryPhases,l,xSize,phaseSequence);
end

H = zeros(xSize);
F = zeros(1,xSize);
if experiment == 0 && expertFlag == 0
    for i = 1:numel(featureSelectionIndex)
        if featureSelectionIndex(i) > 0
            H = H + (localWeights(featureSelectionIndex(i))*J{i});
            if numel(f{i}) > 1
                F = F + (localWeights(featureSelectionIndex(i))*f{i});  % The phases that minimize the avg observed phase length for each phase can only be used when phases were observed.
            end
        end
    end
    H = 2*H;
elseif experiment == 0 && expertFlag == 1
    for i = 1:numel(featureSelectionIndex)
        if featureSelectionIndex(i) > 0
            H = H + (localWeights(featureSelectionIndex(i))*J{i});
        end
    end
    H = 2*H;
    F = zeros(1,size(H,1));     % Cannot use the feature that minimzes the error of the phase length from the average observed phase length
else
    H = [];
    F = [];
end
x0 = zeros(xSize,1);

[A,b,Aeq,beq,lb,ub] = cplexGenerateOCConstSet(m,n,l,t,delta,alpha,minPhaseLength,maxPhaseLength,zeroTimePhases,lInitial,simTime,agentSimTime,expertFlag);



