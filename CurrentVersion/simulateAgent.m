function [agentDataSet] = simulateAgent(agentDataSet)

global noOfCyclesIndex;
global agentNoOfCycles;
global agentSimTime;
global simTimeIndex;
global xIndex;
global policyIndex;
global fvalAgent;

agentNoOfCycles = agentDataSet{noOfCyclesIndex};
agentSimTime = agentDataSet{simTimeIndex};
[H,f,A,b,Aeq,beq,lb,ub] = cplexGenerateOCvars(agentDataSet, 0, 0);
[agentDataSet{xIndex}, fvalAgent, agentDataSet{policyIndex}]...
    = cplexOCSolver(H,f,A,b,Aeq,beq,lb,ub,1,agentDataSet);

