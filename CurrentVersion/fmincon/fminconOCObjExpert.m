function [J] = fminconOCObjExpert(x)

global noOfLinks;
global noOfCycles;
global weights;
global noOfPhasesInACycle;
global weightsSize;
global dataSetLoopIndex;
global agentNoOfCycles;
global delta;
global featureSelection;
global featureSelectionIndex;
global maxPhaseLength;
global avgPhaseLength;

m = noOfLinks;
n = noOfCycles{dataSetLoopIndex}*noOfPhasesInACycle;
    
cMax = (n/noOfPhasesInACycle);

J1 = 0;
for i = 1:m*n
    J1 = J1 + x(i)^2;
end

J2 = 0;
if weightsSize >= 2 && featureSelection(2)==1
    for c = 1:cMax
        cycleLength = 0;
        for j = 1:noOfPhasesInACycle
            cycleLength = cycleLength + x((m*n + n) + (c-1)*(noOfPhasesInACycle) + j);
        end
        J2 = J2 + (cycleLength)^2;
    end
end

JLink1 = 0;
if featureSelection(3)==1
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 1
            JLink1 = JLink1 + x(i)^2;
        end
    end
end

JLink2 = 0;
if featureSelection(4)==1 && noOfLinks >= 2
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 2 || (noOfPhasesInACycle == 2 && mod(i,noOfPhasesInACycle) == 0)
            JLink2 = JLink2 + x(i)^2;
        end
    end
end

JLink3 = 0;
if featureSelection(5)==1 && noOfLinks >= 3
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 3 || (noOfPhasesInACycle == 3 && mod(i,noOfPhasesInACycle) == 0)
            JLink3 = JLink3 + x(i)^2;
        end
    end
end

JLink4 = 0;
if featureSelection(6)==1 && noOfLinks >= 4
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 4 || (noOfPhasesInACycle == 4 && mod(i,noOfPhasesInACycle) == 0)
            JLink4 = JLink4 + x(i)^2;
        end
    end
end

JLink5 = 0;
if featureSelection(7)==1 && noOfLinks >= 5
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 5 || (noOfPhasesInACycle == 5 && mod(i,noOfPhasesInACycle) == 0)
            JLink5 = JLink5 + x(i)^2;
        end
    end
end

JLink6 = 0;
if featureSelection(8)==1 && noOfLinks >= 6
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 6 || (noOfPhasesInACycle == 6 && mod(i,noOfPhasesInACycle) == 0)
            JLink6 = JLink6 + x(i)^2;
        end
    end
end

JLink7 = 0;
if featureSelection(9)==1 && noOfLinks >= 7
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 7 || (noOfPhasesInACycle == 7 && mod(i,noOfPhasesInACycle) == 0)
            JLink7 = JLink7 + x(i)^2;
        end
    end
end

JLink8 = 0;
if featureSelection(10)==1 && noOfLinks >= 8
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 8 || (noOfPhasesInACycle == 8 && mod(i,noOfPhasesInACycle) == 0)
            JLink8 = JLink8 + x(i)^2;
        end
    end
end

JPhase1 = 0;
if  featureSelection(11)==1
    j = 1;
    AverageJthPhaseLength = 0;
    for c2 = 1:cMax
        AverageJthPhaseLength = AverageJthPhaseLength + x(delta(noOfPhasesInACycle*(c2-1)+j));    
    end
    AvergeJthPhaseLength = AverageJthPhaseLength/cMax;
    for c1 = 1:cMax
        JPhase1 = JPhase1 + (x(delta(noOfPhasesInACycle*(c1-1)+j))-AvergeJthPhaseLength)^2;
    end
end

JPhase2 = 0;
if featureSelection(12)==1 && noOfPhasesInACycle >= 2
    j = 2;
    AverageJthPhaseLength = 0;
    for c2 = 1:cMax
        AverageJthPhaseLength = AverageJthPhaseLength + x(delta(noOfPhasesInACycle*(c2-1)+j));    
    end
    AvergeJthPhaseLength = AverageJthPhaseLength/cMax;
    for c1 = 1:cMax
        JPhase2 = JPhase2 + (x(delta(noOfPhasesInACycle*(c1-1)+j))-AvergeJthPhaseLength)^2;
    end
end

JPhase3 = 0;
if featureSelection(13)==1 && noOfPhasesInACycle >= 3
    j = 3;
    AverageJthPhaseLength = 0;
    for c2 = 1:cMax
        AverageJthPhaseLength = AverageJthPhaseLength + x(delta(noOfPhasesInACycle*(c2-1)+j));    
    end
    AvergeJthPhaseLength = AverageJthPhaseLength/cMax;
    for c1 = 1:cMax
        JPhase3 = JPhase3 + (x(delta(noOfPhasesInACycle*(c1-1)+j))-AvergeJthPhaseLength)^2;
    end
end

JPhase4 = 0;
if featureSelection(14)==1 && noOfPhasesInACycle >= 4
    j = 4;
    AverageJthPhaseLength = 0;
    for c2 = 1:cMax
        AverageJthPhaseLength = AverageJthPhaseLength + x(delta(noOfPhasesInACycle*(c2-1)+j));    
    end
    AvergeJthPhaseLength = AverageJthPhaseLength/cMax;
    for c1 = 1:cMax
        JPhase4 = JPhase4 + (x(delta(noOfPhasesInACycle*(c1-1)+j))-AvergeJthPhaseLength)^2;
    end
end

JPhase5 = 0;
if featureSelection(15)==1 && noOfPhasesInACycle >= 5
    j = 5;
    AverageJthPhaseLength = 0;
    for c2 = 1:cMax
        AverageJthPhaseLength = AverageJthPhaseLength + x(delta(noOfPhasesInACycle*(c2-1)+j));    
    end
    AvergeJthPhaseLength = AverageJthPhaseLength/cMax;
    for c1 = 1:cMax
        JPhase5 = JPhase5 + (x(delta(noOfPhasesInACycle*(c1-1)+j))-AvergeJthPhaseLength)^2;
    end
end

JPhase6 = 0;
if featureSelection(16)==1 && noOfPhasesInACycle >= 6
    j = 6;
    AverageJthPhaseLength = 0;
    for c2 = 1:cMax
        AverageJthPhaseLength = AverageJthPhaseLength + x(delta(noOfPhasesInACycle*(c2-1)+j));    
    end
    AvergeJthPhaseLength = AverageJthPhaseLength/cMax;
    for c1 = 1:cMax
        JPhase6 = JPhase6 + (x(delta(noOfPhasesInACycle*(c1-1)+j))-AvergeJthPhaseLength)^2;
    end
end

JPhase7 = 0;
if featureSelection(17)==1 && noOfPhasesInACycle >= 7
    j = 7;
    AverageJthPhaseLength = 0;
    for c2 = 1:cMax
        AverageJthPhaseLength = AverageJthPhaseLength + x(delta(noOfPhasesInACycle*(c2-1)+j));    
    end
    AvergeJthPhaseLength = AverageJthPhaseLength/cMax;
    for c1 = 1:cMax
        JPhase7 = JPhase7 + (x(delta(noOfPhasesInACycle*(c1-1)+j))-AvergeJthPhaseLength)^2;
    end
end

JPhase8 = 0;
if featureSelection(18)==1 && noOfPhasesInACycle >= 8
    j = 8;
    AverageJthPhaseLength = 0;
    for c2 = 1:cMax
        AverageJthPhaseLength = AverageJthPhaseLength + x(delta(noOfPhasesInACycle*(c2-1)+j));    
    end
    AvergeJthPhaseLength = AverageJthPhaseLength/cMax;
    for c1 = 1:cMax
        JPhase8 = JPhase8 + (x(delta(noOfPhasesInACycle*(c1-1)+j))-AvergeJthPhaseLength)^2;
    end
end

JLink1Sensor = 0;
if featureSelection(19)==1 && noOfLinks >= 1
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 1 || (noOfPhasesInACycle == 1 && mod(i,noOfPhasesInACycle) == 0)
            if x(i) >= 1
                JLink1Sensor = JLink1Sensor + 100*x(i)^2;
            else
            end    
        end
    end
end

JLink2Sensor = 0;
if featureSelection(20)==1 && noOfLinks >= 2
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 2 || (noOfPhasesInACycle == 2 && mod(i,noOfPhasesInACycle) == 0)
            if x(i) >= 1
                JLink2Sensor = JLink2Sensor + 100*x(i)^2;
            else
            end    
        end
    end
end

JLink3Sensor = 0;
if featureSelection(21)==1 && noOfLinks >= 3
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 3 || (noOfPhasesInACycle == 3 && mod(i,noOfPhasesInACycle) == 0)
            if x(i) >= 1
                JLink3Sensor = JLink3Sensor + 100*x(i)^2;
            else
            end    
        end
    end
end

JLink4Sensor = 0;
if featureSelection(22)==1 && noOfLinks >= 4
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 4 || (noOfPhasesInACycle == 4 && mod(i,noOfPhasesInACycle) == 0)
            if x(i) >= 1
                JLink4Sensor = JLink4Sensor + 100*x(i)^2;
            else
            end    
        end
    end
end

JLink5Sensor = 0;
if featureSelection(23)==1 && noOfLinks >= 5
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 5 || (noOfPhasesInACycle == 5 && mod(i,noOfPhasesInACycle) == 0)
            if x(i) >= 1
                JLink5Sensor = JLink5Sensor + 100*x(i)^2;
            else
            end    
        end
    end
end

JLink6Sensor = 0;
if featureSelection(24)==1 && noOfLinks >= 6
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 6 || (noOfPhasesInACycle == 6 && mod(i,noOfPhasesInACycle) == 0)
            if x(i) >= 1
                JLink6Sensor = JLink6Sensor + 100*x(i)^2;
            else
            end    
        end
    end
end

JLink7Sensor = 0;
if featureSelection(25)==1 && noOfLinks >= 7
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 7 || (noOfPhasesInACycle == 7 && mod(i,noOfPhasesInACycle) == 0)
            if x(i) >= 1
                JLink7Sensor = JLink7Sensor + 100*x(i)^2;
            else
            end    
        end
    end
end

JLink8Sensor = 0;
if featureSelection(26)==1 && noOfLinks >= 8
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 8 || (noOfPhasesInACycle == 8 && mod(i,noOfPhasesInACycle) == 0)
            if x(i) >= 1
                JLink8Sensor = JLink8Sensor + 100*x(i)^2;
            else
            end    
        end
    end
end

JLink1ConvexSensor = 0;
if featureSelection(27) == 1 && noOfLinks >= 1
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 1 || (noOfPhasesInACycle == 1 && mod(i,noOfPhasesInACycle) == 0)
            JLink1ConvexSensor = JLink1ConvexSensor + x(i)^5;
        end
    end
end

JLink2ConvexSensor = 0;
if featureSelection(28) == 1 && noOfLinks >= 2
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 2 || (noOfPhasesInACycle == 2 && mod(i,noOfPhasesInACycle) == 0)
            JLink2ConvexSensor = JLink2ConvexSensor + x(i)^5;
        end
    end
end

JLink3ConvexSensor = 0;
if featureSelection(29) == 1 && noOfLinks >= 3
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 3 || (noOfPhasesInACycle == 3 && mod(i,noOfPhasesInACycle) == 0)
            JLink3ConvexSensor = JLink3ConvexSensor + x(i)^5;
        end
    end
end

JLink4ConvexSensor = 0;
if featureSelection(30) == 1 && noOfLinks >= 4
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 4 || (noOfPhasesInACycle == 4 && mod(i,noOfPhasesInACycle) == 0)
            JLink4ConvexSensor = JLink4ConvexSensor + x(i)^5;
        end
    end
end

JLink5ConvexSensor = 0;
if featureSelection(31) == 1 && noOfLinks >= 5
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 5 || (noOfPhasesInACycle == 5 && mod(i,noOfPhasesInACycle) == 0)
            JLink5ConvexSensor = JLink5ConvexSensor + x(i)^5;
        end
    end
end

JLink6ConvexSensor = 0;
if featureSelection(32) == 1 && noOfLinks >= 6
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 6 || (noOfPhasesInACycle == 6 && mod(i,noOfPhasesInACycle) == 0)
            JLink6ConvexSensor = JLink6ConvexSensor + x(i)^5;
        end
    end
end

JLink7ConvexSensor = 0;
if featureSelection(33) == 1 && noOfLinks >= 7
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 7 || (noOfPhasesInACycle == 7 && mod(i,noOfPhasesInACycle) == 0)
            JLink7ConvexSensor = JLink7ConvexSensor + x(i)^5;
        end
    end
end

JLink8ConvexSensor = 0;
if featureSelection(34) == 1 && noOfLinks >= 8
    for i = 1:m*n
        if mod(i,noOfPhasesInACycle) == 8 || (noOfPhasesInACycle == 8 && mod(i,noOfPhasesInACycle) == 0)
            JLink8ConvexSensor = JLink8ConvexSensor + x(i)^5;
        end
    end
end

JPhase1Length = 0;
if featureSelection(35) == 1 && noOfPhasesInACycle >= 1
    j = 1;
    for c = 1:cMax
        d = x(delta(noOfPhasesInACycle*(c-1)+j)) - avgPhaseLength{dataSetLoopIndex}(j);
        JPhase1Length = JPhase1Length + d^2;
    end    
end

JPhase2Length = 0;
if featureSelection(36) == 1 && noOfPhasesInACycle >= 2
    j = 1;
    for c = 1:cMax
        d = x(delta(noOfPhasesInACycle*(c-1)+j)) - avgPhaseLength{dataSetLoopIndex}(j);
        JPhase2Length = JPhase2Length + d^2;
    end    
end


% JPhase1Length = 0;
% if featureSelection(35) == 1 && noOfPhasesInACycle >= 1
%     w = weights(featureSelectionIndex(35));
%     j = 1;
%     for c = 1:cMax
%         d = x(delta(noOfPhasesInACycle*(c-1)+j));
%         JPhase1Length = JPhase1Length + d^2 + (maxPhaseLength*w)^2 - (2*maxPhaseLength*w*d);
%     end    
% end

% JPhase2Length = 0;
% if featureSelection(36) == 1 && noOfPhasesInACycle >= 2
%     w = weights(featureSelectionIndex(36));
%     j = 2;
%     for c = 1:cMax
%         d = x(delta(noOfPhasesInACycle*(c-1)+j));
%         JPhase2Length = JPhase2Length + d^2 + (maxPhaseLength*w)^2 - (2*maxPhaseLength*w*d);
%     end    
% end

J = 0;
if featureSelectionIndex(1) ~= 0
   J = J + expertWeights(featureSelectionIndex(1))*J1/1000; 
end
if featureSelectionIndex(2) ~= 0
   J = J + expertWeights(featureSelectionIndex(2))*J2; 
end
if featureSelectionIndex(3) ~= 0
    J = J + expertWeights(featureSelectionIndex(3))*JLink1;
end
if featureSelectionIndex(4) ~= 0
    J = J + expertWeights(featureSelectionIndex(4))*JLink2;
end
if featureSelectionIndex(5) ~= 0
    J = J + expertWeights(featureSelectionIndex(5))*JLink3;
end
if featureSelectionIndex(6) ~= 0
    J = J + expertWeights(featureSelectionIndex(6))*JLink4;
end
if featureSelectionIndex(7) ~= 0
    J = J + expertWeights(featureSelectionIndex(7))*JLink5;
end
if featureSelectionIndex(8) ~= 0
    J = J + expertWeights(featureSelectionIndex(8))*JLink6;
end
if featureSelectionIndex(9) ~= 0
    J = J + expertWeights(featureSelectionIndex(9))*JLink7;
end
if featureSelectionIndex(10) ~= 0
    J = J + expertWeights(featureSelectionIndex(10))*JLink8;
end
if featureSelectionIndex(11) ~= 0
    J = J + expertWeights(featureSelectionIndex(11))*JPhase1/50;
end
if featureSelectionIndex(12) ~= 0
    J = J + expertWeights(featureSelectionIndex(12))*JPhase2;
end
if featureSelectionIndex(13) ~= 0
    J = J + expertWeights(featureSelectionIndex(13))*JPhase3;
end
if featureSelectionIndex(14) ~= 0
    J = J + expertWeights(featureSelectionIndex(14))*JPhase4;
end
if featureSelectionIndex(15) ~= 0
    J = J + expertWeights(featureSelectionIndex(15))*JPhase5;
end
if featureSelectionIndex(16) ~= 0
    J = J + expertWeights(featureSelectionIndex(16))*JPhase6;
end
if featureSelectionIndex(17) ~= 0
    J = J + expertWeights(featureSelectionIndex(17))*JPhase7;
end
if featureSelectionIndex(18) ~= 0
    J = J + expertWeights(featureSelectionIndex(18))*JPhase8;
end
if featureSelectionIndex(19) ~= 0
    J = J + expertWeights(featureSelectionIndex(19))*JLink1Sensor;
end
if featureSelectionIndex(20) ~= 0
    J = J + expertWeights(featureSelectionIndex(20))*JLink2Sensor;
end
if featureSelectionIndex(21) ~= 0
    J = J + expertWeights(featureSelectionIndex(21))*JLink3Sensor;
end
if featureSelectionIndex(22) ~= 0
    J = J + expertWeights(featureSelectionIndex(22))*JLink4Sensor;
end
if featureSelectionIndex(23) ~= 0
    J = J + expertWeights(featureSelectionIndex(23))*JLink5Sensor;
end
if featureSelectionIndex(24) ~= 0
    J = J + expertWeights(featureSelectionIndex(24))*JLink6Sensor;
end
if featureSelectionIndex(25) ~= 0
    J = J + expertWeights(featureSelectionIndex(25))*JLink7Sensor;
end
if featureSelectionIndex(26) ~= 0
    J = J + expertWeights(featureSelectionIndex(26))*JLink8Sensor;
end
if featureSelectionIndex(27) ~= 0
    J = J + expertWeights(featureSelectionIndex(27))*JLink1ConvexSensor;
end
if featureSelectionIndex(28) ~= 0
    J = J + expertWeights(featureSelectionIndex(28))*JLink2ConvexSensor;
end
if featureSelectionIndex(29) ~= 0
    J = J + expertWeights(featureSelectionIndex(29))*JLink3ConvexSensor;
end
if featureSelectionIndex(30) ~= 0
    J = J + expertWeights(featureSelectionIndex(30))*JLink4ConvexSensor;
end
if featureSelectionIndex(31) ~= 0
    J = J + expertWeights(featureSelectionIndex(31))*JLink5ConvexSensor;
end
if featureSelectionIndex(32) ~= 0
    J = J + expertWeights(featureSelectionIndex(32))*JLink6ConvexSensor;
end
if featureSelectionIndex(33) ~= 0
    J = J + expertWeights(featureSelectionIndex(33))*JLink7ConvexSensor;
end
if featureSelectionIndex(34) ~= 0
    J = J + expertWeights(featureSelectionIndex(34))*JLink8ConvexSensor;
end
if featureSelectionIndex(35) ~= 0
    J = J + weights(featureSelectionIndex(35))*JPhase1Length;
    %/(10^2.5)
end
if featureSelectionIndex(36) ~= 0
    J = J + weights(featureSelectionIndex(36))*JPhase2Length;
    %/(10^2.5)
end