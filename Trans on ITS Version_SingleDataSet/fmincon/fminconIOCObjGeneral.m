function [R] = fminconIOCObjGeneral(x)

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
global allQueuesPower;
global allPhaseLengthsPower;

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

for i = 1:allQueuesPower
    JAllQueues{i} = zeros(numel(xExpertCombined));
    for j = 1:size(l,1)
        for k = 1:size(l,2)
            for m = 1:size(l,3)
                JAllQueues{i}(l(j,k,m),l(j,k,m)) = JAllQueues{i}(l(j,k,m),l(j,k,m)) + localWeights(i);
            end
        end    
    end
end

for i = 1:allPhaseLengthsPower
    JAllPhaseLengths{i} = zeros(numel(xExpertCombined));
    for j = 1:size(delta,1)
        for k = 1:size(delta,2)
        	JAllPhaseLengths{i}(delta(j,k),delta(j,k)) = JAllPhaseLengths{i}(delta(j,k),delta(j,k)) + localWeights(i + allQueuesPower);   
        end
    end
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
    + (lambda'*A)' + (nu'*Aeq)';

%Compute r2 here.
r2 = lambda.*(A*xExpertCombined - b);

%Compute entropy of the weights here
wEntropy = sum(localWeights)*log(sum(localWeights));
%wEntropy = 0;

R = norm(r1,2)^2 + norm(r2,2)^2 + wEntropy;
if numberOfIterations == 10000
    fprintf('%f\n', R);
    numberOfIterations = 1;
else
    numberOfIterations = numberOfIterations + 1;
end