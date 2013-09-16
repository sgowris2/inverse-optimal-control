function [pass] = checkDataSets(noOfLinks, noOfPhasesInACycle, noOfCycles, ...
                                simTime, arrivalRate, departureRate, lInitial,...
                                phaseSets, phaseSequence, mandatoryPhases,...
                                observedPhases)
for i = 1:numel(mandatoryPhases)
    a = 0;
    for j = 1:numel(observedPhases)
        if observedPhases(j) == mandatoryPhases(i)
            a = a + 1;
        end
    end
    if noOfCycles ~= a
        error('This version of IOC only works with complete cycles.');
    end
end

% if noOfLinks*noOfPhasesInACycle ~= numel(departureRate) || noOfLinks ~= numel(lInitial) || noOfLinks ~= size(arrivalRate,1) 
%     error('Initialization Error: The links in the intersection have not been initialized correctly.');
% end

if numel(phaseSets) ~= numel(find(phaseSequence > 0))
    %error('Initialization Error: The phaseSets in the intersection have not been initialized correctly.');
end

for j = 1:numel(phaseSequence)
    if phaseSequence(j) < 0 || phaseSequence(j) > numel(phaseSets)
        error('Initialization Error: The phase sequences in the intersection has undefined phases.');
    end
end


pass = 1;
