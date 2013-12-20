function noOfPhases = deduceNoOfPhases(rawData)

maneuverIndex = 2;

noOfPhases = -1;
for i = 1:size(rawData,1);
    if rawData{i,maneuverIndex}== -1
        noOfPhases = noOfPhases+1;
    end
end