function [arrivalRate, departureRate] = deduceArrivalDepartureRates2(RAW, simTime, observedPhases,...
                                                                    maneuvers)
                                                                
global noOfPhasesInACycle;
global phaseSets;
global noOfLinks;
global phaseSequence;

maneuverIndex = 2;
timestampIndex = 3;
intervalIndex = 0;

startTime = RAW{1,timestampIndex};
endTime = RAW{size(RAW,1),timestampIndex};

intervalSlope = zeros((endTime-startTime)/5000, noOfLinks);
intervalDepartures = zeros(noOfLinks,1);
observedPhaseNumber = 1;
intervalStart = RAW{2,timestampIndex};
departureRate = zeros(noOfLinks,noOfPhasesInACycle);
intervalTime = 0;
currentPhase = observedPhases(observedPhaseNumber);
totalDepartures = zeros(noOfLinks,1);

for m = 2:size(RAW,1)-1
    if RAW{m,maneuverIndex} == -1
        intervalIndex = intervalIndex + 1;
        for j = 1:noOfLinks
            if intervalTime ~= 0
                intervalSlope(intervalIndex,j) = (intervalDepartures(j))/intervalTime;
            end
        end            
        intervalTime = 0;
        intervalDepartures = zeros(noOfLinks,1);
        intervalStart = RAW{m+1,timestampIndex};
        for j = 1:noOfLinks
            if numel(intervalSlope) > 0
                departureRate(j,currentPhase) = departureRate(j,currentPhase) + max(intervalSlope(:,j));
            end
        end
        intervalSlope = zeros((endTime-startTime)/5000,noOfLinks);
        observedPhaseNumber = observedPhaseNumber + 1;
        currentPhase = observedPhases(observedPhaseNumber);
    else
        intervalTime = RAW{m,timestampIndex}-intervalStart;
        if intervalTime >= 10000
            intervalIndex = intervalIndex + 1;
            for j = 1:noOfLinks
                if intervalTime ~= 0
                    intervalSlope(intervalIndex,j) = (intervalDepartures(j))/intervalTime;
                end
                if ismember(RAW{m,maneuverIndex}, maneuvers{j})
                    intervalDepartures(j) = intervalDepartures(j) + 1;
                    totalDepartures(j) = totalDepartures(j) + 1;
                end
            end            
            intervalTime = 0;
            intervalDepartures = zeros(noOfLinks,1);
            intervalStart = RAW{m+1,timestampIndex};
        else
            for j = 1:noOfLinks
                if ismember(RAW{m,maneuverIndex}, maneuvers{j})
                    intervalDepartures(j) = intervalDepartures(j) + 1;
                    totalDepartures(j) = totalDepartures(j) + 1;
                end
            end
        end
    end
end

departureRate = departureRate*1000;
for p = 1:noOfPhasesInACycle
    if numel(find(observedPhases == p)) ~= 0
        departureRate(:,p) = departureRate(:,p)/numel(find(observedPhases==p));
    end
end

arrivalRate = totalDepartures/simTime;
