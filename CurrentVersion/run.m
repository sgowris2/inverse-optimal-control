clear global;
clear workspace;
t1 = tic;
initializeGlobalVariables();
addpath('C:\Program Files\IBM\ILOG\CPLEX_Studio1251\cplex\matlab\x64_win64');

experimentalData = 1;
simulator = 0;

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
else
    expertWeights = zeros(1,sum(featureSelection));
    expertWeights(1) = 0.001;
    expertWeights(2) = 0.001;
    expertWeights = normalizeWeights(expertWeights);
    [DataSet] = initializeDataSet();
end

checkFeatures();
weightsSize = sum(featureSelection);
createFeatureSelectionIndex();

[DataSet] = LearnWeights(DataSet, experimentalData,simulator);    %Returns updated DataSet with policy embedded
[agentDataSet] = simulateAgent(DataSet{1});
printOutput(DataSet, agentDataSet, experimentalData);
visualize(DataSet, agentDataSet);
toc(t1);
sound(2);

%save('IOCResults'); % *** MAKE SURE TO NOT OVERWRITE PREVIOUS RESULTS ***