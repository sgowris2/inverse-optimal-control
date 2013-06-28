function [t,delta] = deducePolicy(rawData, zeroTimePhases)

global noOfPhasesInACycle;

maneuverIndex = 2;
timestampIndex = 3;
k = 1;

for i = 1:size(rawData,1)
    if i == 1                               % t0 is handled separately
        t0 = rawData{i,timestampIndex};
    elseif ismember(k,zeroTimePhases)       % if k is a one of the skipped phases, then assign a zero phase length
        if k == 1
            t(k) = t0;
        else
            t(k) = t(k-1);
        end
        delta(k) = 0;
        k = k+1;
    elseif rawData{i,maneuverIndex} == -1   % if there is a phase switch in the data and it isn't a skipped phase, then calculate the switching time and phase length.
        t(k) = rawData{i,timestampIndex};
        if k == 1
            delta(k) = rawData{i,timestampIndex} - t0;
        else    
            delta(k) = rawData{i,timestampIndex} - t(k-1);
        end
        k = k+1;        
    end
end

if mod(numel(delta),noOfPhasesInACycle) ~= 0                            % If a complete cycle has not been recorded at the end of the file, complete the cycle with zero phases.
    for i = 1:(noOfPhasesInACycle - mod(numel(delta),noOfPhasesInACycle))
        t(k) = t(k-1);
        delta(k) = 0;
        k = k+1;
    end
end

t = t-t0;
t = t./1000;
delta = delta./1000;