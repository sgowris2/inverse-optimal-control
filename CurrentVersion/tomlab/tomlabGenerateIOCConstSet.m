function [AIOC,bLIOC,bUIOC,cLIOC,cUIOC,xLIOC,xUIOC] = tomlabGenerateIOCConstSet()

global A;
global bL;
global bU;
global featureSelection;
global lambdaSize;
global nuSize;

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
xIOCSize = weightsSize + lambdaSize + nuSize;

noOfConstraints = 2;

AIOC = zeros(noOfConstraints,xIOCSize);
bLIOC = zeros(noOfConstraints,1);
bUIOC = zeros(noOfConstraints,1);
cLIOC = [];
cUIOC = [];
xLIOC = -1e99*ones(xIOCSize,1);
xUIOC = [];

conNo = 1;
for i = 1:weightsSize
    AIOC(conNo,i) = 1;
end
bLIOC(conNo) = 1;
bUIOC(conNo) = 1;
conNo = conNo + 1;

AIOC(conNo,1) = 1;
bLIOC(conNo) = 0.0001;
bUIOC(conNo) = 1e99;
conNo = conNo + 1;

for i = 1:weightsSize
    xLIOC(i) = 0;
end
for i = 1:lambdaSize
    xLIOC(i + weightsSize) = 0;
end

    

