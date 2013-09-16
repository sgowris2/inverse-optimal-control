function [l,t,delta] = xIndexing(iMax,n)

xIndex = 1;
l = zeros(iMax, n);
for i = 1:iMax
    for k = 1:n
        l(i,k) = xIndex;
        xIndex = xIndex + 1;
    end
end

t = zeros(n,1);
for k = 1:n
    t(k) = xIndex;
    xIndex = xIndex + 1;
end

delta = zeros(n,1);
for k = 1:n
    delta(k) = xIndex;
    xIndex = xIndex + 1; % increment the marker
end