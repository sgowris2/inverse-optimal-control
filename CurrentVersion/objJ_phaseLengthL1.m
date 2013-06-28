function [J f] = objJ_phaseLengthL1(phaseNo,phaseSequence,delta,xSize)

% sum(k = 1 to n) delta(k) (if delta(k) ~= 0) = x'*J*x

J = zeros(xSize);
f = zeros(1,xSize);

phaseIndex = 0;
for i = 1:numel(phaseSequence)
    if phaseSequence(i) == phaseNo
        phaseIndex = i;
    end
end
if phaseIndex == 0
    error('A phase does not seem to exist in the phaseSequence.');
else
    if phaseIndex == numel(phaseSequence)
        phaseIndex = 0;
    end
    for k1 = 1:numel(delta)
        if mod(k1,numel(phaseSequence)) == phaseIndex
            f(1,delta(k1)) = 1;
        end
    end
end