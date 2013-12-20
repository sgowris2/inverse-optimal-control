function [J] = objJ_queueLength(linkNo,l,xSize)

% sum(1 to n) l(1,k)^2 = x'*J3*x

J = zeros(xSize);

for j = 1:numel(l(linkNo,:))
    J(l(linkNo,j),l(linkNo,j)) = 1;
end



