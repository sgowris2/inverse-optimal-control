function [weights ObjectiveValue] = tomlabIOCSolver(A,bL,bU,cL,cU,xL,xU)

global featureSelection;
global r1Size;
global r2Size;
global lambdaSize;
global weightsSize;

Name = 'Inverse Optimal Control Problem';
%fLowBnd = 0;         % Lower bound on function.


    Prob = conAssign('R_2', 'RGrad_2', 'RHessian_2', [], xL, xU, Name, [],...
                        [], [], A, bL, bU, [], [], [], [], cL, cU);

Prob.Warning = 0;    % Turning off warnings.            

Result = tomRun('conopt', Prob, 1);
retries = 0;
while(Result.ExitFlag ~= 0 && retries < 10)
    Result = tomRun('conopt', Prob, 1);
    retries = retries + 1;
end
%Result = tomRun('snopt', Prob, 1);
%Result = tomRun('minos', Prob, 1);

weights = Result.x_k(r1Size+r2Size+1:r1Size+r2Size+sum(featureSelection));
lambda = Result.x_k(r1Size+r2Size+weightsSize+1:r1Size+r2Size+weightsSize+lambdaSize);

ObjectiveValue = Result.f_k;

