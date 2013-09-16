function [J] = fminconOCExpertGeneral(x)

global noOfLinks;
global noOfCycles;
global expertWeights;
global noOfPhasesInACycle;
global weightsSize;
global dataSetLoopIndex;
global agentNoOfCycles;
global delta;
global featureSelection;
global featureSelectionIndex;
global allQueuesPower;
global allPhaseLengthsPower;

m = noOfLinks;
n = noOfCycles{dataSetLoopIndex}*noOfPhasesInACycle;
    
cMax = (n/noOfPhasesInACycle);

JAllQueues = zeros(1,allQueuesPower);
for j = 1:allQueuesPower
    for i = 1:m*n
        JAllQueues(j) = JAllQueues(j) + x(i)^j;
    end
end

JAllPhaseLengths = zeros(1,allPhaseLengthsPower);
for j = 1:allPhaseLengthsPower
    for i = 1:numel(delta)
        JAllPhaseLengths(j) = JAllPhaseLengths(j) + x(delta(i))^j;
    end
end

weightsIndex = 1;
J = 0;
for i = 1:numel(JAllQueues)
    J = J + expertWeights(weightsIndex)*(JAllQueues(i));
    weightsIndex = weightsIndex + 1;
end
for i = 1:numel(JAllPhaseLengths)
    J = J + expertWeights(weightsIndex)*(JAllPhaseLengths(i));
    weightsIndex = weightsIndex + 1;
end

