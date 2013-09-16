function [simulatedCSV] = createSimulatedCSV(policy, maneuversSequence)

a = 0;
b = 0;
csv(1,:) = [0,-1,0];
for i = 2:numel(maneuversSequence)-1
    if maneuversSequence(i) == -1 && maneuversSequence(i+1) ~= -1
        a = a + 1;
        b = b + 1;
        csv(b,:) = [0 maneuversSequence(i) policy(a)*1000];
    elseif maneuversSequence(i) == -1 && maneuversSequence(i+1) == -1
        a = a + 1;
    else
        b = b + 1;
        csv(b,:) = [0 maneuversSequence(i) 0];
    end
end

csv(b+1,:) = [0 -1 policy(a+1)*1000];

for i = 1:size(csv,1)
    for j = 1:size(csv,2)
        simulatedCSV{i,j} = csv(i,j);
    end
end

csvwrite('simulatedCSV.csv',simulatedCSV);