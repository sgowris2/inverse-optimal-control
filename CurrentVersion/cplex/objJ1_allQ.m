function J1 = objJ1(l,xSize)

% sum(1 to iMax)sum(1 to n) l(i,k)^2 = x'*J1*x

J1 = zeros(xSize);

for j = 1:numel(l)
    J1(j,j) = 1;
end
    