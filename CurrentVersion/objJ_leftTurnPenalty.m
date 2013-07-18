function [J f] = objJ_leftTurnPenalty(queueNo,dominantPhases,l,xSize,phaseSequence)

% sum(k = 1 to n) delta(k) (if delta(k) ~= 0) = x'*J*x

global leftTurnLinks;

J = zeros(xSize);
f = zeros(1,xSize);

if ismember(queueNo,leftTurnLinks)
    for i = 1:numel(dominantPhases)
        dominantPhasesIndex(i) = find(phaseSequence == dominantPhases(i));
        if dominantPhasesIndex(i) == numel(phaseSequence)
            dominantPhasesIndex(i) = 0;
        end
    end

    if queueNo == 0
        error('A queue does not seem to exist in the intersection.');
    else
        for k = 1:numel(l(queueNo,:))-1
            if ismember(mod(k,numel(phaseSequence)),dominantPhasesIndex)
                f(1,l(queueNo,k)) = 1;
                f(1,l(queueNo,k+1)) = -1;
            else
                f(1,l(queueNo,k)) = -1;
                f(1,l(queueNo,k+1)) = 1;
            end
        end
    end
end