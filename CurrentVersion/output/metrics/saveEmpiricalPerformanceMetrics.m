function [] = saveEmpiricalPerformanceMetrics(expertDataSet, agentDataSet, IOCObj, r3, r4, expNo)

global policyIndex;
global simTimeIndex;
global xIndex;
global eo;
global ef;
global ep;
global eJ;
global eq;
global ew;
global edelta;
global noOfLinks;
global noOfPhasesInACycle;
global noOfCycles;
global objIndex;
global weights;
global bestDataSet;
global besteJ;
global xExpertCombined;
global experimentalData;
global expertWeights;
global A;
global Aeq;

[l,t,delta] = xIndexing(noOfLinks,noOfPhasesInACycle*noOfCycles{1});
xExpert = expertDataSet{1}{xIndex};
yAgent = agentDataSet{1}{xIndex};

eq(expNo) = 100*(sum(yAgent(l,1))-sum(xExpert(l,1)))/sum(xExpert(l,1));
edelta(expNo) = 100*(norm(xExpert(delta) - yAgent(delta), 1)/(expertDataSet{1}{simTimeIndex}));

if experimentalData == 1
    expertDataSet{1}{objIndex} = calculateObjValue(expertDataSet{1},weights);
    agentObj = calculateObjValue(agentDataSet{1},weights);
else
    expertDataSet{1}{objIndex} = calculateObjValue(expertDataSet{1},expertWeights);
    agentObj = calculateObjValue(agentDataSet{1},expertWeights);
    ew(expNo) = norm((expertWeights - weights),1);
end

eJ(expNo) = 100*((norm(expertDataSet{1}{objIndex} - agentObj))/(agentObj));
eo(expNo) = (IOCObj)/(numel(xExpertCombined)+1);
ef(expNo) = (norm(r3) + norm(r4))/(size(A,1)+size(Aeq,1));
ep(expNo) = 100*((norm(expertDataSet{1}{policyIndex}(:) - agentDataSet{1}{policyIndex}, 2)/expertDataSet{1}{simTimeIndex}));

if expNo == 1
    bestDataSet = agentDataSet{1};
    besteJ = eJ(expNo);
else
    if eJ(expNo) < besteJ
        bestDataSet = agentDataSet{1};
        besteJ = eJ(expNo);
    end
end
