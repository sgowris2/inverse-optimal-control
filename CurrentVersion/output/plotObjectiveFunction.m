function [] = plotObjectiveFunction(weights, x, color)

global featureSelectionIndex;
global featureSelection;
global expertWeights;

featureNames = {'allQueues','allPhases', ...
                'queue1','queue2','queue3','queue4','queue5','queue6','queue7','queue8',...
                'phase1','phase2','phase3','phase4','phase5','phase6','phase7','phase8',...
                'sensor1','sensor2','sensor3','sensor4','sensor5','sensor6','sensor7','sensor8'...
                'cSensor1','cSensor2','cSensor3','cSensor4','cSensor5','cSensor6','cSensor7','cSensor8',...
                'phase1length','phase2length','phase3length','phase4length','phase5length','phase6length','phase7length','phase8length',...
                'leftTurnPenalty1','leftTurnPenalty2','leftTurnPenalty3','leftTurnPenalty4','leftTurnPenalty5','leftTurnPenalty6','leftTurnPenalty7','leftTurnPenalty8'};
str = cell(1,8);
for i = 1:8
    str{i} = 'none';
end

k = 1;
for i = 1:numel(weights)
    for j = 1:numel(featureSelectionIndex)
        if featureSelectionIndex(j) == i
            selectedFeatureNames{k} = featureNames{j};
            k = k + 1;
        end
    end
end

figure;
bar(weights,color);
title('Computed weights of the objective function for all features');
xlabel('Feature #');
ylabel('Normalized weight value');
% set(gca,'XTickLabel',selectedFeatureNames);

[featureArray] = cplexEvaluateFeatureValues(x);

figure;
if numel(expertWeights) <= 1
    expertWeights = zeros(1,numel(weights));
end
for i = 1:numel(weights)
    B(i,1:2) = [expertWeights(i), weights(i)];
end
bar(B,color);
legend('Weights of the true system`s objective', 'Estimated weights');
xlabel('Weight #');
ylabel('Weight value');
title('Comparison of true system weights and recovered weights');

Y = zeros(1,sum(featureSelection));
for j = 1:sum(featureSelection)
    for k = 1:numel(featureSelectionIndex)
        if featureSelectionIndex(k) == j
            Y(j) = featureArray(k);
            str{j} = featureNames{k};
        end
    end
end

bar(Y,color);
title('Feature values of the objective function');
xlabel('Feature #');
ylabel('Feature Value');
legend(str{1},str{2},str{3},str{4},str{5},str{6},str{7},str{8});

figure;
bar(weights'.*Y,color);
title('Weighted feature values of the objective function');
xlabel('Feature #');
ylabel('Weighted feature Value');

fprintf('\nWeighted feature values are:\n|');
fprintf('%.2f|', weights'.*Y);

fprintf('\nObjective value: %f\n',sum(weights'.*Y));
