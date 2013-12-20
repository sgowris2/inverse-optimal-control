function phaseSequence = deducePhaseSequence(RAW,noOfPhases)

fromStreetIndex = 7;

startingPhase = 1;

for i = 1:noOfPhases
    if mod(i,2) == 1
        phaseSequence(i) = startingPhase;
    else
        phaseSequence(i) = mod(startingPhase,2)+1;
    end
end


% for i = 1:noOfPhases
%     if mod(i,4) == 1
%         phaseSequence(i) = startingPhase;
%     elseif mod(i,4) == 2
%         phaseSequence(i) = mod(startingPhase,4)+1;
%     elseif mod(i,4) == 3
%         phaseSequence(i) = mod(startingPhase,4)+2;
%     else
%         phaseSequence(i) = mod(startingPhase,4)+3;
%     end
% end
    