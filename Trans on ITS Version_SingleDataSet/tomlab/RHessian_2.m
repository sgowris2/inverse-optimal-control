function RHess = RHessian_2(x)

global r1Size;
global r2Size;

RHess = zeros(numel(x));

for i = 1:r1Size+r2Size
    RHess(i,i) = 2;
end
    