function RGrad = RGrad(x)

global featureSelection;
global lambdaSize;
global nuSize;
global xExpertCombined;
global A;
global bU;

weightsSize = sum(featureSelection);
for i = 1:weightsSize
    localWeights(i) = x(i);
end
for i = 1:lambdaSize
    lambda(i,1) = x(weightsSize+i);
    ineqConstraints(i,:) = A(nuSize + i, :);
    ineqUpperBound(i,1) = bU(nuSize + i);
end
for i = 1:nuSize
    nu(i,1) = x(weightsSize + lambdaSize + i);
    eqConstraints(i,:) = A(i,:);
end

R1 = gradJ(xExpertCombined,localWeights)  + ineqConstraints'*lambda + eqConstraints'*nu;
R2 = lambda' * (ineqConstraints*xExpertCombined - ineqUpperBound);

for i = 1:weightsSize
    RGrad(i) = 2*gradJ(xExpertCombined,ones(size(localWeights)))'*R1  +  0;
end
for i = 1:nuSize
    RGrad(weightsSize+i) = 2*eqConstraints(i,:)*R1  +  0;
end
for i = 1:lambdaSize
    RGrad(weightsSize+nuSize+i) = 2*ineqConstraints(i,:)*R1  +  2*(ineqConstraints(i,:)*xExpertCombined - ineqUpperBound(i))*R2;
end


% for i = 1:lambdaSize
%     lambda(i,1) = x(weightsSize+i);
%     ineqConstraints(i,:) = A(nuSize + i, :);
%     ineqUpperBound(i,1) = bU(nuSize + i);
% end
% for i = 1:nuSize
%     nu(i,1) = x(weightsSize + lambdaSize + i);
%     eqConstraints(i,:) = A(i,:);
% end
% 
% xSize = weightsSize + lambdaSize + nuSize;
% 
% gJ = JMatrix(x);
% 
% r2w = zeros(weightsSize,1);
% r2nu = zeros(nuSize,1);
% 
% R1 = [gJ;ineqConstraints;eqConstraints]';
% R2 = [r2w;(ineqConstraints*xExpertCombined - ineqUpperBound);r2nu];
% 
% RGrad = 2*(R1'*R1)*x + 2*(R2'*R2)*x;


