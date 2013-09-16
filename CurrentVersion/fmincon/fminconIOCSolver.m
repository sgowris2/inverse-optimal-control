function [weights] = fminconIOCSolver()

global A;
global Aeq;
global weightsSize;
global minWeight;
global generalizedObj;
global featureSelectionIndex;

phaseLengthConstraints = [];

%Define parameters for x here
lambdaSize = size(A, 1);
nuSize = size(Aeq, 1);
xSize = weightsSize + lambdaSize + nuSize; % There are 5 weights, 2*iMax*n + 2*n lambdas, and n+1 nu's.
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
for i = 1:lambdaSize
    x0(weightsSize + i) = rand(1,1);
end

% Create A for ineq constraints
% There are as many as lambdaSize + weightsSize ineuqality constraints.
AIOC = zeros(weightsSize+lambdaSize, xSize);
AIOCSize = 1;
for i = 1:weightsSize
    AIOC(AIOCSize, AIOCSize) = -1;
    AIOCSize = AIOCSize+1;
end
for i = 1:lambdaSize
    AIOC(AIOCSize, lambdaPos(i)) = -1;
    AIOCSize = AIOCSize+1;
end
% for i = 1:weightsSize
%     if featureSelectionIndex(35) == i || featureSelectionIndex(36) == i
%         AIOC(AIOCSize,i) = 1;
%         phaseLengthConstraints = [phaseLengthConstraints AIOCSize];
%         AIOCSize = AIOCSize+1;
%     end
% end

% Create b for ineq constraints
bIOC = zeros(weightsSize+lambdaSize,1);
bIOC(1) = -minWeight;
%bIOC(2) = -minWeight;
%bIOC(3) = -minWeight;
% for i = 1:numel(phaseLengthConstraints)
%     bIOC(phaseLengthConstraints(i)) = 1;
% end

% Create Aeq for equality constraints
% Create Aeq for equality constraints
AeqIOC = zeros(1, xSize);
for j = 1:weightsSize
    AeqIOC(1, j) = 1;
end

% Create beq for equality constraints
beqIOC = 1;

% Run fmincon here.
options = optimset('Display', 'Off', 'Algorithm', 'interior-point', 'TolCon', 1e-2, 'TolX', 1e-2, 'TolFun', 1e-2, 'MaxFunEvals', 75000, 'MaxIter', 75000, 'MaxSQPIter', 10000);
if generalizedObj == 1
    [x fval exitflag] = fmincon(@fminconIOCObjGeneral,x0,AIOC,bIOC,AeqIOC,beqIOC, [], [], [], options);
else
    [x fval exitflag] = fmincon(@fminconIOCObj,x0,AIOC,bIOC,AeqIOC,beqIOC, [], [], [], options);
end
    retries = 0;
if exitflag < 1    
%     if exitflag == 0
        while retries < 1 && exitflag < 1
            warning('Inverse Optimal Control Solver has not converged and is re-trying...\n');
            fprintf('Retry %i\n\n', retries);
            [x fval exitflag] = fmincon(@inverseOptimalControlObj,x,AIOC,bIOC,AeqIOC,beqIOC, [], [], [], options);
            retries = retries + 1;
        end
%     else
%         warning('Inverse Optimal Control Solver might not have found a feasible point. Retrying...');
%         fprintf('IOC fval: %.2f\n', fval);
%         fprintf('IOC exitflag: %i\n', exitflag);
%     end
end

if exitflag >= 1
    fprintf('IOC Converged.\n');
    fprintf('fval: %f\n', fval);
else
    fprintf('IOC did not converge even after %i retries.\n', retries);
end


% Format output here.
for i = 1:weightsSize
    weights(i) = x(i);
end
lambda(:,1) = x(lambdaPos(1):lambdaPos(lambdaSize));
nu(:,1) = x(nuPos(1):nuPos(nuSize));