function [DataSet IOCResidual] = LearnWeights(DataSet, experimentalData, simulator)

global xExpertCombined;
global xIndex;
global policyIndex;
global dataSetLoopIndex;
global A;
global Aeq;
global b;
global beq;
global bL;
global bU;
global cL;
global cU;
global xL;
global xU;
global weights;
global noOfPhasesIndex;
global agentNoOfPhases;
global fvalExpert;
global noOfCycles;
global noOfLinks;
global noOfPhasesInACycle;
global phaseSets;
global phaseSequence;
global mandatoryPhases;
global zeroTimePhases;
global solverName;
global objIndex;

d = numel(DataSet);

first = 1;
for dataSetLoopIndex = 1:d
    if first == 1
        if strcmp(solverName, 'cplex')
            [H,f,A,b,Aeq,beq,lb,ub] = cplexGenerateOCvars(DataSet{dataSetLoopIndex},1,experimentalData);
        elseif strcmp(solverName, 'tomlab')
            [A,bL,bU,cL,cU,xL,xU] = tomlabGenerateOCVars(DataSet{dataSetLoopIndex},1,experimentalData);
        else
            error('Solver not found.');
        end
        first = 0;
        if experimentalData == 0
            if strcmp(solverName, 'cplex')
                [DataSet{dataSetLoopIndex}{xIndex}, fvalExpert, DataSet{dataSetLoopIndex}{policyIndex}] = cplexOCSolver(H,f,A,b,Aeq,beq,lb,ub,1,DataSet{dataSetLoopIndex});
            elseif strcmp(solverName, 'tomlab')
                [Result] = tomlabOCSolver(A,bL,bU,cL,cU,xL,xU,1);
                DataSet{dataSetLoopIndex}{objIndex} = Result.f_k;
                DataSet{dataSetLoopIndex}{xIndex} = Result.x_k;
                for i = 1:noOfCycles{dataSetLoopIndex}*noOfPhasesInACycle
                    DataSet{dataSetLoopIndex}{policyIndex}(i,1) = Result.x_k(i+(noOfLinks*noOfPhasesInACycle*noOfCycles{dataSetLoopIndex}));
                end                
            else
                error('Solver not found.');
            end
        end
    else
        if experimentalData == 0
                if strcmp(solverName, 'cplex')
                    [DataSet{dataSetLoopIndex}{xIndex}, fvalExpert, DataSet{dataSetLoopIndex}{policyIndex}] = cplexOCSolver(H,f,A,b,Aeq,beq,lb,ub,1,DataSet{dataSetLoopIndex});
                elseif strcmp(solverName, 'tomlab')
                    [Result] = tomlabOCSolver(A,bL,bU,cL,cU,xL,xU,1);
                    DataSet{dataSetLoopIndex}{objIndex} = Result.f_k;
                    DataSet{dataSetLoopIndex}{xIndex} = Result.x_k;
                    for i = 1:noOfCycles{dataSetLoopIndex}*noOfPhasesInACycle
                        DataSet{dataSetLoopIndex}{policyIndex}(i,1) = Result.x_k(i+(noOfLinks*noOfPhasesInACycle*noOfCycles{dataSetLoopIndex}));
                    end                
                else
                    error('Solver not found.');
                end
        end
        empty1 = zeros(size(A,1),size(A,2));
        empty2 = zeros((size(A,1)),(size(A,2)));
        A = [A empty1; empty2 A];
        b = [b;b];
        emptyEq1 = zeros(size(Aeq,1),size(Aeq,2));
        emptyEq2 = zeros((size(Aeq,1)),(size(Aeq,2)));
        Aeq = [Aeq emptyEq1;emptyEq2 Aeq];
        beq = [beq;beq];
    end
end

xExpertCombined = DataSet{1}{xIndex};

if strcmp(solverName, 'cplex')
    [weights IOCResidual] = cplexIOCSolver(A,Aeq,DataSet{1});
elseif strcmp(solverName, 'tomlab')
    [FIOC, cIOC, AIOC,bLIOC,bUIOC,cLIOC,cUIOC,xLIOC,xUIOC] = tomlabGenerateIOCVars();
    [weights IOCResidual] = tomlabIOCSolver(FIOC, cIOC, AIOC,bLIOC,bUIOC,cLIOC,cUIOC,xLIOC,xUIOC);
else
    error('Solver not found.');
end

