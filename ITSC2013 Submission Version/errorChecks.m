function [objError, queueError, deltaError] = errorChecks(expertWeights, weights, expertPolicy, agentPolicy, xExpert, yAgent)

global noOfPhases;
global HExpert;

agentObj = 0.5*yAgent'*HExpert*yAgent;
expertObj = 0.5*xExpert'*HExpert*xExpert;

objError = 100*norm((expertObj - agentObj)/expertObj);
queueError = norm(xExpert(1:2*noOfPhases, 1) - yAgent(1:2*noOfPhases, 1), 1);
deltaError = norm(xExpert(3*noOfPhases+1:4*noOfPhases) - yAgent(3*noOfPhases+1:4*noOfPhases), 1);
