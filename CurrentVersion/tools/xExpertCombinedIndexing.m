function [lCombined,tCombined,deltaCombined] = xExpertCombinedIndexing(iMax,n)

noOfDataSets = numel(n);
xIndex = 1;
for d = 1:noOfDataSets
    l = zeros(iMax, n{d});
    for i = 1:iMax
        for k = 1:n{d}
            l(i,k) = xIndex;
            xIndex = xIndex + 1;
        end
    end

    t = zeros(n{d},1);
    for k = 1:n{d}
        t(k) = xIndex;
        xIndex = xIndex + 1;
    end

    delta = zeros(n{d},1);
    for k = 1:n{d}
        delta(k) = xIndex;
        xIndex = xIndex + 1; % increment the marker
    end
    
    lCombined{d} = l;
    tCombined{d} = t;
    deltaCombined{d} = delta;
end