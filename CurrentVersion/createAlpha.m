function [alpha] = createAlpha(m, n, lambda, mu, phaseSets, noOfCycles, phaseSequence)

% input is:
% m is the number of links
% n is the number of phases in a Cycle
% lambda is a vector of length iMax that contains arrival rates on each
% link
% mu is a vector of length iMax that contains departure rates for each link

alpha = zeros(m, noOfCycles*numel(phaseSequence));
for c = 1:noOfCycles
    for i = 1:numel(phaseSequence)
        for j = 1:m
            if phaseSequence(i) ~= 0 && ismember(j, phaseSets{phaseSequence(i)})
                alpha(j,(c-1)*n+i) = lambda(j,(c-1)*numel(phaseSequence)+i) - mu(j,phaseSequence(i));
            else
                alpha(j,(c-1)*n+i) = lambda(j,(c-1)*numel(phaseSequence)+i);
            end
        end
    end
end

% (c-1)*n+i