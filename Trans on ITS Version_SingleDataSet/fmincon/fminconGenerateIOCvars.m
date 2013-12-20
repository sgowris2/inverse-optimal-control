function [AIOC,bIOC,AeqIOC,beqIOC,x0] = generateIOCvars(A,Aeq)

global weightsSize;
global minWeight;

%Define parameters for x here
lambdaSize = size(A,1);
nuSize = size(Aeq,1);
xSize = weightsSize + lambdaSize + nuSize; % There are "weightsSize" weights, 2*iMax*n + 2*n lambdas, and n+1 nu's.

xPos = 1;
for i=1:weightsSize
    weightsPos(i) = xPos;
    xPos = xPos+1;
end
for i=1:lambdaSize
    lambdaPos(i) = xPos;
    xPos = xPos+1;
end
for i=1:nuSize
    nuPos(i) = xPos;
    xPos = xPos+1;
end

% Create x0 here. This is a random feasible point for the solution
x0 = zeros(xSize, 1);
for i = 1:weightsSize
    x0(i) = 1/weightsSize;
end

% Create A for ineq constraints
% There are as many as lambdaSize + weightsSize ineuqality constraints.
AIOC = zeros(weightsSize+lambdaSize, xSize);
AIOCSize = 1;
for i = 1:weightsSize
    AIOC(AIOCSize, AIOCSize) = -1;
    AIOCSize = AIOCSize+1;
    if featureSelectionIndex(35) == i || featureSelection(36) == 1
        AIOC(AIOCSize,AIOCSize) = 1;
        phaseLengthConstraints = [phaseLengthConstraints AIOCSize];
        AIOCSize = AIOCSize+1;
    end
end
for i = 1:lambdaSize
    AIOC(AIOCSize, lambdaPos(i)) = -1;
    AIOCSize = AIOCSize+1;
end

% Create b for ineq constraints
bIOC = zeros(weightsSize+lambdaSize,1);
bIOC(1) = -minWeight;
%bIOC(2) = -minWeight;
%bIOC(3) = -minWeight;
for i = 1:numel(phaseLengthConstraints)
    bIOC(phaseLengthConstraints(i)) = 1;
end

% Create Aeq for equality constraints
AeqIOC = zeros(1, xSize);
for j = 1:weightsSize
    if featureSelectionIndex(35) == j || featureSelectionIndex(36) == j
    else
        AeqIOC(1, j) = 1;
    end
end

% Create beq for equality constraints
beqIOC = 1;