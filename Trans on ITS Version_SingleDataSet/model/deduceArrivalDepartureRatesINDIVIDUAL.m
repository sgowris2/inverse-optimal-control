function [arrivalRate, departureRate] = deduceArrivalDepartureRates(RAW, simTime, observedPhases,...
                                                                    maneuvers,noOfCycles)

global noOfPhasesInACycle;
global phaseSets;
global noOfLinks;
global phaseSequence;

maneuverIndex = 2;
timestampIndex = 3;
departures = zeros(noOfLinks,noOfPhasesInACycle);
departureTime = zeros(1,noOfPhasesInACycle);
phaseStart = RAW{1,timestampIndex};
currentPhaseIndex = 1;
currentPhase = observedPhases(currentPhaseIndex);
avgArrivalRate = zeros(1,noOfLinks);
departureRate = zeros(noOfLinks,noOfPhasesInACycle);
g=0;


for i = 2:size(RAW,1)-1
    if RAW{i, maneuverIndex} == -1
        currentPhaseIndex = currentPhaseIndex + 1;        
        departureTime(currentPhase) = departureTime(currentPhase) + RAW{i,timestampIndex} - phaseStart;
        currentPhase = observedPhases(currentPhaseIndex);
        phaseStart = RAW{i,timestampIndex};
    else
        for j=1:noOfLinks
            if ismember(RAW{i,maneuverIndex}, maneuvers{j})
                departures(j,currentPhase) = departures(j,currentPhase) + 1;
            end
        end
    end
end

for i = 1:noOfLinks
    for k = 1:numel(phaseSets)
        avgArrivalRate(i) = avgArrivalRate(i) + departures(i,k)/simTime;
        if departureTime(k) ~= 0
            departureRate(i,k) = departureRate(i,k) + 1000*departures(i,k)/departureTime(k);
        end
    end
end
for i = 1:noOfLinks
    avgDepartureRate(i) = mean(departureRate(i,find(departureRate(i,:)>0)));
end
phaseIndex = 1;
noOfSkippedPhases = 0;
arrivalRate = zeros(noOfLinks,noOfCycles*noOfPhasesInACycle);
savedArrival = avgArrivalRate;

for i = 1:noOfLinks
    j = 1;
    for k = 1:noOfCycles*noOfPhasesInACycle
        if j <= numel(observedPhases) 
            if observedPhases(j) == phaseSequence(phaseIndex)
                for h = 0:noOfSkippedPhases
                    if ismember(i,phaseSets{observedPhases(j)})
                        arrivalRate(i,k-h) = avgArrivalRate(i)*(departureRate(i,observedPhases(j))/avgDepartureRate(i));
                        savedArrival(i) = arrivalRate(i,k-h);
                    else
                        arrivalRate(i,k-h) = savedArrival(i);
                    end
                end
                phaseIndex = phaseIndex + 1;
                if phaseIndex > noOfPhasesInACycle
                    phaseIndex = 1;
                end
                noOfSkippedPhases = 0;
                j = j + 1;
            else
                phaseIndex = phaseIndex + 1;
                noOfSkippedPhases = noOfSkippedPhases + 1;
                if phaseIndex > noOfPhasesInACycle
                    phaseIndex = 1;
                end
            end
        else
            if phaseIndex < numel(phaseSets)
                arrivalRate(i,k) = arrivalRate(i,k-1);
                phaseIndex = phaseIndex + 1;
            end
        end
    end
end

for i = 1:noOfLinks
    for k = 1:numel(phaseSets)
        if departureRate(i,k) < 0.3 && ismember(i,phaseSets{k})
            departureRate(i,k) = 0.3;
        end
    end
end

% Now we assign average departure rates for the links that we haven't
% observed any maneuvers from.

% departureRateSum = 0;
% a = 0;
% for i = 1:numel(departureRate)
%     if departureRate(i) ~= 0
%         departureRateSum = departureRateSum + departureRate(i);
%         a = a + 1;
%     end
% end
% for i = 1:numel(departureRate)
%     if departureRate(i) == 0
%         departureRate(i) = departureRateSum/a;
%     end
% end

% arrivalRate(1) = 0.5*departures(1)/simTime;
% arrivalRate(2) = 0.5*departures(1)/simTime;
% arrivalRate(3) = 0.5*departures(2)/simTime;
% arrivalRate(4) = 0.5*departures(2)/simTime;
% 
% departureRate(1) = 1000*0.5*departures(1)/departureTime(1);
% departureRate(2) = 1000*0.5*departures(1)/departureTime(1);
% departureRate(3) = 1000*0.5*departures(2)/departureTime(2);
% departureRate(4) = 1000*0.5*departures(2)/departureTime(2);

    