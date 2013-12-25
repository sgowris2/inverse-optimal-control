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

for d = 1:numel(agentDataSet)
    agentNoOfCycles = agentDataSet{d}{noOfCyclesIndex};
    agentSimTime = agentDataSet{d}{simTimeIndex};
    if strcmp(solverName,'cplex')
        [H,f,A,b,Aeq,beq,lb,ub] = cplexGenerateOCvars(agentDataSet{d},0,0);
            [agentDataSet{d}{xIndex}, agentDataSet{d}{objIndex}, agentDataSet{d}{policyIndex}]...
                        = cplexOCSolver(H,f,A,b,Aeq,beq,lb,ub,1,agentDataSet{d});
    elseif strcmp(solverName,'tomlab')
        [A,bL,bU,cL,cU,xL,xU] = tomlabGenerateOCVars(agentDataSet{d},0,0);
        [Result] = tomlabOCSolver(A,bL,bU,cL,cU,xL,xU,0);
        agentDataSet{d}{xIndex} = Result.x_k;
        agentDataSet{d}{objIndex} = Result.f_k;
        for i = 1:agentNoOfCycles*noOfPhasesInACycle
            agentDataSet{d}{policyIndex}(i,1) = Result.x_k(i+(noOfLinks*noOfPhasesInACycle*agentNoOfCycles));
        end                
    else
        error('Solver not found.');
    end
end

