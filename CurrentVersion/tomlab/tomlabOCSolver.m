function [Result] = tomlabOCSolver(A,bL,bU,cL,cU,xL,xU, expertFlag)

Name = 'Optimal Control Problem';
fLowBnd = 0;         % Lower bound on function.

if expertFlag == 0
    Prob = conAssign('J', 'g', 'H', [], xL, xU, Name, [],...
                        [], fLowBnd, A, bL, bU, [], [], [], [], cL, cU);
else
    Prob = conAssign('JExpert', 'gExpert', 'HExpert', [], xL, xU, Name, [],...
                        [], fLowBnd, A, bL, bU, [], [], [], [], cL, cU);
end

Prob.Warning = 0;    % Turning off warnings.            
            
Result = tomRun('conopt', Prob, 1);
retries = 0;
while(Result.ExitFlag ~= 0 && retries < 10)
    Result = tomRun('conopt', Prob, 1);
    retries = retries + 1;
end