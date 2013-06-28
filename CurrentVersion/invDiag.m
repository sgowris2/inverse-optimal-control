function v = invDiag(squareMatrix)

s = size(squareMatrix,1);
v = zeros(s,1);

for i = 1:s
    v(i) = squareMatrix(i,i);
end