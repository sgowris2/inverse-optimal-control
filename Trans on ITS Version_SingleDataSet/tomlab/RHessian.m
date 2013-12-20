function RHess = RHessian(x)

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

R1Hess = zeros(weightsSize+lambdaSize+nuSize);
R2Hess = R1Hess;

% Create the terms of the hessian that are the derivative of the weights
for i = 1:weightsSize
    tempWeights = zeros(size(localWeights));
    tempWeights(i) = 1;
	dr1_dw(:,i) = gradJ(xExpertCombined,tempWeights);
end

% Create the terms of the hessian that are the derivative of lambda
for i = 1:lambdaSize
    dr1_dLambda(i,:) = ineqConstraints(i,:);
    dr2_dLambda(i) = (ineqConstraints(i,:)*xExpertCombined)-ineqUpperBound(i);
end

% Create the terms of the hessian that are the derivative of nu
for i = 1:nuSize
    dr1_dNu(i,:) = eqConstraints(i,:);
end

% Build the hessian for ||r1||^2
for w1 = 1:weightsSize
    for w2 = 1:weightsSize
        R1Hess(w1,w2) = 2*dr1_dw(:,w1)'*dr1_dw(:,w2);
    end
end
for w = 1:weightsSize
    for L = 1:lambdaSize
        R1Hess(w,weightsSize+L) = 2*dr1_dw(:,w)'*dr1_dLambda(L,:)';
        R1Hess(weightsSize+L,w) = 2*dr1_dLambda(L,:)*dr1_dw(:,w);
    end
end
for w = 1:weightsSize
    for N = 1:nuSize
        R1Hess(w,weightsSize+lambdaSize+N) = 2*dr1_dw(:,w)'*dr1_dNu(N,:)';
        R1Hess(weightsSize+lambdaSize+N,w) = 2*dr1_dNu(N,:)*dr1_dw(:,w);
    end
end

for L1 = 1:lambdaSize
    for L2 = 1:lambdaSize
        R1Hess(weightsSize+L1, weightsSize+L2) = 2*dr1_dLambda(L1,:)*dr1_dLambda(L2,:)';
    end
end
for L = 1:lambdaSize
    for N = 1:nuSize
        R1Hess(weightsSize+L, weightsSize+lambdaSize+N) = 2*dr1_dLambda(L,:)*dr1_dNu(N,:)';
        R1Hess(weightsSize+lambdaSize+N, weightsSize+L) = 2*dr1_dNu(N,:)*dr1_dLambda(L,:)';
    end
end

for N1 = 1:nuSize
    for N2 = 1:nuSize
        R1Hess(weightsSize+lambdaSize+N1, weightsSize+lambdaSize+N2) = 2*dr1_dNu(N1,:)*dr1_dNu(N2,:)';
    end
end

% Build the hessian for ||r2||^2

for L1 = 1:lambdaSize
    for L2 = 1:lambdaSize
        R2Hess(weightsSize+L1, weightsSize+L2) = 2*dr2_dLambda(L1)*dr2_dLambda(L2);
    end
end

RHess = R1Hess + R2Hess;


% for i = 1:sum(featureSelection)
%     localWeights(i) = x(i);
% end
% for i = 1:lambdaSize
%     lambda(i,1) = x(sum(featureSelection)+i);
%     ineqConstraints(i,:) = A(nuSize + i, :);
%     ineqUpperBound(i,1) = bU(nuSize + i);
% end
% for i = 1:nuSize
%     nu(i,1) = x(sum(featureSelection) + lambdaSize + i);
%     eqConstraints(i,:) = A(i,:);
% end
% 
% xSize = sum(featureSelection) + lambdaSize + nuSize;
% 
% gJ = gradJ(xExpertCombined,localWeights);
% 
% for i = 1:numel(gJ)
%     r1(i,i) = gJ(i);
% end
% r2w = zeros(sum(featureSelection),1);
% r2nu = zeros(nuSize,1);
% 
% R1 = blkdiag(r1,ineqConstraints, eqConstraints);
% R2 = [r2w;(ineqConstraints*xExpertCombined - ineqUpperBound);r2nu];
% 
% RHess = 2*R1^2 + 2*(R2'*R2);