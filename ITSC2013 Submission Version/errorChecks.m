function [weightError, queueError, deltaError] = errorChecks(expertWeights, weights, expertPolicy, agentPolicy, xExpert, yAgent)

global noOfPhases;

weightError = 100*norm(expertWeights(1) - weights(1), 1)/expertWeights(1);
%policyError = norm(expertPolicy - agentPolicy, 2);
queueError = norm(xExpert(1:2*noOfPhases, 1) - yAgent(1:2*noOfPhases, 1), 1);
deltaError = norm(xExpert(3*noOfPhases+1:4*noOfPhases) - yAgent(3*noOfPhases+1:4*noOfPhases), 1);
