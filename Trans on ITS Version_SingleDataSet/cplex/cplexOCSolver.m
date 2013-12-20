function [x, fval, policy] = cplexOCSolver(H,f,A,b,Aeq,beq,lb,ub,expertFlag,d)

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
global noOfCycles;
global zeroTimePhasesIndex;

n = c*noOfPhasesInACycle;

xSize = noOfLinks*n + n + n;
x0 = zeros(xSize, 1);
for i = 1:weightsSize
    x0(i) = 1/weightsSize;
end

options = cplexoptimset('TolFun', 1e-18, 'Diagnostics', 'On');
if expertFlag == 0
    if generalizedObj == 1
        [x fval exitflag] = cplexqp(H,f,A,b,Aeq,beq,lb,ub,x0,options);
    else
        [x fval exitflag] = cplexqp(H,f,A,b,Aeq,beq,lb,ub,x0,options);
        
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
        [x fval exitflag] = cplexqp(H,f,A,b,Aeq,beq,lb,ub,x0,options);
    else
        %[x fval exitflag] = quadprog(H,f,A,b,Aeq,beq, lb, ub, [], options);
        [x fval exitflag] = cplexqp(H,f,A,b,Aeq,beq,lb,ub,x0,options);
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