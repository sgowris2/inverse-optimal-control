function [] = printOutput(DataSet, agentDataSet, experiment)

global weights;
global noOfDataSets;
global expertWeights;
global policyIndex;
global simTimeIndex;
global r3;
global r4;


% fprintf('\nExpert arrival rate is [');
% fprintf(' %.2f', arrivalRate);
% fprintf(' ]\n');
% fprintf('\nAgent arrival rate is [');
% fprintf(' %.2f', arrivalRateAgent);
% fprintf(' ]\n');
if experiment == 0
    fprintf('\nUser provided weights are (%.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f).', expertWeights);
    if noOfDataSets == 1
        fprintf('\nPolicy for user provided weights is:\n|');
        fprintf('%.2f|', DataSet{1}{policyIndex});
        fprintf('\n');
    else
        fprintf('\nPolicies for user provided weights are:\n');
        for d = 1:noOfDataSets
            fprintf('|');
            fprintf('%.2f|', DataSet{d}{policyIndex});
            fprintf('\n');
        end
    end
else
    if noOfDataSets == 1
        fprintf('\nPolicy observed is:\n|');
        fprintf('%.2f|', DataSet{1}{policyIndex});
        fprintf('\n');
    else
        fprintf('\nPolicies observed are:\n');
        for d = 1:noOfDataSets
            fprintf('|');
            fprintf('%.2f|', DataSet{d}{policyIndex});
            fprintf('\n');
        end
    end
end
fprintf('\nCalculated weights are (%.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f).', weights);
fprintf('\nPolicy for calculated weights is:\n|');
fprintf('%.2f|', agentDataSet{policyIndex});
fprintf('\n');
fprintf('\n2-norm error on the policy: %f percent\n', 100*(norm(DataSet{1}{policyIndex}(:) - agentDataSet{policyIndex}, 2))/DataSet{1}{simTimeIndex});
fprintf('\nr3: %f', norm(r3));
fprintf('\nr4: %f', norm(r4));
