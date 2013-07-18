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
    expertWeights(1) = 1;
    expertWeights(2) = 0.5;
    expertWeights(3) = 0.5;
    expertWeights(4) = 0.5;
    expertWeights(5) = 0.5;
    expertWeights(6) = 0.5;
    expertWeights(7) = 0.5;
    expertWeights(8) = 0.5;
    expertWeights(9) = 0.5;
%     expertWeights(10) = 0.5;
%     expertWeights(11) = 0.5;
    expertWeights(12) = 0.5;
    expertWeights(13) = 0.5;
    expertWeights(14) = 0.5;
    expertWeights(15) = 0.5;
    expertWeights(16) = 0.5;
    expertWeights(17) = 0.5;
%     expertWeights(18) = 0.5;
%     expertWeights(19) = 0.5;
%     expertWeights(20) = 0.5;
%     expertWeights(21) = 0.5;
%     expertWeights(22) = 0.5;
%     expertWeights(23) = 0.5;
%     expertWeights(24) = 0.5;
%     expertWeights(25) = 0.5;
%     expertWeights(26) = 0.5;
%     expertWeights(27) = 0.5;
%     expertWeights(28) = 0.5;
%     expertWeights(29) = 0.5;
%     expertWeights(30) = 0.5;
%     expertWeights(31) = 0.5;
%     expertWeights(32) = 0.5;
%     expertWeights(33) = 0.5;
%     expertWeights(34) = 0.5;
%     expertWeights(35) = 0.5;
%     expertWeights(36) = 0.5;
%     expertWeights(37) = 0.5;
%     expertWeights(38) = 0.5;
%     expertWeights(39) = 0.5;
%     expertWeights(40) = 0.5;
%     expertWeights(41) = 0.5;
    
    
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