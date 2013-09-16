function [alpha] = optimizeAlpha(i,DataSet)

global noOfLinks;
global noOfPhasesInACycle;
global noOfCycles;
global xIndex;
global dataSetLoopIndex;
global xTraj;

dataSetLoopIndex = i;
xTraj = DataSet{i}{xIndex};

alpha = zeros(noOfLinks, noOfPhasesInACycle*noOfCycles{dataSetLoopIndex});
A = zeros(numel(alpha));
Aeq = zeros(numel(alpha));
b = zeros(numel(alpha),1);
beq = zeros(numel(alpha),1);
x0 = zeros(numel(alpha),1);

[x] = fmincon(@optimizeAlphaObj,x0,A,b);

index = 1;
for i = 1:noOfLinks
    for j = 1:noOfPhasesInACycle*noOfCycles{dataSetLoopIndex}
        alpha(i,j) = x(index);
        index = index + 1;
    end
end



