function [J f g] = objJ_phaseAvgLength(phaseNo,xExpertCombined,phaseSequence,delta,xSize)

% sum(k = 1 to n) (delta(k)-avgObsdelta(k))^2 (if delta(k) ~= 0) = x'*J*x +
% f*x

J = zeros(xSize);
f = zeros(1,xSize);
g = 0;

phaseIndex = 0;
for i = 1:numel(phaseSequence)
    if phaseSequence(i) == phaseNo
        phaseIndex = i;
    end
end

totalTime = 0;
np = 0;

if phaseIndex == 0
    error('A phase does not seem to exist in the phaseSequence.');
else
    if phaseIndex == numel(phaseSequence)
        phaseIndex = 0;
    end
    for k = 1:numel(delta)
        if mod(k,numel(phaseSequence)) == phaseIndex && xExpertCombined(delta(k)) > 0
            totalTime = totalTime + xExpertCombined(delta(k));
            np = np + 1;
        end
    end
    avgDelta = totalTime/np;
    for k = 1:numel(delta)
        if mod(k,numel(phaseSequence)) == phaseIndex && xExpertCombined(delta(k)) > 0
            J(delta(k),delta(k)) = 1;
            f(1,delta(k)) = -2*avgDelta;
            g = g + avgDelta^2;
        end
    end
end