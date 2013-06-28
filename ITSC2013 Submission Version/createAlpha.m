function [alpha] = createAlpha(m, n, lambda, mu)

alpha = zeros(m, n);

for i = 1:size(alpha, 1)
    for j = 1:size(alpha, 2)
        if i == 1
            if mod(j,2) == 0;
                alpha(i, j) = lambda(i) - mu(i);
            else
                alpha(i, j) = lambda(i);
            end
        elseif i == 2
            if mod(j,2) == 1;
                alpha(i, j) = lambda(i) - mu(i);
            else
                alpha(i, j) = lambda(i);
            end
        else
            error('No. of links does not match expected');
        end
    end
end