function J2 = objJ2(delta,noOfCycles,noOfPhasesInACycle,xSize)

% sum(c = 1 to noOfCycles) [ sum(j = 1 to noOfPhasesInACycle)
% delta(c-1*noOfPhasesInACycle + j) ]^2 = x'*J2*x

nc = noOfPhasesInACycle;
cMax = noOfCycles;

J2 = zeros(xSize);

for c = 1:cMax
    for i = 1:nc
        for j = 1:nc
            J2(delta((c-1)*nc+i),delta((c-1)*nc+j)) = 1;
        end
    end
end

