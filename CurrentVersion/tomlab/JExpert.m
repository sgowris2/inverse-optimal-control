function [JExpert] = JExpert(x)

persistent l;       % indexed by (link#, phase#)
persistent t;       % indexed by (phase#)    
persistent delta;   % indexed by (phase#)
global ds;
global expertWeights;
global phaseSequence;
global noOfPhasesInACycle;
global expertFlag;
global xExpertCombined;
global featureSelection;
global maxPhases;
global maxLinks;

[noOfLinks, noOfPhasesInACycle, minPhaseLength, ...
maxPhaseLength, noOfCycles, simTime, arrivalRate,...
departureRate, lInitial, phaseSets, phaseSequence, zeroTimePhases] = unpackDataSet(ds);

m = noOfLinks;
n = noOfPhasesInACycle*noOfCycles;
cmax = noOfCycles;

%alpha = createAlpha(m, noOfPhasesInACycle, arrivalRate, departureRate, phaseSets, noOfCycles, phaseSequence);

[l,t,delta] = xIndexing(m,n);    % Index l,t and delta within the vector x
%xSize = numel(l) + numel(t) + numel(delta);

% CycleLength

if featureSelection(1) == 1
    cycleTemp = 0;
    for c = 1:cmax
        temp = 0;
        for p = 1:noOfPhasesInACycle
            temp = temp + x(delta(noOfPhasesInACycle*(c-1)+p));
        end
        cycleTemp = cycleTemp + temp^2;
    end
    j(1) = cycleTemp;
    jSizeTemp = numel(j);
end

% Phase Variance
for p = 1:noOfPhasesInACycle
    if featureSelection(1+p) == 1
        temp = 0;
        for c2 = 1:cmax
            temp = temp + x(delta((noOfPhasesInACycle*(c2-1))+p));
        end
        deltaPBar = temp*(1/cmax);

        j(p+jSizeTemp) = 0;
        for c = 1:cmax
            j(p+jSizeTemp) = j(p+jSizeTemp) + (x(delta(noOfPhasesInACycle*(c-1)+p)) - deltaPBar)^2;
        end
    end
end
jSizeTemp = numel(j);

% QueueLength
for i = 1:m
    if featureSelection(1+maxPhases+i) == 1
        j(i+jSizeTemp) = 0;
        for k = 1:n
            j(i+jSizeTemp) = j(i+jSizeTemp) + x(l(i,k));
        end
    end
end
jSizeTemp = numel(j);

% QueueLength^2
for i = 1:m
    if featureSelection(1+maxPhases+maxLinks+i) == 1
        j(i+jSizeTemp) = 0;
        for k = 1:n
            j(i+jSizeTemp) = j(i+jSizeTemp) + x(l(i,k))^2;
        end
    end
end
jSizeTemp = numel(j);

% Delay
for i = 1:m
    if featureSelection(1+maxPhases+2*maxLinks+i) == 1
        j(i+jSizeTemp) = 0;
        for k = 1
            j(i+jSizeTemp) = j(i+jSizeTemp) + (x(delta(k))*(lInitial(i) + x(l(i,k))));
        end
        for k = 2:n
            j(i+jSizeTemp) = j(i+jSizeTemp) + (x(delta(k))*(x(l(i,k-1)) + x(l(i,k))));
        end
    end
end
jSizeTemp = numel(j);

% PhaseLength Error
for p = 1:noOfPhasesInACycle
    if featureSelection(1+maxPhases+3*maxLinks+p) == 1
        j(p+jSizeTemp) = 0;
    end
end

JExpert = sum(expertWeights .* j);