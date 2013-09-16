function [AIOC,bLIOC,bUIOC,cLIOC,cUIOC,xLIOC,xUIOC] = tomlabGenerateIOCVars()

% The objective is computed in R.m
% The gradient of the objective is computed in Rgrad.m
% The hessian of the objective is computed in RHessian.m

[AIOC,bLIOC,bUIOC,cLIOC,cUIOC,xLIOC,xUIOC] = tomlabGenerateIOCConstSet_2();
                        