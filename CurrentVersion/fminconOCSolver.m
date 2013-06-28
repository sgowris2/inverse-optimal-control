function [x, policy] = fminconOCSolver(A,b,Aeq,beq,expertFlag,d)

global noOfCyclesIndex;
c = d{noOfCyclesIndex};
global simTimeIndex;
global noOfLinks;
m = noOfLinks;
global simTime;
global weightsSize;
global minPhaseLength;
global maxPhaseLength;
global agentSimTime;
global noOfPhasesInACycle;
global generalizedObj;
global zeroTimePhasesIndex;

n = c*noOfPhasesInACycle;

lb = zeros((m*n + 2*n), 1);
for i = (m*n + n)+1 : size(lb,1)
    if ~ismember(i-(m*n+n),d{zeroTimePhasesIndex})
        lb(i) = minPhaseLength;
    end
end

ub = zeros((m*n + 2*n), 1);
for i = (m*n + n)+1:size(ub,1)
    if ismember(i-(m*n+n),d{zeroTimePhasesIndex})
        ub(i) = 0;
    else
        ub(i) = maxPhaseLength;
    end
end
for i = 1:m*n
    ub(i) = 10000;
end
for i = m*n+1 : m*n + n
    if expertFlag == 1
        ub(i) = d{simTimeIndex};
    else
        ub(i) = agentSimTime;
    end
end

xSize = noOfLinks*n + n + n;
x0 = zeros(xSize, 1);
for i = 1:weightsSize
    x0(i) = 1/weightsSize;
end

options1 = optimset('Display', 'Off', 'Algorithm', 'interior-point', 'TolCon', 1e-8, 'TolX', 1e-8, 'TolFun', 1e-8, 'MaxFunEvals', 250000, 'MaxIter', 100000);
options2 = optimset('Display', 'Off', 'Algorithm', 'interior-point', 'TolCon', 1e-8, 'TolX', 1e-8, 'TolFun', 1e-8, 'MaxFunEvals', 250000, 'MaxIter', 100000);
if expertFlag == 0
    if generalizedObj == 1
        [x fval exitflag] = fmincon(@fminconOCObjGeneral,x0,A,b,Aeq,beq,lb,ub,[],options1);
    else
        [x fval exitflag] = fmincon(@fminconOCObj,x0,A,b,Aeq,beq,lb,ub,[],options1);
    end
    if exitflag < 1
        warning('Agent Optimal control solver might not have converged.');
        fprintf('Agent fval: %f\n', fval);
        fprintf('Agent exitflag: %i\n', exitflag);
    else
        fprintf('Agent optimal control solver converged.\n');
    end
else
    if generalizedObj == 1
        [x fval exitflag] = fmincon(@fminconOCObjExpertGeneral,x0,A,b,Aeq,beq, lb, ub, [], options2);
    else
        [x fval exitflag] = fmincon(@fminconOCObjExpert,x0,A,b,Aeq,beq, lb, ub, [], options2);
    end
    if exitflag < 1
        warning('Expert Optimal control solver might not have converged.');
        fprintf('Expert fval: %f\n', fval);
        fprintf('Expert exitflag: %i\n', exitflag);
    else
        fprintf('Expert optimal control solver converged.\n');
    end
end

for i = 1:n
    policy(i, 1) = x(i+m*n);
end