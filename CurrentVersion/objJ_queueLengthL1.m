function [J f] = objJ_queueLengthL1(queueNo,l,xSize)

% sum(k = 1 to n) delta(k) (if delta(k) ~= 0) = x'*J*x

J = zeros(xSize);
f = zeros(1,xSize);

if queueNo == 0
    error('A queue does not seem to exist in the intersection.');
else
    for k = 1:numel(l(queueNo,:))
        f(1,l(queueNo, k)) = 1;
    end
end