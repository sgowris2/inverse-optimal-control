function [weights, lambda, nu, fval exitflag] = fminconIOC()

global noOfLinks;
iMax = noOfLinks;
global noOfPhases;
n = noOfPhases;
global minWeight;

%Define parameters for x here
xSize = 2 + (2*iMax*n)+(2*n) + n+1; % There are two weights, 2*iMax*n + 2*n lambdas, and n+1 nu's.
lambdaSize = (2*iMax*n)+(2*n);
weightsSize = 2;
nuSize = n+1;
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
x0(1) = 0.5;
x0(2) = 0.5;

% Create A for ineq constraints
% There are as many as lambdaSize + weightsSize ineuqality constraints.
AIOC = zeros(2*weightsSize+lambdaSize, xSize);
AIOCSize = 1;
for i = 1:weightsSize
    AIOC(AIOCSize, AIOCSize) = -1;
    AIOCSize = AIOCSize+1;
end
for i = 1:weightsSize
    AIOC(AIOCSize, AIOCSize) = -1;
    AIOCSize = AIOCSize+1;
end
for i = 1:lambdaSize
    AIOC(AIOCSize, lambdaPos(i)) = -1;
    AIOCSize = AIOCSize+1;
end

% Create b for ineq constraints
bIOC = zeros(2*weightsSize+lambdaSize,1);
bIOC(1) = -minWeight;
bIOC(2) = -minWeight;

% Create Aeq for equality constraints
AeqIOC = zeros(1, xSize);
for j = 1:2
    AeqIOC(1, j) = 1;
end

% Create beq for equality constraints
beqIOC = 1;

% Run fmincon here.
options = optimset('Display', 'Off', 'Algorithm', 'active-set', 'TolCon', 1e-12, 'TolX', 1e-12, 'TolFun', 1e-8, 'MaxFunEvals', 100000, 'MaxIter', 10000);
[x fval exitflag] = fmincon(@objFun,x0,AIOC,bIOC,AeqIOC,beqIOC, [], [], [], options);

% Format output here.
weights(1) = x(1);
weights(2) = x(2);
lambda(:,1) = x(lambdaPos(1):lambdaPos(lambdaSize));
nu(:,1) = x(nuPos(1):nuPos(nuSize));