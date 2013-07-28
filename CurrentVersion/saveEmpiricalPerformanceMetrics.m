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
global HExpert;
global noOfLinks;
global noOfPhasesInACycle;
global noOfCycles;

[l,t,delta] = xIndexing(noOfLinks,noOfPhasesInACycle*noOfCycles{1});

if experimental == 0
    xExpert = DataSet{1}{xIndex};
    yAgent = agentDataSet{xIndex};
    agentObj = 0.5*yAgent'*HExpert*yAgent;
    expertObj = 0.5*xExpert'*HExpert*xExpert;
    eobj(expNo) = 100*norm((expertObj - agentObj)/expertObj);
end

eq(expNo) = norm(xExpert(l,1) - yAgent(l, 1), 1);
edelta(expNo) = norm(xExpert(delta) - yAgent(delta), 1);


er(expNo) = IOCResidual;
ev(expNo) = norm(rho1) + norm(rho2);
ep(expNo) = 100*(norm(DataSet{1}{policyIndex}(:) - agentDataSet{policyIndex}, 2)/DataSet{1}{simTimeIndex});