function [bestResult] = tomlabOCSolver(A,bL,bU,cL,cU,xL,xU, expertFlag)

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
bestResult = Result;
bestf_k = Result.f_k;
retries = 0;
while(retries < 100)
    x_0 = rand(size(xL));
    if expertFlag == 0
        Prob = conAssign('J', 'g', 'H', [], xL, xU, Name, x_0,...
                        [], fLowBnd, A, bL, bU, [], [], [], [], cL, cU);
    else
        Prob = conAssign('JExpert', 'gExpert', 'HExpert', [], xL, xU, Name, x_0,...
                        [], fLowBnd, A, bL, bU, [], [], [], [], cL, cU);
    end
    Result = tomRun('conopt', Prob, 1);
    if Result.f_k < bestf_k
        bestResult = Result;
        bestf_k = Result.f_k;
    end
    retries = retries + 1;
end