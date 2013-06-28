function [xCheck] = queueEvolutionCheck()

global xExpert;
global lInitial;
global alpha;
global delta;
global noOfLinks;
global noOfPhases;

oldQueue = zeros(1,noOfLinks);
for i = 1:noOfLinks
    oldQueue(i) = lInitial(i);
end

queue = zeros(2*noOfPhases, 1);

for i = 1:noOfLinks
    for k = 1:noOfPhases
        queue(i*k) = max((oldQueue(i)+alpha(i,k)*xExpert(delta(k))), 0);
        oldQueue(i) = queue(i*k);
    end
end

tolerance = 0.001;
if abs(xExpert(1:noOfLinks*noOfPhases, 1) - queue) < tolerance*ones(noOfLinks*noOfPhases,1);
    xCheck = 1;
else
    xCheck = 0;
end
if xCheck == 1
    fprintf('Queue evolution checked and satisfied to tolerance of %d.\n', tolerance);
else
    warning('Queue evolution not satisfied to specified tolerance.');
end