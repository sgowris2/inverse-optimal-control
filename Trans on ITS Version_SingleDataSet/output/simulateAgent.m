function [agentDataSet] = simulateAgent(agentDataSet)

global noOfCyclesIndex;
global agentNoOfCycles;
global agentSimTime;
global simTimeIndex;
global xIndex;
global policyIndex;
global fvalAgent;
global solverName;
global noOfPhasesInACycle;
global noOfLinks;
global objIndex;

agentNoOfCycles = agentDataSet{noOfCyclesIndex};
agentSimTime = agentDataSet{simTimeIndex};
if strcmp(solverName,'cplex')
    [H,f,A,b,Aeq,beq,lb,ub] = cplexGenerateOCvars(agentDataSet,0,0);
        [agentDataSet{xIndex}, agentDataSet{objIndex}, agentDataSet{policyIndex}]...
                    = cplexOCSolver(H,f,A,b,Aeq,beq,lb,ub,1,agentDataSet);
elseif strcmp(solverName,'tomlab')
    [A,bL,bU,cL,cU,xL,xU] = tomlabGenerateOCVars(agentDataSet,0,0);
    [Result] = tomlabOCSolver(A,bL,bU,cL,cU,xL,xU,0);
    agentDataSet{xIndex} = Result.x_k;
    agentDataSet{objIndex} = Result.f_k;
    for i = 1:agentNoOfCycles*noOfPhasesInACycle
        agentDataSet{policyIndex}(i,1) = Result.x_k(i+(noOfLinks*noOfPhasesInACycle*agentNoOfCycles));
    end                
else
    error('Solver not found.');
end

