function [J] = objJ_phaseLength(phaseNo,zeroTimePhases,phaseSequence,delta,cMax,xSize)

% sum(k = 1 to n) delta(k) (if delta(k) ~= 0) = x'*J*x

J = zeros(xSize);

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
        for k2 = 1:numel(delta)
            if (mod(k1,numel(phaseSequence)) == phaseIndex) && ~ismember(k1,zeroTimePhases) > 0 ...
                    && (mod(k2,numel(phaseSequence)) == phaseIndex) && ~ismember(k2,zeroTimePhases) > 0
                    
                    J(delta(k1),delta(k2)) = -1/cMax;
            end
            if k1 == k2
                J(delta(k1),delta(k2)) = J(delta(k1),delta(k2)) + 1;
            end
        end
    end
end