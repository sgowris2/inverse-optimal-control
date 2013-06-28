function [R] = fminconIOCObj(x)

global A;
global Aeq;
global b;
global xExpertCombined;
global noOfLinks;
global noOfPhasesInACycle;
global weightsSize;
global noOfDataSets;
global featureSelection;
global featureSelectionIndex;
global noOfCycles;
global numberOfIterations;
global maxPhaseLength;
global avgPhaseLength;
persistent eSpeed;
persistent t1;
persistent objectiveArray;
persistent objectiveSlope;
persistent objectiveSlopeLocal;

iMax = noOfLinks;
d = noOfDataSets;
for i = 1:d
    cMax(i) = noOfCycles{i};
    n{i} = noOfCycles{i}*noOfPhasesInACycle;
end
lambdaSize = size(A,1);
nuSize = size(Aeq,1);

for i = 1:weightsSize
    localWeights(i) = x(i);
end

lambda(:,1) = x(numel(localWeights)+1 : lambdaSize + numel(localWeights), 1); % Number of inequality constraints - size(lambda)
nu(:,1) = x(lambdaSize+numel(localWeights)+1 : lambdaSize+numel(localWeights)+nuSize); % Number of equality constraints = size(nu)

l = zeros(d,max(n{:}),iMax);
t = zeros(d,max(n{:}));
delta = zeros(d,max(n{:}));

xLoc = 1;
for i = 1:d
    for j = 1:n{i}
        for k = 1:iMax
            l(i,j,k) = xLoc;
            xLoc = xLoc + 1;
        end
    end
    for j = 1:n{i}
        t(i,j) = xLoc;
        xLoc = xLoc + 1;
    end
    for j = 1:n{i}
        delta(i,j) = xLoc;
        xLoc = xLoc + 1;
    end
end


% First feature is x'*J1*x = sum of queue lengths squared
J1 = zeros(size(xExpertCombined,1));
if featureSelection(1)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0
                    J1(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(1));
                end
            end
        end
    end
end
J1 = J1/100;

% Third feature is x'*J2*x = sum of cycle lengths squared
J2 = zeros(size(xExpertCombined,1));
if weightsSize >= 2 && featureSelection(2)==1
    for h = 1:d
        for i = 1:cMax
            for j = 1:noOfPhasesInACycle
                for k = 1:noOfPhasesInACycle
                    J2(delta(h,(i-1)*noOfPhasesInACycle+j),delta(h,(i-1)*noOfPhasesInACycle+k))...
                        = localWeights(featureSelectionIndex(2));
                end
            end
        end
    end
end
J2=J2/1000;

JLink1 = zeros(size(xExpertCombined,1));
if featureSelection(3)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfLinks) == 1 || (noOfLinks == 1 && mod(k,noOfLinks) == 0))
                    JLink1(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(3));
                end
            end
        end
    end
end

JLink2 = zeros(size(xExpertCombined,1));
if featureSelection(4)==1 && noOfLinks >= 2
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfLinks) == 2 || (noOfLinks == 2 && mod(k,noOfLinks) == 0))
                    JLink2(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(4));
                end
            end
        end
    end
end

JLink3 = zeros(size(xExpertCombined,1));
if featureSelection(5)==1 && noOfLinks >= 3
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfLinks) == 3 || (noOfLinks == 3 && mod(k,noOfLinks) == 0))
                    JLink3(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(5));
                end
            end
        end
    end
end

JLink4 = zeros(size(xExpertCombined,1));
if featureSelection(6)==1 && noOfLinks >= 4
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfLinks) == 4 || (noOfLinks == 4 && mod(k,noOfLinks) == 0))
                    JLink4(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(6));
                end
            end
        end
    end
end

JLink5 = zeros(size(xExpertCombined,1));
if featureSelection(7)==1 && noOfLinks >= 5
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfLinks) == 5 || (noOfLinks == 5 && mod(k,noOfLinks) == 0))
                    JLink5(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(7));
                end
            end
        end
    end
end

JLink6 = zeros(size(xExpertCombined,1));
if featureSelection(8)==1 && noOfLinks >= 6
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfLinks) == 6 || (noOfLinks == 6 && mod(k,noOfLinks) == 0))
                    JLink6(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(8));
                end
            end
        end
    end
end

JLink7 = zeros(size(xExpertCombined,1));
if featureSelection(9)==1 && noOfLinks >= 7
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfLinks) == 7 || (noOfLinks == 7 && mod(k,noOfLinks) == 0))
                    JLink7(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(9));
                end
            end
        end
    end
end

JLink8 = zeros(size(xExpertCombined,1));
if featureSelection(10)==1 && noOfLinks >= 8
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfLinks) == 8 || (noOfLinks == 8 && mod(k,noOfLinks) == 0))
                    JLink8(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(10));
                end
            end
        end
    end
end

JPhase1 = zeros(size(xExpertCombined,1));
fPhase1 = zeros(1,size(xExpertCombined,1));
if featureSelection(11)==1
    j=1;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase1(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(11));
            fPhase1(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(11));
        end
    end
end
JPhase1 = JPhase1/10000;

JPhase2 = zeros(size(xExpertCombined,1));
fPhase2 = zeros(1,size(xExpertCombined,1));
if featureSelection(12)==1 && noOfPhasesInACycle >= 2
    j=2;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase2(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(12));
            fPhase2(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(12));
        end
    end
end
JPhase2 = JPhase2/10000;

JPhase3 = zeros(size(xExpertCombined,1));
fPhase3 = zeros(1,size(xExpertCombined,1));
if featureSelection(13)==1 && noOfPhasesInACycle >= 3
    j=3;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase3(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(13));
            fPhase3(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(13));
        end
    end
end
%JPhase3 = JPhase3/1000;

JPhase4 = zeros(size(xExpertCombined,1));
fPhase4 = zeros(1,size(xExpertCombined,1));
if featureSelection(14)==1 && noOfPhasesInACycle >= 4
    j=4;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase4(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(14));
            fPhase4(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(14));
        end
    end
end
%JPhase4 = JPhase4/1000;

JPhase5 = zeros(size(xExpertCombined,1));
fPhase5 = zeros(1,size(xExpertCombined,1));
if featureSelection(15)==1 && noOfPhasesInACycle >= 5
    j=5;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase5(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(15));
            fPhase5(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(15));
        end
    end
end
%JPhase5 = JPhase5/1000;

JPhase6 = zeros(size(xExpertCombined,1));
fPhase6 = zeros(1,size(xExpertCombined,1));
if featureSelection(16)==1 && noOfPhasesInACycle >= 6
    j=6;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase6(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(16));
            fPhase6(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(16));
        end
    end
end
%JPhase6 = JPhase6/1000;

JPhase7 = zeros(size(xExpertCombined,1));
fPhase7 = zeros(1,size(xExpertCombined,1));
if featureSelection(17)==1 && noOfPhasesInACycle >= 7
    j=7;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase7(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(17));
            fPhase7(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(17));
        end
    end
end
%JPhase7 = JPhase7/1000;

JPhase8 = zeros(size(xExpertCombined,1));
fPhase8 = zeros(1,size(xExpertCombined,1));
if featureSelection(18)==1 && noOfPhasesInACycle >= 8
    j=8;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase8(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(18));
            fPhase8(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(18));
        end
    end
end
%JPhase8 = JPhase8/1000;

JLink1Sensor = zeros(size(xExpertCombined,1));
if featureSelection(19)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 1 || (noOfPhasesInACycle == 1 && mod(i,noOfPhasesInACycle) == 0))
                    if x(l(i,j,k)) >= 1
                        JLink1Sensor(l(i,j,k),l(i,j,k)) = 100*localWeights(featureSelectionIndex(19));
                    else
                        JLink1Sensor(l(i,j,k),l(i,j,k)) = 0;
                    end
                end
            end
        end
    end
end

JLink2Sensor = zeros(size(xExpertCombined,1));
if featureSelection(20)==1 && noOfLinks >= 2
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 2 || (noOfPhasesInACycle == 2 && mod(i,noOfPhasesInACycle) == 0))
                    if x(l(i,j,k)) >= 1
                        JLink2Sensor(l(i,j,k),l(i,j,k)) = 100*localWeights(featureSelectionIndex(20));
                    else
                        JLink2Sensor(l(i,j,k),l(i,j,k)) = 0;
                    end
                end
            end
        end
    end
end

JLink3Sensor = zeros(size(xExpertCombined,1));
if featureSelection(21)==1 && noOfLinks >= 3
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 3 || (noOfPhasesInACycle == 3 && mod(i,noOfPhasesInACycle) == 0))
                    if x(l(i,j,k)) >= 1
                        JLink3Sensor(l(i,j,k),l(i,j,k)) = 100*localWeights(featureSelectionIndex(21));
                    else
                        JLink3Sensor(l(i,j,k),l(i,j,k)) = 0;
                    end
                end
            end
        end
    end
end

JLink4Sensor = zeros(size(xExpertCombined,1));
if featureSelection(22)==1 && noOfLinks >= 4
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 4 || (noOfPhasesInACycle == 4 && mod(i,noOfPhasesInACycle) == 0))
                    if x(l(i,j,k)) >= 1
                        JLink4Sensor(l(i,j,k),l(i,j,k)) = 100*localWeights(featureSelectionIndex(22));
                    else
                        JLink4Sensor(l(i,j,k),l(i,j,k)) = 0;
                    end
                end
            end
        end
    end
end

JLink5Sensor = zeros(size(xExpertCombined,1));
if featureSelection(23)==1 && noOfLinks >= 5
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 5 || (noOfPhasesInACycle == 5 && mod(i,noOfPhasesInACycle) == 0))
                    if x(l(i,j,k)) >= 1
                        JLink5Sensor(l(i,j,k),l(i,j,k)) = 100*localWeights(featureSelectionIndex(23));
                    else
                        JLink5Sensor(l(i,j,k),l(i,j,k)) = 0;
                    end
                end
            end
        end
    end
end

JLink6Sensor = zeros(size(xExpertCombined,1));
if featureSelection(24)==1 && noOfLinks >= 6
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 6 || (noOfPhasesInACycle == 6 && mod(i,noOfPhasesInACycle) == 0))
                    if x(l(i,j,k)) >= 1
                        JLink6Sensor(l(i,j,k),l(i,j,k)) = 100*localWeights(featureSelectionIndex(24));
                    else
                        JLink6Sensor(l(i,j,k),l(i,j,k)) = 0;
                    end
                end
            end
        end
    end
end

JLink7Sensor = zeros(size(xExpertCombined,1));
if featureSelection(25)==1 && noOfLinks >= 7
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 7 || (noOfPhasesInACycle == 7 && mod(i,noOfPhasesInACycle) == 0))
                    if x(l(i,j,k)) >= 1
                        JLink7Sensor(l(i,j,k),l(i,j,k)) = 100*localWeights(featureSelectionIndex(25));
                    else
                        JLink7Sensor(l(i,j,k),l(i,j,k)) = 0;
                    end
                end
            end
        end
    end
end

JLink8Sensor = zeros(size(xExpertCombined,1));
if featureSelection(26)==1 && noOfLinks >= 8
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 8 || (noOfPhasesInACycle == 8 && mod(i,noOfPhasesInACycle) == 0))
                    if x(l(i,j,k)) >= 1
                        JLink8Sensor(l(i,j,k),l(i,j,k)) = 100*localWeights(featureSelectionIndex(26));
                    else
                        JLink8Sensor(l(i,j,k),l(i,j,k)) = 0;
                    end
                end
            end
        end
    end
end

JLink1ConvexSensor = zeros(size(xExpertCombined,1));
if featureSelection(27)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 1 || (noOfPhasesInACycle == 1 && mod(i,noOfPhasesInACycle) == 0))
                    JLink1ConvexSensor(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(27));
                end
            end
        end
    end
end

JLink2ConvexSensor = zeros(size(xExpertCombined,1));
if featureSelection(28)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 2 || (noOfPhasesInACycle == 2 && mod(i,noOfPhasesInACycle) == 0))
                    JLink2ConvexSensor(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(28));
                end
            end
        end
    end
end

JLink3ConvexSensor = zeros(size(xExpertCombined,1));
if featureSelection(29)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 3 || (noOfPhasesInACycle == 3 && mod(i,noOfPhasesInACycle) == 0))
                    JLink3ConvexSensor(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(29));
                end
            end
        end
    end
end

JLink4ConvexSensor = zeros(size(xExpertCombined,1));
if featureSelection(30)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 4 || (noOfPhasesInACycle == 4 && mod(i,noOfPhasesInACycle) == 0))
                    JLink4ConvexSensor(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(30));
                end
            end
        end
    end
end

JLink5ConvexSensor = zeros(size(xExpertCombined,1));
if featureSelection(31)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 5 || (noOfPhasesInACycle == 5 && mod(i,noOfPhasesInACycle) == 0))
                    JLink5ConvexSensor(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(31));
                end
            end
        end
    end
end

JLink6ConvexSensor = zeros(size(xExpertCombined,1));
if featureSelection(32)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 6 || (noOfPhasesInACycle == 6 && mod(i,noOfPhasesInACycle) == 0))
                    JLink6ConvexSensor(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(32));
                end
            end
        end
    end
end

JLink7ConvexSensor = zeros(size(xExpertCombined,1));
if featureSelection(33)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 7 || (noOfPhasesInACycle == 7 && mod(i,noOfPhasesInACycle) == 0))
                    JLink7ConvexSensor(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(33));
                end
            end
        end
    end
end

JLink8ConvexSensor = zeros(size(xExpertCombined,1));
if featureSelection(34)==1
    for i = 1:size(l,1)
        for j = 1:size(l,2)
            for k = 1:size(l,3)
                if l(i,j,k) ~= 0 && (mod(k,noOfPhasesInACycle) == 8 || (noOfPhasesInACycle == 8 && mod(i,noOfPhasesInACycle) == 0))
                    JLink8ConvexSensor(l(i,j,k),l(i,j,k)) = localWeights(featureSelectionIndex(34));
                end
            end
        end
    end
end

JPhase1Length = zeros(size(xExpertCombined,1));
fPhase1Length = zeros(1,size(xExpertCombined,1));
% dJPhase1Length = zeros(size(xExpertCombined,1),1);
if featureSelection(35)==1
    j=1;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase1Length(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(35));
            fPhase1Length(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(35))*(-2*avgPhaseLength{dIndex}(j));
        end
    end
%     dJPhase1Length = 2*JPhase1Length*xExpertCombined - invDiag(2*maxPhaseLength*localWeights(featureSelectionIndex(35))*JPhase1Length);
end 
%dJPhase1Length = dJPhase1Length/(10^2.5);

JPhase2Length = zeros(size(xExpertCombined,1));
fPhase2Length = zeros(1,size(xExpertCombined,1));
% dJPhase2Length = zeros(size(xExpertCombined,1),1);
if featureSelection(36)==1
    j=2;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase2Length(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(36));
            fPhase2Length(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(36))*(-2*avgPhaseLength{dIndex}(j));
        end
    end
%     dJPhase2Length = 2*JPhase2Length*xExpertCombined - invDiag(2*maxPhaseLength*localWeights(featureSelectionIndex(36))*JPhase2Length);
end
%dJPhase2Length = dJPhase2Length/(10^2.5);

JPhase3Length = zeros(size(xExpertCombined,1));
fPhase3Length = zeros(1,size(xExpertCombined,1));
% dJPhase3Length = zeros(size(xExpertCombined,1),1);
if featureSelection(37)==1
    j=3;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase3Length(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(37));
            fPhase3Length(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(37))*(-2*avgPhaseLength{dIndex}(j));
        end
    end
%     dJPhase2Length = 2*JPhase2Length*xExpertCombined - invDiag(2*maxPhaseLength*localWeights(featureSelectionIndex(36))*JPhase2Length);
end
%dJPhase2Length = dJPhase2Length/(10^2.5);

JPhase4Length = zeros(size(xExpertCombined,1));
fPhase4Length = zeros(1,size(xExpertCombined,1));
% dJPhase2Length = zeros(size(xExpertCombined,1),1);
if featureSelection(38)==1
    j=4;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase4Length(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(38));
            fPhase4Length(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(38))*(-2*avgPhaseLength{dIndex}(j));
        end
    end
%     dJPhase2Length = 2*JPhase2Length*xExpertCombined - invDiag(2*maxPhaseLength*localWeights(featureSelectionIndex(36))*JPhase2Length);
end
%dJPhase2Length = dJPhase2Length/(10^2.5);

JPhase5Length = zeros(size(xExpertCombined,1));
fPhase5Length = zeros(1,size(xExpertCombined,1));
% dJPhase2Length = zeros(size(xExpertCombined,1),1);
if featureSelection(39)==1
    j=5;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase5Length(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(39));
            fPhase5Length(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(39))*(-2*avgPhaseLength{dIndex}(j));
        end
    end
%     dJPhase2Length = 2*JPhase2Length*xExpertCombined - invDiag(2*maxPhaseLength*localWeights(featureSelectionIndex(36))*JPhase2Length);
end
%dJPhase2Length = dJPhase2Length/(10^2.5);

JPhase6Length = zeros(size(xExpertCombined,1));
fPhase6Length = zeros(1,size(xExpertCombined,1));
% dJPhase2Length = zeros(size(xExpertCombined,1),1);
if featureSelection(40)==1
    j=6;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase6Length(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(40));
            fPhase6Length(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(40))*(-2*avgPhaseLength{dIndex}(j));
        end
    end
%     dJPhase2Length = 2*JPhase2Length*xExpertCombined - invDiag(2*maxPhaseLength*localWeights(featureSelectionIndex(36))*JPhase2Length);
end
%dJPhase2Length = dJPhase2Length/(10^2.5);

JPhase7Length = zeros(size(xExpertCombined,1));
fPhase7Length = zeros(1,size(xExpertCombined,1));
% dJPhase2Length = zeros(size(xExpertCombined,1),1);
if featureSelection(41)==1
    j=7;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase7Length(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(41));
            fPhase7Length(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(41))*(-2*avgPhaseLength{dIndex}(j));
        end
    end
%     dJPhase2Length = 2*JPhase2Length*xExpertCombined - invDiag(2*maxPhaseLength*localWeights(featureSelectionIndex(36))*JPhase2Length);
end
%dJPhase2Length = dJPhase2Length/(10^2.5);

JPhase8Length = zeros(size(xExpertCombined,1));
fPhase8Length = zeros(1,size(xExpertCombined,1));
% dJPhase2Length = zeros(size(xExpertCombined,1),1);
if featureSelection(42)==1
    j=8;
    for dIndex = 1:d
        for c = 1:cMax(dIndex)
            JPhase8Length(delta(dIndex,noOfPhasesInACycle*(c-1)+j), delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(42));
            fPhase8Length(1,delta(dIndex,noOfPhasesInACycle*(c-1)+j)) = localWeights(featureSelectionIndex(42))*(-2*avgPhaseLength{dIndex}(j));
        end
    end
%     dJPhase2Length = 2*JPhase2Length*xExpertCombined - invDiag(2*maxPhaseLength*localWeights(featureSelectionIndex(36))*JPhase2Length);
end


xExpertCombinedSquare = diag(xExpertCombined);

% Compute r1 here.
r1 = 2*J1*xExpertCombined + 2*J2*xExpertCombined + 2*JPhase1*xExpertCombined + fPhase1'...
    + 2*JPhase2*xExpertCombined + fPhase2'+ 2*JPhase3*xExpertCombined + fPhase3' + 2*JPhase4*xExpertCombined + fPhase4'...
    + 2*JPhase5*xExpertCombined + fPhase5'+ 2*JPhase6*xExpertCombined + fPhase6' + 2*JPhase7*xExpertCombined + fPhase7'...
    + 2*JPhase8*xExpertCombined + fPhase8'...
    + 2*JLink1*xExpertCombined + 2*JLink2*xExpertCombined + 2*JLink3*xExpertCombined + 2*JLink4*xExpertCombined...
    + 2*JLink5*xExpertCombined + 2*JLink6*xExpertCombined + 2*JLink7*xExpertCombined + 2*JLink8*xExpertCombined...
    + 2*JLink1Sensor*xExpertCombined + 2*JLink2Sensor*xExpertCombined + 2*JLink3Sensor*xExpertCombined + 2*JLink4Sensor*xExpertCombined...
    + 2*JLink5Sensor*xExpertCombined + 2*JLink6Sensor*xExpertCombined + 2*JLink7Sensor*xExpertCombined + 2*JLink8Sensor*xExpertCombined...
    + invDiag(5*JLink1ConvexSensor*xExpertCombinedSquare^4) + invDiag(5*JLink2ConvexSensor*xExpertCombinedSquare^4) + invDiag(5*JLink3ConvexSensor*xExpertCombinedSquare^4) + invDiag(5*JLink4ConvexSensor*xExpertCombinedSquare^4) ...
    + invDiag(5*JLink5ConvexSensor*xExpertCombinedSquare^4) + invDiag(5*JLink6ConvexSensor*xExpertCombinedSquare^4) + invDiag(5*JLink7ConvexSensor*xExpertCombinedSquare^4) + invDiag(5*JLink8ConvexSensor*xExpertCombinedSquare^4) ...
    + 2*JPhase1Length*xExpertCombined + fPhase1Length' + 2*JPhase2Length*xExpertCombined + fPhase2Length' ...
    + (lambda'*A)' + (nu'*Aeq)';
%     + dJPhase1Length + dJPhase2Length...

%Compute r2 here.
r2 = lambda.*(A*xExpertCombined - b);

%Compute entropy of the weights here
wEntropy = sum(localWeights)*log(sum(localWeights));
%wEntropy = 0;

R = norm(r1,2)^2 + norm(r2,2)^2 + wEntropy;
% if numberOfIterations == 10000
%     fprintf('%f\n', R);
%     numberOfIterations = 1;
% else
    numberOfIterations = numberOfIterations + 1;
% end
objectiveArray(numberOfIterations) = R;
clc
if numberOfIterations == 1
    tic;
    eSpeed = 0;
end
fprintf('\nIteration number: %i', numberOfIterations);
fprintf('\nObjective value: %f\n',R);
if mod(numberOfIterations, 100) == 0
    t1 = toc;
    eSpeed = 100/t1;
    objectiveSlope = (objectiveArray(numberOfIterations) - objectiveArray(1))/numberOfIterations;
    objectiveSlopeLocal = (objectiveArray(numberOfIterations) - objectiveArray(numberOfIterations - 99))/100;
    tic;
end
fprintf('Execution speed: %f e/s \n',eSpeed);
fprintf('Total objective slope: %f\n', objectiveSlope);
fprintf('Objective slope for last 100 iterations: %f\n', objectiveSlopeLocal);