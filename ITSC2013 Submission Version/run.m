clear;
t1 = tic;

global xExpert;
global noOfLinks;
global yAgent;

% Enter any combination of weights in the line of code below in the following
% format: 
% expertWeights = [(weight associated with feature 1) (weight associated with feature 2)]

% feature 1 : minimize the queue length over all links in the intersection

% feature 2 : minimize the variance of the phase length over all phases of
% the traffic signal

expertWeights = [0.9,0.1];

expertWeights = normalizeWeights(expertWeights);
[weights, lambda, nu, agentPolicy, expertPolicy] = main(expertWeights);
for i = 1:noOfLinks
    plotQueueLengths(xExpert, yAgent, i);
end
plotSwitchingTimes(xExpert, yAgent);
fprintf('\n');
toc(t1);

%save('IOCResults'); % *** MAKE SURE TO NOT OVERWRITE PREVIOUS RESULTS ***