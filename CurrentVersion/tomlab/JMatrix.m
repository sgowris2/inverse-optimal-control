function g = JMatrix(x)

global noOfPhasesInACycle;
global ds;
global xExpertCombined;
persistent delta;
persistent t;
persistent l;
global featureSelection;
global maxPhases;
global maxLinks;

weightsSize = sum(featureSelection);

[noOfLinks, noOfPhasesInACycle, minPhaseLength, ...
maxPhaseLength, noOfCycles, simTime, arrivalRate,...
departureRate, lInitial, phaseSets, phaseSequence, zeroTimePhases] = unpackDataSet(ds);

m = noOfLinks;
n = noOfPhasesInACycle*noOfCycles;
nc = noOfPhasesInACycle;
cmax = noOfCycles;

% initialize size of g to all zeros
g = zeros(weightsSize,numel(xExpertCombined));
g_cycleLength = zeros(size(xExpertCombined));
g_phaseVariance = zeros(size(xExpertCombined,1),nc);
g_queueLength = zeros(size(xExpertCombined));
g_queueLengthSquared = zeros(size(xExpertCombined));
g_delay = zeros(size(xExpertCombined));
g_observedPhaseError = zeros(size(x,1),nc);

% xIndexing
[l,t,delta] = xIndexing(m,n);    % Index l,t and delta within the vector x

% Cycle length
if featureSelection(1) == 1
    c = 1;
    cycleLength = zeros(1,cmax);
    for k = 1:n
        cycleLength(c) = cycleLength(c) + x(delta(k));
        if mod(k,nc) == 0
            c = c+1;
        end
    end
    c = 1;
    for k = 1:n
        g_cycleLength(delta(k)) = 2*cycleLength(c);
        if mod(k,nc) == 0
            c = c+1;
        end
    end
end

% Phase lengths variances
for p = 1:nc
    temp = 0;
    for c2 = 1:cmax
        temp = temp + x(delta((nc*(c2-1))+p));
    end
    deltaBar(p) = temp*(1/cmax);
end
for p = 1:nc
    if featureSelection(1+p) == 1
        for k = 1:n
            if mod(k,nc) == p || (mod(k,nc) == 0 && p == nc)
                g_phaseVariance(delta(k),p) = 2*(1-1/cmax)*(x(delta(k)) - (1/cmax)*(deltaBar(p)));
                for k2 = 1:n
                    if (mod(k2,nc) == p || (mod(k2,nc) == 0 && p == nc)) && k2 ~= k
                        g_phaseVariance(delta(k),p) = g_phaseVariance(delta(k),p) + 2*(-1/cmax)*(x(delta(k2))-(1/cmax)*(deltaBar(p)));
                    end
                end
            end
        end
    end
end

% QueueLength
for i = 1:m
    if featureSelection(1+maxPhases+i) == 1
        for k = 1:n
            g_queueLength(l(i,k),i) = 1;
        end
    end
end

% QueueLength^2
for i = 1:m
    if featureSelection(1+maxPhases+maxLinks+i) == 1
        for k = 1:n
            g_queueLengthSquared(l(i,k),i) = 2*x(l(i,k));
        end
    end
end

% Delay
for i = 1:m
    if featureSelection(1+maxPhases+2*maxLinks+i) == 1
        for k = 1:n-1
            g_delay(l(i,k),i) = (x(delta(k)) + x(delta(k+1)));
        end
        for k = n
            g_delay(l(i,k),i) = x(delta(k));
        end
    end
end


for k = 2:n
    for i = 1:m
        if featureSelection(1+maxPhases+2*maxLinks+i) == 1
            g_delay(delta(k),i) = g_delay(delta(k),i) + (x(l(i,k-1)) + x(l(i,k)));
        end
    end
end
for k = 1
    for i = 1:m
        if featureSelection(1+maxPhases+2*maxLinks+i) == 1
            g_delay(delta(k),i) = g_delay(delta(k),i) + (lInitial(i) + x(l(i,k)));
        end
    end
end

% Observed Phase Length Error
deltaPBarObserved = zeros(noOfPhasesInACycle,1);
for p = 1:noOfPhasesInACycle
    for c2 = 1:cmax
        deltaPBarObserved(p) = deltaPBarObserved(p) + xExpertCombined(delta(noOfPhasesInACycle*(c2-1)+p));
    end
    deltaPBarObserved(p) = deltaPBarObserved(p)/cmax;
end

for k = 1:n
    p = mod(p,noOfPhasesInACycle);
    if p == 0
        p = 2;
    end
    if featureSelection(1+maxPhases+3*maxLinks+p) == 1
        g_observedPhaseError(delta(k),p) = 2*(x(delta(k)) - deltaPBarObserved(p));
    end
end

g = g_cycleLength';
for p = 1:nc
    g = [g;g_phaseVariance(:,p)'];
end
for i = 1:m
    g = [g;g_queueLength(:,i)'];
end
for i = 1:m
    g = [g;g_queueLengthSquared(:,i)'];
end
for i = 1:m
    g = [g;g_delay(:,i)'];
end
for p=1:nc
    g = [g;g_observedPhaseError(:,p)'];
end



% % Compute average phase length of each traffic signal phase
% for p = 1:nc
%     temp = 0;
%     for c2 = 1:cmax
%         temp = temp + x(delta((nc*(c2-1))+p));
%     end
%     deltaBar(p) = temp*(1/cmax);
% end
% 
% %Compute average observed phase length of each traffic signal phase
% for p2 = 1:noOfPhasesInACycle
%     deltaBarObserved(p2) = 0;
%     for c2 = 1:cmax
%         deltaBarObserved(p2) = deltaBarObserved(p2) + xExpertCombined(delta(noOfPhasesInACycle*(c2-1)+p2));
%     end
%     deltaBarObserved(p2) = deltaBarObserved(p2)/cmax;
% end



% for k = 1:n
%     for c = 1:cmax
%         if k <= c*nc
%             break;
%         end
%     end
%     p = k-(c-1)*nc;
%     g(1,delta(k)) = 2*(sum (x(delta((nc*(c-1))+1:(nc*(c))))) );
%     g(1+p,delta(k)) = g(1+p,delta(k)) + 2*(1-(1/cmax))*(x(delta(k))-deltaBar(p));
%     %g(1+nc+3*m+p,delta(k)) = g(1+nc+3*m+p,delta(k)) + 2*(x(delta(k))-deltaBarObserved(p));
%     for i = 1:m
%         g(i+(1+nc),l(i,k)) = 1;
%         g(i+(1+nc+m),l(i,k)) = 2*x(l(i,k));
%     end    
% end
% 
% for i = 1:m
%     for k = 1
%         g(i+(1+nc+2*m),l(i,k)) = (x(delta(k))) + (x(lInitial(i))-x(l(i,k)));
%     end
%     for k = 2:n
%         g(i+(1+nc+2*m),l(i,k)) = (x(delta(k))+x(delta(k-1))) + (x(l(i,k-1))-x(l(i,k)));
%     end
% end


