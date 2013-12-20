function H = HExpert(x)

global expertWeights;
global noOfPhasesInACycle;
global ds;
global expertFlag;
global xExpertCombined;
persistent delta;
persistent t;
persistent l;
global featureSelection;
global maxPhases;
global maxLinks;

[noOfLinks, noOfPhasesInACycle, minPhaseLength, ...
maxPhaseLength, noOfCycles, simTime, arrivalRate,...
departureRate, lInitial, phaseSets, phaseSequence, zeroTimePhases] = unpackDataSet(ds);

m = noOfLinks;
n = noOfPhasesInACycle*noOfCycles;
nc = noOfPhasesInACycle;
cmax = noOfCycles;
weights = expertWeights;

[l,t,delta] = xIndexing(m,n);    % Index l,t and delta within the vector x

% initialize H as all zeros size(x)
H = zeros(numel(x));

% Cycle Length
H_cycleLength = zeros(numel(x));
if featureSelection(1) == 1
    for c = 1:cmax
        for p1 = 1:nc
            for p2 = 1:nc
                H_cycleLength(delta(nc*(c-1)+p1), delta(nc*(c-1)+p2)) = weights(1)*2;
            end
        end
    end
end

% Phase Variances
H_phaseVariance = zeros(numel(x),numel(x),nc);
for p = 1:nc
    if featureSelection(1+p) == 1
        for k = 1:n
            if mod(k,nc) == p || (mod(k,nc)==0 && p==nc)
                H_phaseVariance(delta(k),delta(k),p) = weights(1+p)*2*((1-1/cmax)^2+((cmax-1)*(-1/cmax)^2));
                for c = 1:cmax
                    if nc*(c-1)+p ~= k
                        H_phaseVariance(delta(k),delta(nc*(c-1)+p),p) = weights(1+p)*2*((2*(1-(1/cmax))*(-1/cmax))+((cmax-2)*((1/cmax)^2)));
                        H_phaseVariance(delta(nc*(c-1)+p),delta(k),p) = weights(1+p)*2*((2*(1-(1/cmax))*(-1/cmax))+((cmax-2)*((1/cmax)^2)));
                    end
                end
            end
        end
    end
end

% Queue Length
H_queueLength = zeros(numel(x));

% Queue Length Squared
H_queueLengthSquared = zeros(numel(x));
for i = 1:m
    if featureSelection(1+maxPhases+maxLinks+i) == 1
        for k = 1:n
            H_queueLengthSquared(l(i,k),l(i,k)) = weights(1+nc+m+i)*2;
        end
    end
end

% Delay
H_delay = zeros(numel(x));
for i = 1:m
    if featureSelection(1+maxPhases+2*maxLinks+i) == 1
        for k = 1:n-1
            H_delay(l(i,k),delta(k)) = weights(1+nc+2*m+i)*1;
            H_delay(l(i,k),delta(k+1)) = weights(1+nc+2*m+i)*1;
        end
        for k = n
            H_delay(l(i,k),delta(k)) = weights(1+nc+2*m+i)*1;
        end
        for k = 1
            H_delay(delta(k),l(i,k)) = weights(1+nc+2*m+i)*1;
        end
        for k = 2:n
            H_delay(delta(k),l(i,k-1)) = weights(1+nc+2*m+i)*1;
            H_delay(delta(k),l(i,k)) = weights(1+nc+2*m+i)*1;
        end
    end
end

H_observedPhaseError = zeros(numel(x));
for c = 1:cmax
    for p = 1:nc
        if featureSelection(1+maxPhases+3*maxLinks+p) == 1
            H(delta(nc*(c-1)+p),delta(nc*(c-1)+p)) = 2;
        end
    end
end

H = H_cycleLength + sum(H_phaseVariance,3) + H_queueLength + H_queueLengthSquared + H_delay;