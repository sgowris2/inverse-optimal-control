function newPhase = intersectionLogicSemiAdaptive(currentCyclePhase, currentQueues, currentPhaseLength,maxPhaseLengths,minPhaseLengths)

mandatoryPhaseChange = 0;

if currentPhaseLength < minPhaseLengths(currentCyclePhase)
    newPhase = currentCyclePhase;
    return;
end

if currentPhaseLength >= maxPhaseLengths(currentCyclePhase)
    mandatoryPhaseChange = 1;
end

if currentPhaseLength >= minPhaseLengths(currentCyclePhase) && currentPhaseLength < maxPhaseLengths(currentCyclePhase)
    optionalPhaseChange = 1;
else
    optionalPhaseChange = 0;
end

if mandatoryPhaseChange == 1
    if currentCyclePhase == 1
        newPhase = 2;
    else
        newPhase = 1;
    end
    return;
end
if optionalPhaseChange == 1
    switch currentCyclePhase
        case 1            
                if currentQueues(1) > 0 || currentQueues(2) > 0
                    newPhase = 1;
                else
                    if currentQueues(3) > 0 || currentQueues(4) > 0
                        newPhase = 2;
                    end
                end
                return;
  
        case 2
                if currentQueues(3) > 0 || currentQueues(4) > 0
                    newPhase = 2;
                else
                    if currentQueues(1) > 0 || currentQueues(2) > 0
                        newPhase = 1;
                    end
                end
                return;
    end
end