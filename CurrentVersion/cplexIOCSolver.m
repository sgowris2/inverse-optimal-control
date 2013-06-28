function [weights] = cplexIOCSolver(A,Aeq,d)

global weightsSize;
global minWeight;
global generalizedObj;
global featureSelectionIndex;
global noOfLinks;
global xExpertCombined;
global noOfCyclesIndex;
global noOfPhasesInACycle;

c = d{noOfCyclesIndex};
n = c*noOfPhasesInACycle;
m = noOfLinks;

%Define parameters for x here
lambdaSize = size(A, 1);
nuSize = size(Aeq, 1);
r1Size = numel(xExpertCombined);
r2Size = 1;
xSize = weightsSize + lambdaSize + nuSize+ r1Size + r2Size; % There are 5 weights, 2*iMax*n + 2*n lambdas, and n+1 nu's.
[weightsPos,lambdaPos,nuPos,r1Pos,r2Pos] = xIOCIndexing(weightsSize,lambdaSize,nuSize,r1Size);

% Set up the optimization problem matrices

[AIOC,bIOC,AeqIOC,beqIOC,lbIOC,ubIOC,x0] = cplexGenerateIOCConstSet(m,n,c,noOfPhasesInACycle,xSize,weightsSize,lambdaSize,nuSize,weightsPos,lambdaPos,nuPos,r1Pos,r2Pos);
[C,d] = cplexGenerateIOCvars(xSize,r1Size,r2Size,r1Pos,r2Pos);

% Run cplex here.

options = cplexoptimset('TolFun', 1e-18, 'Diagnostics', 'On');
if generalizedObj == 1
    %[x fval exitflag] = fmincon(@fminconIOCObjGeneral,x0,AIOC,bIOC,AeqIOC,beqIOC, [], [], [], options);
else
    [x,resnorm,residual,exitflag] = cplexlsqlin(C,d,AIOC,bIOC,AeqIOC,beqIOC,lbIOC,ubIOC);
end
% retries = 0;
% if exitflag < 1    
% %     if exitflag == 0
%         while retries < 1 && exitflag < 1
%             warning('Inverse Optimal Control Solver has not converged and is re-trying...\n');
%             fprintf('Retry %i\n\n', retries);
%             [x fval exitflag] = quadprog(HIOC,fIOC,AIOC,bIOC,AeqIOC,beqIOC,lbIOC,ubIOC,x0,options);
%             retries = retries + 1;
%         end
% %     else
% %         warning('Inverse Optimal Control Solver might not have found a feasible point. Retrying...');
% %         fprintf('IOC fval: %.2f\n', fval);
% %         fprintf('IOC exitflag: %i\n', exitflag);
% %     end
% end

% if exitflag >= 1
%     fprintf('IOC Converged.\n');
%     fprintf('fval: %f\n', fval);
% else
%     fprintf('IOC did not converge even after %i retries.\n', retries);
% end


% Format output here.
for i = 1:weightsSize
    weights(i) = x(i);
end
lambda(:,1) = x(lambdaPos(1):lambdaPos(lambdaSize));
nu(:,1) = x(nuPos(1):nuPos(nuSize));
IOCResiduals = C*x;
fprintf('Residual 1: %f\n', norm(x(r1Pos)));
fprintf('Residual 2: %f\n', norm(x(r2Pos)));