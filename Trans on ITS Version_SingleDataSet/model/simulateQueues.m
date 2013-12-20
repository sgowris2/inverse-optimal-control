function l = simulateQueues(lIndex,delta,alpha,lInitial,noOfLinks,c,n)

% c is the number of cycles
% n is the number of phases in a cycle

for k = 1:c*n
    for i = 1:size(alpha,1)
        if k == 1
            l(lIndex(i,k)) = lInitial(i) + alpha(i,k)*delta(k);
            if l(lIndex(i,k)) < 0
                l(lIndex(i,k)) = 0;
            end
        else
            l(lIndex(i,k)) = l(lIndex(i,k-1)) + alpha(i,k)*delta(k);
            if l(lIndex(i,k)) < 0
                l(lIndex(i,k)) = 0;
            end
        end
    end
end
    
        