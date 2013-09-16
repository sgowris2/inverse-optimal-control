clear global;
clear workspace;
t1 = tic;
initializeGlobalVariables();
addpath('C:\Program Files\IBM\ILOG\CPLEX_Studio1251\cplex\matlab\x64_win64');

experimentalData = 1;
simulator = 0;
noOfIterations = 1;
solverName = 'tomlab'; % 'tomlab' or 'cplex'

cycleFeatures = 0;
generalizedObj = 0;
if generalizedObj > 0 || cycleFeatures > 0
    error('Code base for selected options is not complete.');
end

selectIntersection();
selectFeatures();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if experimentalData == 1
    [DataSet] = initializeExperimentalDataSet(filenames);
    checkFeatures();
    weightsSize = sum(featureSelection);
    createFeatureSelectionIndex();
    [DataSet IOCResidual] = LearnWeights(DataSet,experimentalData,simulator);    %Returns updated DataSet with policy embedded
    [agentDataSet] = simulateAgent(DataSet{1});
    saveEmpiricalPerformanceMetrics(DataSet, agentDataSet, IOCResidual, rho1, rho2, 1, experimentalData);
    plotResidualsAndInfeasibility(eobj, edelta, eq, er, ev, ep);
    printOutput(DataSet, agentDataSet, experimentalData);
    visualize(DataSet, agentDataSet);
else
    weightIndex = ones(1,sum(featureSelection));
    
    [DataSet] = initializeDataSet();
    residualVector = zeros(noOfIterations,1);
    rho1Vector = zeros(noOfIterations,1);
    rho2Vector = zeros(noOfIterations,1);
    if simulator == 1
        noOfIterations = 1;
    end    
    for iteration = 1:noOfIterations
        t2 = tic;
        checkFeatures();
        weightsSize = sum(featureSelection);
        createFeatureSelectionIndex();
        expertWeights = drawRandomWeights(weightIndex, featureSelectionIndex);
        [DataSet IOCResidual] = LearnWeights(DataSet,experimentalData,simulator);    %Returns updated DataSet with policy embedded
        [agentDataSet] = simulateAgent(DataSet{1});
        saveEmpiricalPerformanceMetrics(DataSet, agentDataSet, IOCResidual, rho1, rho2, iteration, experimentalData);
        if simulator == 1    
            printOutput(DataSet, agentDataSet, experimentalData);
            visualize(DataSet, agentDataSet);
        end
        toc(t2);
    end
    plotResidualsAndInfeasibility(eobj, edelta, eq, er, ev, ep);
end

toc(t1);
sound(2);

%save('IOCResults'); % *** MAKE SURE TO NOT OVERWRITE PREVIOUS RESULTS ***