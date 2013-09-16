function R = R(x)

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

R = norm(R1,2)^2 + norm(R2,2)^2;

