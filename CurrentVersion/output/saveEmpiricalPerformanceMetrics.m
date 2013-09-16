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

[l,t,delta] = xIndexing(noOfLinks,noOfPhasesInACycle*noOfCycles{1});
xExpert = DataSet{1}{xIndex};
yAgent = agentDataSet{xIndex};

eq(expNo) = norm(xExpert(l,1) - yAgent(l, 1), 1);
edelta(expNo) = norm(xExpert(delta) - yAgent(delta), 1);
eobj(expNo) = norm(DataSet{1}{objIndex} - agentDataSet{objIndex});
er(expNo) = IOCResidual;
ev(expNo) = norm(rho1) + norm(rho2);
ep(expNo) = 100*(norm(DataSet{1}{policyIndex}(:) - agentDataSet{policyIndex}, 2)/DataSet{1}{simTimeIndex});