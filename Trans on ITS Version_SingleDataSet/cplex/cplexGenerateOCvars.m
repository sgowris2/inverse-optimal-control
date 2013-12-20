function [H,F,A,b,Aeq,beq,lb,ub,x0] = cplexGenerateOCvars(dataSet, expertFlag, experiment)

global weights;
global expertWeights;
global featureSelectionIndex;
global phaseSequence;
global xIndex;
global zeroTimePhasesIndex;
global mandatoryPhases;
global HExpert;
global noOfPhasesInACycle;

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

J{1} = objJ2_cycleLength(delta,noOfCycles,noOfPhasesInACycle,xSize);
for i = 1:noOfPhasesInACycle
    J{i+1} = objJ_phaseLength(i,{dataSet{zeroTimePhasesIndex}},phaseSequence,delta,noOfCycles,xSize);
end
for i = 1:m
    [J{i+9} f{i+9}] = objJ_queueLengthL1(i,l,xSize);
end
for i = 1:m
    [J{i+17}] = objJ_queueLength(i,l,xSize);
end
if expertFlag == 0
    for i = 1:numel(phaseSequence)
        [J{i+25} f{i+25} g{i+25}] = objJ_phaseAvgLength(i,dataSet{xIndex},phaseSequence,delta,xSize);
    end
else
    for i = 1:numel(phaseSequence)
        J{i+25} = 0;
        f{i+25} = 0;
    end
end

% for i = 1:numel(phaseSequence)
%     [J{i+26} f{i+26}] = objJ_phaseLengthL1(i,phaseSequence,delta,xSize);
% end
% 
% 
% for i = 1:m
%     [J{i+42} f{i+42}] = objJ_leftTurnPenalty(i,mandatoryPhases,l,xSize,phaseSequence);
% end

H = zeros(xSize);
F = zeros(1,xSize);
if expertFlag == 1 && experiment == 0
    for i = 1:numel(featureSelectionIndex)
        if featureSelectionIndex(i) > 0
            H = H + (localWeights(featureSelectionIndex(i))*J{i});
            if numel(f{i}) > 1 && ~ismember(i,[26,27,28,29,30,31,32,33])
                F = F + (localWeights(featureSelectionIndex(i))*f{i});  % The phases that minimize the avg observed phase length for each phase can only be used when phases were observed.
            else
                F = F + zeros(1,size(H,1));
            end
        end
    end
    H = 2*H;
elseif expertFlag == 0 && experiment == 0
    for i = 1:numel(featureSelectionIndex)
        if featureSelectionIndex(i) > 0
            H = H + (localWeights(featureSelectionIndex(i))*J{i});
            if numel(f{i}) > 1
                F = F + (localWeights(featureSelectionIndex(i))*f{i});  % The phases that minimize the avg observed phase length for each phase can only be used when phases were observed.
            else
                F = F + zeros(1,size(H,1));
            end
        end
    end
    H = 2*H;
end
x0 = zeros(xSize,1);

if experiment == 0 && expertFlag == 1
    HExpert = H;
end

[A,b,Aeq,beq,lb,ub] = cplexGenerateOCConstSet(m,n,l,t,delta,alpha,minPhaseLength,maxPhaseLength,zeroTimePhases,lInitial,simTime,agentSimTime,expertFlag);



