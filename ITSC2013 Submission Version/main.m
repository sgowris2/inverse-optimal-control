function [weights, lambda, nu, agentPolicy, expertPolicy] = main(expertWeights)

global A;                   % Variable used in the optimal control problem
global b;                   % Variable used in the optimal control problem
global Aeq;                 % Variable used in the optimal control problem
global beq;                 % Variable used in the optimal control problem
global xExpert;             % State variable x
global simTime;             % The time period considered for the algorithm - tf
global departureRate;       % Average departure rate for link 1 and 2
global lInitial;            % Initial queue length l1-0 and l2-0
global noOfLinks;           % Number of links at the intersection
global noOfPhases;          % Number of phases in the traffic controller strategy
global minWeight;           % Lower bound on each of the weights
global minPhaseLength;      % Minimum phase length in seconds
global maxPhaseLength;      % Maximum phase length in seconds
global arrivalRate;
global yAgent;

minWeight = 1e-3;
% SigmaMin = 0;               % Lowest standard deviation value for sensitivity analysis
% SigmaStep = 0.01;           % Step size of standard deviation value for sensitivity analysis
% SigmaMax = 0.01;            % Highest standard deviation value for sensitivity analysis
IterationsPerStdDev = 1;        % Number of iterations of the algorithm per standard deviation value

errorStdDev = 0.00;     % Standard deviation on the distribution of error between the arrival rates of the true model and the agent.

[noOfLinks, noOfPhases, simTime, departureRate, minPhaseLength, maxPhaseLength, lInitial] = initialize();

% for errorStdDev = SigmaMin:SigmaStep:SigmaMax

for i = 1:IterationsPerStdDev
    t2 = tic;
    [xExpert expertPolicy fval1 exitflag1] = policySolver(minPhaseLength, maxPhaseLength, expertWeights, 1); 
    [arrivalRateAgent] = createAgentArrival(errorStdDev);   % Create the arrival rates for the agent based on a normal distribution with standard deviation = errorStdDev
    alphaAgent = createAlpha(noOfLinks, noOfPhases, arrivalRateAgent, departureRate);   % Create alpha, a matrix that contains the arrival rates for each link during each phase.
    [A, b, Aeq, beq] = generateQPvars(simTime,alphaAgent,0,lInitial,minPhaseLength,maxPhaseLength,noOfLinks, noOfPhases);   % Generate the quadratic program optimal control solver for the agent
    [weights, lambda, nu, fvalIOC exitflagIOC] = fminconIOC();      % Run the inverse optimal control solver
    [yAgent agentPolicy fval2 exitflag2] = policySolver(minPhaseLength, maxPhaseLength, weights, 0);    % Solve the optimal control problem for the agent.
    [weightError, queueError, deltaError] = errorChecks(expertWeights, weights, expertPolicy, agentPolicy, xExpert, yAgent);    % Calculate the error between the true system and the agent.
    fprintf('Iteration %i complete.\n', i);
    toc(t2);
end

fprintf('\nExpert arrival rate is (%.2f, %.2f)', arrivalRate(1), arrivalRate(2));
fprintf('\nAgent arrival rate is (%.2f, %.2f)', arrivalRateAgent(1), arrivalRateAgent(2));
fprintf('\n\nUser provided weights are (%f, %f).', expertWeights);
fprintf('\nPolicy for user provided weights is:\n|');
fprintf('%.2f|', expertPolicy);
fprintf('\n\nCalculated weights are (%f, %f).', weights);
fprintf('\nPolicy for calculated weights is:\n|');
fprintf('%.2f|', agentPolicy);

if exitflag1 ~= 1
   warning('Optimal Policy Solver 1 might not have converged.');
end
if exitflag2 ~= 1
    warning('Optimal Policy Solver 2 might not have converged.');
end
if exitflagIOC <= 0
    warning('Inverse Optimal Control Solver might not have converged.');
end
