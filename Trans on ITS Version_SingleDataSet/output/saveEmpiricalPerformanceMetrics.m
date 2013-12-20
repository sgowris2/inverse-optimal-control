function [] = saveEmpiricalPerformanceMetrics(DataSet, agentDataSet, IOCResidual, rho1, rho2, expNo, experimental)

global policyIndex;
global simTimeIndex;
global xIndex;
global er;
global ev;
global ep;
global eobj;
global eq;
global edelta;
global noOfLinks;
global noOfPhasesInACycle;
global noOfCycles;
global objIndex;
global weights;
global bestDataSet;
global bestEObj;
global phaseSequence;
global xExpertCombined;
global experimentalData;
global expertWeights;
global A;
global Aeq;

phaseLengthErrorObj = 0;

[l,t,delta] = xIndexing(noOfLinks,noOfPhasesInACycle*noOfCycles{1});
xExpert = DataSet{1}{xIndex};
yAgent = agentDataSet{xIndex};

eq(expNo) = 100*(sum(yAgent(l,1))-sum(xExpert(l,1)))/sum(xExpert(l,1));
edelta(expNo) = 100*(norm(xExpert(delta) - yAgent(delta), 1)/(DataSet{1}{simTimeIndex}));
%edelta(expNo) = acos(dot(xExpert(l,1),yAgent(l,1))/(norm(xExpert(l,1))*norm(yAgent(l,1))))*(180/pi);
if experimentalData == 1
    DataSet{1}{objIndex} = calculateObjValue(DataSet{1},weights);
    agentObj = calculateObjValue(agentDataSet,weights);
else
    DataSet{1}{objIndex} = calculateObjValue(DataSet{1},expertWeights);
    agentObj = calculateObjValue(agentDataSet,expertWeights);
end

% for i = 1:phaseSequence   
%     [J f g] = objJ_phaseAvgLength(i,xExpertCombined,phaseSequence,delta,numel(yAgent));
%     phaseLengthErrorObj = phaseLengthErrorObj + weights(15+i)*(yAgent'*J*yAgent + f*yAgent);
% end

eobj(expNo) = 100*((norm(DataSet{1}{objIndex} - agentObj))/(norm(DataSet{1}{objIndex})));
er(expNo) = (IOCResidual)/(numel(xExpertCombined)+1);
ev(expNo) = (norm(rho1) + norm(rho2))/(size(A,1)+size(Aeq,1));
ep(expNo) = 100*((norm(DataSet{1}{policyIndex}(:) - agentDataSet{policyIndex}, 2)/DataSet{1}{simTimeIndex}));

if expNo == 1
    bestDataSet = agentDataSet;
    bestEObj = eobj(expNo);
else
    if eobj(expNo) < bestEObj
        bestDataSet = agentDataSet;
        bestEObj = eobj(expNo);
    end
end
