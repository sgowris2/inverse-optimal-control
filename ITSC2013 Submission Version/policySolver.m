function [xExpert policy fval exitflag] = policySolver(deltaMin, deltaMax, weights, expertFlag)

global noOfPhases;
n = noOfPhases;
global noOfLinks;
m = noOfLinks;
global simTime;
tf = simTime;
global minWeight;
global minPhaseLength;
global maxPhaseLength;
global lInitial;
global arrivalRate;
global departureRate;
global alpha;
global H;
global HExpert;

corrected = 0;
for i = 1:size(weights,2)
    if weights(i) < minWeight
        weights(i) = minWeight;
        corrected = 1;
    end
end
if corrected == 1
    warning('Weights did not meet the minimum value and were shifted to satisfy the requirement.');
end
if expertFlag == 1          % Pick arrival rates if policy solver is run for the expert's optimal control problem

    % Uncomment this block to randomly draw arrival rates from a
    % distribution
    %     arrivalRate(1) = 1000/3600*rand([1,1]) + 1000/3600; % per second
    %     arrivalRate(2) = 1000/3600*rand([1,1]); %per second
    
    arrivalRate = [1600/3600,800/3600];
    
    alpha = createAlpha(noOfLinks, noOfPhases, arrivalRate, departureRate);     % Create alpha, a matrix that contains the arrival rates for each link during each phase
else
    alpha = createAlpha(noOfLinks, noOfPhases, arrivalRate, departureRate);     % Create alpha, a matrix that contains the arrival rates for each link during each phase
end

[A, b, Aeq, beq] = generateQPvars(simTime,alpha,0,lInitial,minPhaseLength,maxPhaseLength,noOfLinks, noOfPhases);    % Generates the variables for the Quadratic Program Optimal Control Solver

H = zeros(4*n, 4*n);
j=1;
for i = 1:2*n
    H(i, j) = weights(1);
    j = j+1;
end
for j = 3*n+1:4*n
    for i = 3*n:4*n
        if i == j
            H(i, j) = weights(2);
        else
        end
    end
end

if expertFlag == 1
    HExpert = H;
end

lb = zeros(4*n, 1);
for i = 3*n+1:4*n
    lb(i) = deltaMin;
end

ub = zeros(4*n, 1);
for i = 3*n+1:4*n
    ub(i) = deltaMax;
end
for i = 1:2*n
    ub(i) = 10000;
end
for i = 2*n+1:3*n
    ub(i) = simTime;
end

options = optimset('Display', 'Off', 'Algorithm', 'interior-point-convex', 'TolCon', 1e-12, 'TolX', 1e-12, 'TolFun', 1e-12, 'MaxIter', 100000);
[x fval exitflag output lambda] = quadprog(H,[],A,b,Aeq,beq,lb,ub,[],options);

for i = 1:n
    policy(i, 1) = x(i+2*n);
end

xExpert = x;
