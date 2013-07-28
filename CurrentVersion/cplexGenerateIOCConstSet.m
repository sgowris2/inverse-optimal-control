function [AIOC,bIOC,AeqIOC,beqIOC,lbIOC,ubIOC,x0,rho1,rho2] = cplexGenerateIOCConstSet(m,n,noOfCycles,noOfPhasesInACycle,xSize,weightsSize,lambdaSize,nuSize,weightsPos,lambdaPos,nuPos,r1Pos,r2Pos)

global minWeight;
persistent l;       % indexed by (link#, phase#)
persistent t;       % indexed by (phase#)    
persistent delta;   % indexed by (phase#)
global A;
global Aeq;
global b;
global beq;
global xExpertCombined;
global noOfCyclesIndex;
global featureSelectionIndex;
global phaseSequence;
global mandatoryPhases;
global zeroTimePhases;
r1Size = numel(xExpertCombined);
r2Size = 1;

[l,t,delta] = xIndexing(m,n);    % Index l,t and delta within the vector x

% Create A for ineq constraints
% There are as many as lambdaSize + weightsSize ineuqality constraints.
AIOC = zeros(weightsSize+lambdaSize,xSize);
AIOCSize = 1;
for i = 1:weightsSize
    AIOC(AIOCSize, weightsPos(i)) = -1;
    AIOCSize = AIOCSize+1;
end
for i = 1:lambdaSize
    AIOC(AIOCSize, lambdaPos(i)) = -1;
    AIOCSize = AIOCSize+1;
end

% Create b for ineq constraints
bIOC = zeros(size(AIOC,1),1);
bIOC(1) = -minWeight;
%bIOC(2) = -minWeight;
%bIOC(3) = -minWeight;

% Create Aeq for equality constraints
% Create Aeq for equality constraints
AeqIOCSize = 1;
AeqIOC = zeros(1+1+lambdaSize, xSize);
for j = 1:weightsSize
    AeqIOC(1,j) = 1;
end
AeqIOCSize = AeqIOCSize+1;

r2ConstraintLHS = A*xExpertCombined - b;
for j=1:lambdaSize
    AeqIOC(2,lambdaPos(j)) = r2ConstraintLHS(j);
    AeqIOC(2,r2Pos) = -1;
    AeqIOCSize = AeqIOCSize+1;
end

% J{1} = objJ1_allQ(l,numel(xExpertCombined));
% J{2} = objJ2_cycleLength(delta,noOfCycles,noOfPhasesInACycle,numel(xExpertCombined));
% for i = 1:m
%     J{i+2} = objJ_queueLength(i,l,numel(xExpertCombined));
% end
% for i = 1:numel(phaseSequence)
%     J{i+10} = objJ_phaseLength(i,xExpertCombined,phaseSequence,delta,noOfCycles,numel(xExpertCombined));
% end
% for i = 1:numel(phaseSequence)
%     [J{i+18} f{i+18}] = objJ_phaseAvgLength(i,xExpertCombined,phaseSequence,delta,numel(xExpertCombined));
% end
% for i = 1:numel(phaseSequence)
%     [J{i+26} f{i+26}] = objJ_phaseLengthL1(i,phaseSequence,delta,numel(xExpertCombined));
% end
% for i = 1:m
%     [J{i+34} f{i+34}] = objJ_queueLengthL1(i,l,numel(xExpertCombined));
% end
% 
% for i = 1:m
%     [J{i+42} f{i+42}] = objJ_leftTurnPenalty(i,mandatoryPhases,l,numel(xExpertCombined),phaseSequence);
% end

J{1} = objJ2_cycleLength(delta,noOfCycles,noOfPhasesInACycle,numel(xExpertCombined));
for i = 1:numel(phaseSequence)
    J{i+1} = objJ_phaseLength(i,zeroTimePhases,phaseSequence,delta,noOfCycles,numel(xExpertCombined));
end
for i = 1:m
    [J{i+9} f{i+9}] = objJ_queueLengthL1(i,l,numel(xExpertCombined));
end
for i = 1:m
    [J{i+17}]= objJ_queueLength(i,l,numel(xExpertCombined));
end
for i = 1:numel(phaseSequence)
    [J{i+25} f{i+25}] = objJ_phaseAvgLength(i,xExpertCombined,phaseSequence,delta,numel(xExpertCombined));
end

for i=1:r1Size
    for j=1:weightsSize
        jIndex = find(featureSelectionIndex == j);
        AeqIOC(AeqIOCSize,weightsPos(j)) = 2*J{jIndex}(i,:)*xExpertCombined;
        if numel(f{jIndex} > 1)
            AeqIOC(AeqIOCSize,weightsPos(j)) = AeqIOC(AeqIOCSize,weightsPos(j)) + f{jIndex}(i);
        end
    end
    for a=1:lambdaSize
        AeqIOC(AeqIOCSize,lambdaPos(a)) = A(a,i);
    end
    for aeq=1:nuSize
        AeqIOC(AeqIOCSize,nuPos(aeq)) = Aeq(aeq,i);
    end
    AeqIOC(AeqIOCSize, r1Pos(i)) = -1;
    AeqIOCSize = AeqIOCSize+1;
end

% Create beq for equality constraints
beqIOC = zeros(size(AeqIOC,1),1);
beqIOC(1) = 1;

%Create lower and upper bounds
lbIOC = -1e99*ones(xSize,1);
ubIOC = 1e99*ones(xSize,1);

%Create a random feasible point to start the solver
x0 = zeros(xSize,1);
% Create x0 here. This is a random feasible point for the solution
% x0 = zeros(xSize, 1);
% for i = 1:weightsSize
%     x0(i) = 1/weightsSize;
% end
% for i = 1:lambdaSize
%     x0(weightsSize + i) = rand(1,1);
% end

rho1 = Aeq*xExpertCombined - beq;
rho2 = zeros(numel(xExpertCombined),1);
const = A*xExpertCombined - b;
for i = 1:numel(rho2)
    if const(i) > 0
        rho2(i) = const(i);
    else
        rho2(i) = 0;
    end
end