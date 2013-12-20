function [weightError, queueError, deltaError] = errorChecks(expertWeights, weights, expertPolicy, agentPolicy, xExpert, yAgent)

global noOfPhases;

weightError = 100*norm(expertWeights(1) - weights(1), 1)/expertWeights(1);
policyError = norm(expertPolicy - agentPolicy, 2);

