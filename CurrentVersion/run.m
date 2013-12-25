clear global;
clear workspace;
t1 = tic;
initializeGlobalVariables();
addpath('C:\Program Files\IBM\ILOG\CPLEX_Studio1251\cplex\matlab\x64_win64');

intersectionName = 'GreenFirstVisSim';

experimentalData = 1;
noOfDataSets = 2;   % This is only used in the numerical inverse crime setting.
                    % The experimental setup gets this value from the
                    % number of strings in the filenames array in the file
                    % selectIntersection.m
noOfIterations = 1;
solverName = 'cplex'; % takes value 'tomlab' or 'cplex'

cycleFeatures = 0;
generalizedObj = 0;
if generalizedObj > 0 || cycleFeatures > 0
    error('Code for selected options is not complete.');
end

selectIntersection();
selectFeatures();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
if experimentalData == 1
    [expertDataSet] = initializeExperimentalDataSet(filenames);
    checkFeatures();
    weightsSize = sum(featureSelection);
    createFeatureSelectionIndex();
    for iteration = 1:noOfIterations
        [expertDataSet IOCObj] = LearnWeights(expertDataSet,experimentalData);    %Returns updated DataSet with policy embedded
        [agentDataSet] = simulateAgent(expertDataSet);
        saveEmpiricalPerformanceMetrics(expertDataSet, agentDataSet, IOCObj, r3, r4, iteration);
    end
    plotResidualsAndInfeasibility(eJ, edelta, eq, eo, ef, ep);
    printOutput(expertDataSet, agentDataSet, experimentalData);
    visualize(expertDataSet, agentDataSet);

else
    weightIndex = ones(1,sum(featureSelection));    
    [expertDataSet] = initializeNumericalDataSet();
     
    for iteration = 1:noOfIterations
        t2 = tic;
        checkFeatures();
        weightsSize = sum(featureSelection);
        createFeatureSelectionIndex();
        %expertWeights = drawRandomWeights(weightIndex, featureSelectionIndex);
        %expertWeights = [0.0718    0.1913    0.0785    0.0236    0.1659    0.0828    0.0514    0.0859    0.0205    0.0281    0.2003];
        %expertWeights = [0.1955    0.1984    0.1194    0.0124    0.0487    0.0733    0.1704    0.0032    0.0089    0.0351    0.1347];
        expertWeights = [0.12 0 0 0.22 0.22 0.22 0.22 0 0 0 0];
        [expertDataSet IOCObj] = LearnWeights(expertDataSet,experimentalData);    %Returns updated DataSet with policy embedded
        [agentDataSet] = simulateAgent(expertDataSet);
        saveEmpiricalPerformanceMetrics(expertDataSet, agentDataSet, IOCObj, r3, r4, iteration);
        if experimentalData ~= 1    
            printOutput(expertDataSet, agentDataSet, experimentalData);
            visualize(expertDataSet, agentDataSet);
        end
        toc(t2);
    end
    plotResidualsAndInfeasibility(eJ, edelta, eq, eo, ef, ep);
end

toc(t1);
sound(2);

%save('IOCResults'); % *** MAKE SURE TO NOT OVERWRITE PREVIOUS RESULTS ***