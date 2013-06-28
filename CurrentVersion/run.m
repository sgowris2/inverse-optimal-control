clear global;
clear workspace;
t1 = tic;
initializeGlobalVariables();
addpath('C:\Program Files\IBM\ILOG\CPLEX_Studio1251\cplex\matlab\x64_win64');

experimentalData = 1;
simulator = 1;
cycleFeatures = 0;

generalizedObj = 0;
if generalizedObj > 0
    error('Code base for generalized objective functions is not complete.');
end

% intersectionName = 'GreenFirst';
%     filenames{1} = 'TT_FirstAndGreen1.xls';
%     observedPhases{1} =     [1,2,1,2,...
%                              1,2,1,2,1,2,1,2,1,2];
    
% intersectionName = '116Broadway';
%     filenames{1} = '116th&Broadway.xls';
%     observedPhases{1} = [   1,2,1,2,1,2,1,2,1,2,...
%                             1,2,1,2,1,2,1,2,1,2,...
%                             1,2,1,2,1,2,1,2,1,2,...
%                             1,2,1,2,1,2,1,2,1,2,...
%                             1,2,1,2,1,2,1,2,1,2,...
%                             1,2,1,2,1,2,1,2,1,2,...
%                             1,2,1,2,1,2,1,2         ];
%     filenames{1} = '116th&Broadway-Short.xls';
%     observedPhases{1} =     [1,2,1,2,1,2,1,2,...
%                              1,2,1,2,1,2,1,2,1,2];

intersectionName = 'SpringfieldFirst';
% 
%     filenames{1} = 'Springfield&First.xls';
%     observedPhases{1} = [1,2,1,7,2,5,1,8,2,1,2,1,7,2,5,1,8,2,5,1,2,1,4,2,5,1,7,2,1,2,1,7,2];
% 
%     filenames{1} = 'Springfield&First - Truncated.xls';
%     observedPhases{1} = [1,2,1,7,2,5,1,8,2,1,2,1,7,2,5,1,8,2,5,1,2];

    filenames{1} = 'Springfield&First - TruncatedShort.xls';
    observedPhases{1} = [1,2,1,7,2,5,1,8,2];
    %observedPhases{1} = [1,2];


% Which features do you want to use? Change variable value to 1 to use the
% feature %

if generalizedObj == 1
    fprintf('Using a generalized objective function.\n');
    allQueuesPower = 3;
    allPhaseLengthsPower = 3;
    
    featureSelection = ones(1,allQueuesPower + allPhaseLengthsPower);
    
else
    if cycleFeatures == 0
        fprintf('Using feature selected objective function.\n');
        allQueues = 1;
        cycle = 1;
        queue1 = 1;
        queue2 = 1;
        queue3 = 1;
        queue4 = 1;
        queue5 = 1;
        queue6 = 1;
        queue7 = 1;
        queue8 = 1;
        phase1 = 0;
        phase2 = 0;
        phase3 = 0;
        phase4 = 0;
        phase5 = 0;
        phase6 = 0;
        phase7 = 0;
        phase8 = 0;
        phase1AvgLength = 1;
        phase2AvgLength = 1;
        phase3AvgLength = 1;
        phase4AvgLength = 1;
        phase5AvgLength = 1;
        phase6AvgLength = 1;
        phase7AvgLength = 1;
        phase8AvgLength = 1;
        phase1LengthL1 = 0;
        phase2LengthL1 = 0;
        phase3LengthL1 = 0;
        phase4LengthL1 = 0;
        phase5LengthL1 = 0;
        phase6LengthL1 = 0;
        phase7LengthL1 = 0;
        phase8LengthL1 = 0;
        queue1LengthL1 = 0;
        queue2LengthL1 = 0;
        queue3LengthL1 = 0;
        queue4LengthL1 = 0;
        queue5LengthL1 = 0;
        queue6LengthL1 = 0;
        queue7LengthL1 = 0;
        queue8LengthL1 = 0;
%         remainingCars1 = 1;
%         remainingCars2 = 1;
%         remainingCars3 = 1;
%         remainingCars4 = 1;
%         remainingCars5 = 1;
%         remainingCars6 = 1;
%         remainingCars7 = 1;
%         remainingCars8 = 1;
        
    else
        n = 24;
        totalCombinations = 0;
        for i = 1:n
            totalCombinations = totalCombinations + factorial(n)/(factorial(i)*factorial(n-i));
        end
    end    
    featureSelection = [allQueues,cycle,...
                    queue1,queue2,queue3,queue4,queue5,queue6,queue7,queue8...
                    phase1,phase2,phase3,phase4,phase5,phase6,phase7,phase8...
                    phase1AvgLength, phase2AvgLength,phase3AvgLength,phase4AvgLength,phase5AvgLength,phase6AvgLength,phase7AvgLength,phase8AvgLength,...
                    phase1LengthL1,phase2LengthL1,phase3LengthL1,phase4LengthL1,phase5LengthL1,phase6LengthL1,phase7LengthL1,phase8LengthL1,...
                    queue1LengthL1,queue2LengthL1,queue3LengthL1,queue4LengthL1,queue5LengthL1,queue6LengthL1,queue7LengthL1,queue8LengthL1];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if experimentalData == 1
    [DataSet] = initializeExperimentalDataSet(filenames);
else
    expertWeights = zeros(1,sum(featureSelection));
    expertWeights(1) = 0.001;
    expertWeights(2) = 0.001;
%     expertWeights(8) = 0.25;
%     expertWeights(9) = 1;
%     expertWeights(10) = 0.25;
    expertWeights = normalizeWeights(expertWeights);
    [DataSet] = initializeDataSet();
end

checkFeatures();
weightsSize = sum(featureSelection);
featureSelectionIndex = zeros(1,weightsSize);
index = 1;
for i = 1:numel(featureSelection)
    if featureSelection(i) == 1
        featureSelectionIndex(i) = index;
        index = index + 1;
    else
        featureSelectionIndex(i) = 0;
    end
end

[DataSet] = LearnWeights(DataSet, experimentalData);    %Returns updated DataSet with policy embedded
[agentDataSet] = simulateAgent(DataSet{1});
printOutput(DataSet, agentDataSet, experimentalData);
visualize(DataSet, agentDataSet);
toc(t1);
sound(2);

%save('IOCResults'); % *** MAKE SURE TO NOT OVERWRITE PREVIOUS RESULTS ***

% There is an huge execution time for multiple datasets
% Test with more phases