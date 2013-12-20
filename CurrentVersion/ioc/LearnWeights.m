function [expertDataSet IOCObj] = LearnWeights(expertDataSet, experimentalData)

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

d = numel(expertDataSet);

firstDataSet = 1;
for dataSetLoopIndex = 1:d
    if firstDataSet == 1
        if strcmp(solverName, 'cplex')
            [H,f,A,b,Aeq,beq,lb,ub] = cplexGenerateOCvars(expertDataSet{dataSetLoopIndex},1,experimentalData);
        elseif strcmp(solverName, 'tomlab')
            [A,bL,bU,cL,cU,xL,xU] = tomlabGenerateOCVars(expertDataSet{dataSetLoopIndex},1,experimentalData);
        else
            error('Solver not found.');
        end
        firstDataSet = 0;
        if experimentalData == 0
            if strcmp(solverName, 'cplex')
                [expertDataSet{dataSetLoopIndex}{xIndex}, fvalExpert, expertDataSet{dataSetLoopIndex}{policyIndex}] = cplexOCSolver(H,f,A,b,Aeq,beq,lb,ub,1,expertDataSet{dataSetLoopIndex});
            elseif strcmp(solverName, 'tomlab')
                [Result] = tomlabOCSolver(A,bL,bU,cL,cU,xL,xU,1);
                expertDataSet{dataSetLoopIndex}{objIndex} = Result.f_k;
                expertDataSet{dataSetLoopIndex}{xIndex} = Result.x_k;
                for i = 1:noOfCycles{dataSetLoopIndex}*noOfPhasesInACycle
                    expertDataSet{dataSetLoopIndex}{policyIndex}(i,1) = Result.x_k(i+(noOfLinks*noOfPhasesInACycle*noOfCycles{dataSetLoopIndex}));
                end                
            else
                error('Solver not found.');
            end
        end
        xExpertCombined = expertDataSet{dataSetLoopIndex}{xIndex};
    else
        if strcmp(solverName, 'cplex')
            [H,f,ATemp,bTemp,AeqTemp,beqTemp,lbTemp,ubTemp] = cplexGenerateOCvars(expertDataSet{dataSetLoopIndex},1,experimentalData);
        elseif strcmp(solverName, 'tomlab')
            [ATemp,bLTemp,bUTemp,cLTemp,cUTemp,xLTemp,xUTemp] = tomlabGenerateOCVars(expertDataSet{dataSetLoopIndex},1,experimentalData);
        else
            error('Solver not found.');
        end
        if experimentalData == 0
            if strcmp(solverName, 'cplex')
                [expertDataSet{dataSetLoopIndex}{xIndex}, fvalExpert, expertDataSet{dataSetLoopIndex}{policyIndex}] = cplexOCSolver(H,f,ATemp,bTemp,AeqTemp,beqTemp,lbTemp,ubTemp,1,expertDataSet{dataSetLoopIndex});
            elseif strcmp(solverName, 'tomlab')
                [Result] = tomlabOCSolver(ATemp,bLTemp,bUTemp,cLTemp,cUTemp,xLTemp,xUTemp,1);
                expertDataSet{dataSetLoopIndex}{objIndex} = Result.f_k;
                expertDataSet{dataSetLoopIndex}{xIndex} = Result.x_k;
                for i = 1:noOfCycles{dataSetLoopIndex}*noOfPhasesInACycle
                    expertDataSet{dataSetLoopIndex}{policyIndex}(i,1) = Result.x_k(i+(noOfLinks*noOfPhasesInACycle*noOfCycles{dataSetLoopIndex}));
                end                
            else
                error('Solver not found.');
            end
        end
        if strcmp(solverName, 'cplex')
            empty1 = zeros(size(A,1),size(ATemp,2));
            empty2 = zeros((size(ATemp,1)),(size(A,2)));
            A = [A empty1; empty2 ATemp];
            b = [b;bTemp];
            emptyEq1 = zeros(size(Aeq,1),size(AeqTemp,2));
            emptyEq2 = zeros((size(AeqTemp,1)),(size(Aeq,2)));
            Aeq = [Aeq emptyEq1;emptyEq2 AeqTemp];
            beq = [beq;beqTemp];
        elseif strcmp(solverName, 'tomlab')
            empty1 = zeros(size(A,1),size(ATemp,2));
            empty2 = zeros((size(ATemp,1)),(size(A,2)));
            A = [A empty1; empty2 ATemp];
            bL = [bL;bLTemp];
            bU = [bU;bUTemp];
            cL = [cL;cLTemp];
            cU = [cU;cUTemp];
            xL = [xL;xLTemp];
            xU = [xU;xUTemp];
        else
            error('Solver not found.');
        end
        xExpertCombined = [xExpertCombined ; expertDataSet{dataSetLoopIndex}{xIndex}];
    end
end


if strcmp(solverName, 'cplex')
    [weights IOCObj] = cplexIOCSolver(A,Aeq,expertDataSet);
elseif strcmp(solverName, 'tomlab')
    [FIOC, cIOC, AIOC,bLIOC,bUIOC,cLIOC,cUIOC,xLIOC,xUIOC] = tomlabGenerateIOCVars();
    [weights IOCObj] = tomlabIOCSolver(FIOC, cIOC, AIOC,bLIOC,bUIOC,cLIOC,cUIOC,xLIOC,xUIOC);
else
    error('Solver not found.');
end

