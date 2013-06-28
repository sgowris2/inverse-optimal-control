function [avgPhaseLength] = deduceAveragePhaseLengths(dataSet, delta)

global noOfCyclesIndex;
global noOfPhasesInACycleIndex;

noOfCycles = dataSet{noOfCyclesIndex};
noOfPhasesInACycle = dataSet{noOfPhasesInACycleIndex};
avgPhaseLength = zeros(1,noOfPhasesInACycle);

for i = 1:noOfPhasesInACycle
    totalPhaseLength = 0;
    for c = 1:noOfCycles
        totalPhaseLength = totalPhaseLength + delta((c-1)*noOfPhasesInACycle + i);
    end
    avgPhaseLength(i) = totalPhaseLength/noOfCycles;
end