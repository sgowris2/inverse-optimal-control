function [FIOC, cIOC, AIOC,bLIOC,bUIOC,cLIOC,cUIOC,xLIOC,xUIOC] = tomlabGenerateIOCConstSet_2()

global A;
global bL;
global bU;
global featureSelection;
global lambdaSize;
global nuSize;
global xExpertCombined;
global r1Size;
global r2Size;
global noOfLinks;
global noOfPhasesInACycle;
global weightsSize;
global rho1;
global rho2;

r1Size = numel(xExpertCombined);
r2Size = 1;
weightsSize = sum(featureSelection);
lambdaSize = 0;
nuSize = 0;
for i = 1:numel(bL)
    if bL(i) ~= bU(i)
        lambdaSize = lambdaSize+1;
    else
        nuSize = nuSize+1;
    end
end
xIOCSize = r1Size + r2Size + weightsSize + lambdaSize + nuSize;
for i = 1:lambdaSize
    ineqConstraints(i,:) = A(nuSize + i, :);
    ineqUpperBound(i,1) = bU(nuSize + i);
end
for i = 1:nuSize
    eqConstraints(i,:) = A(i,:);
end

noOfConstraints = r1Size + r2Size + lambdaSize + weightsSize + 2;

AIOC = zeros(noOfConstraints,xIOCSize);
bLIOC = -1e99*ones(noOfConstraints,1);
bUIOC = 1e99*ones(noOfConstraints,1);
cLIOC = [];
cUIOC = [];
xLIOC = -1e99*ones(xIOCSize,1);
xUIOC = 1e99*ones(xIOCSize,1);

gradientJ = gradJ_matrix(xExpertCombined,ones(weightsSize,1));

conNo = 1;
for i = 1:r1Size
    AIOC(i,i) = -1;
    for w = 1:weightsSize
        AIOC(i,r1Size+r2Size+w) = gradientJ(i,w);
    end
    for l = 1:lambdaSize
        AIOC(i,r1Size+r2Size+weightsSize+l) = ineqConstraints(l,i);
    end
    for n = 1:nuSize
        AIOC(i,r1Size+r2Size+weightsSize+lambdaSize+n) = eqConstraints(n,i);
    end
    bLIOC(i,1) = 0;
    bUIOC(i,1) = 0;
    conNo = conNo + 1;
end

for i = 1:r2Size
    AIOC(r1Size+i,r1Size+i) = -1;
    for l = 1:lambdaSize
        AIOC(r1Size+i,r1Size+r2Size+weightsSize+l) = (ineqConstraints(l,:)*xExpertCombined) - ineqUpperBound(l);
    end
    bLIOC(r1Size+i) = 0;
    bUIOC(r1Size+i) = 0;
    conNo = conNo + 1;
end

for w = 1:weightsSize
    AIOC(conNo,r1Size+r2Size+w) = 1;
    bUIOC(conNo,1) = 1;
    bLIOC(conNo,1) = 1;
end
conNo = conNo + 1;

for i = 1:noOfLinks
    AIOC(conNo,r1Size+r2Size+1+noOfPhasesInACycle+noOfLinks+i) = 1;
    bLIOC(conNo,1) = 0.00001;
    conNo = conNo+1;
end

for w = 1:weightsSize
    xLIOC(r1Size+r2Size+w) = 0;
end

for l = 1:lambdaSize
    xLIOC(r1Size+r2Size+weightsSize+l) = 0;
end

eqNo = 0;
ineqNo = 0;
for i = 1:size(A,1)
    if bL(i) == bU(i);
        eqNo = eqNo + 1;
        Aeq(eqNo,:) = A(i,:);
        beq(eqNo,1) = bU(i);
    else
        ineqNo = ineqNo + 1;
        Aineq(ineqNo,:) = A(i,:);
        bineq(ineqNo,1) = bU(i);
    end
end

rho1 = Aeq*xExpertCombined - beq;
rho2 = zeros(numel(xExpertCombined),1);
const = Aineq*xExpertCombined - bineq;
for i = 1:numel(rho2)
    if const(i) > 0
        rho2(i) = const(i);
    else
        rho2(i) = 0;
    end
end

FIOC = zeros(xIOCSize);
for i = 1:r1Size+r2Size
    FIOC(i,i) = 1;
end

cIOC = zeros(xIOCSize,1);


% 
% conNo = 1;
% for i = 1:weightsSize
%     AIOC(conNo,i) = 1;
% end
% bLIOC(conNo) = 1;
% bUIOC(conNo) = 1;
% conNo = conNo + 1;
% 
% AIOC(conNo,1) = 1;
% bLIOC(conNo) = 0.0001;
% bUIOC(conNo) = 1e99;
% conNo = conNo + 1;
% 
% for i = 1:weightsSize
%     xLIOC(i) = 0;
% end
% for i = 1:lambdaSize
%     xLIOC(i + weightsSize) = 0;
% end
% 
%     
% 
