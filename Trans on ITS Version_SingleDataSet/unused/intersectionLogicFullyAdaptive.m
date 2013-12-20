function newPhase = intersectionLogicFullyAdaptive(currentCyclePhase, currentQueues, currentPhaseLength,maxPhaseLengths,minPhaseLengths)

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

if mandatoryPhaseChange == 1 || optionalPhaseChange == 1
    switch currentCyclePhase
        case 1            
                if currentQueues(6) >= 1 && currentQueues(8) >= 1
                    newPhase = 4;
                elseif currentQueues(6) >= 1
                    newPhase = 7;
                elseif currentQueues(8) >= 1
                    newPhase = 8;
                else
                    if mandatoryPhaseChange == 1
                        newPhase = 2;
                    else
                        newPhase = 1;
                    end
                end
                return;
  
        case 2
                if currentQueues(2) >= 1 && currentQueues(4) >= 1
                    newPhase = 3;
                elseif currentQueues(2) >= 1
                    newPhase = 5;
                elseif currentQueues(4) >= 1
                    newPhase = 6;
                else
                    if mandatoryPhaseChange == 1
                        newPhase = 1;
                    else
                        newPhase = 2;
                    end
                end
                return;
    
        case 3
            newPhase = 1;
            return;
        case 4
            newPhase = 2;
            return;
        case 5
            newPhase = 1;
            return;
        case 6
            newPhase = 1;
            return;
        case 7
            newPhase = 2;
            return;
        case 8
            newPhase = 2;
            return;
    end
end