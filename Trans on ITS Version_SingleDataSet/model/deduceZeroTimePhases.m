function [zeroTimePhases] = deduceZeroTimePhases(observedPhases, phaseSequence)

zeroTimePhases = zeros(0,0);
j = 1;
i = 1;
n = 1;

while j <= numel(observedPhases) || i <= numel(phaseSequence)
    if i > numel(phaseSequence)
        i = 1;
    end
    if (j <= numel(observedPhases)) && (phaseSequence(i) == observedPhases(j))        
        j = j + 1;
        n = n + 1;
        i = i + 1;
    else
        zeroTimePhases = [zeroTimePhases n];
        n = n + 1;
        i = i + 1;
    end
end