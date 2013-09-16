function [obj] = optimizeAlphaObj(x)

global noOfLinks;
global noOfPhasesInACycle;
global noOfCycles;
global minPhaseLength;
global maxPhaseLength;
global simTime;
global lInitial;
global zeroTimePhases;
global dataSetLoopIndex;
global agentSimTime;
global xTraj;

[l,t,delta] = xIndexing(noOfLinks,noOfPhasesInACycle*noOfCycles{dataSetLoopIndex});
xExpertCombined = xTraj;

alpha = zeros(noOfLinks,noOfPhasesInACycle*noOfCycles{1});

index = 1;
for i = 1:noOfLinks
    for j = 1:noOfPhasesInACycle*noOfCycles{dataSetLoopIndex}
        alpha(i,j) = x(index);
        index = index + 1;
    end
end

[A,b,Aeq,beq] = cplexGenerateOCConstSet(noOfLinks,noOfPhasesInACycle*noOfCycles{dataSetLoopIndex},l,t,delta,alpha,minPhaseLength,maxPhaseLength,zeroTimePhases{dataSetLoopIndex},lInitial{dataSetLoopIndex},simTime{dataSetLoopIndex},agentSimTime,1);
 
rho1 = A*xExpertCombined - b;
for i = 1:numel(rho1)
    if rho1(i) < 0
        rho1(i) = 0;
    end
end

rho2 = Aeq*xExpertCombined - beq;

obj = norm(rho1,2) + norm(rho2,2);
    

