function [arrivalRateDistributed, departureRate] = deduceArrivalDepartureRates(RAW, simTime, observedPhases,...
                                                                    maneuvers)

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
arrivalRate = zeros(1,noOfLinks);
departureRate = zeros(noOfLinks,noOfPhasesInACycle);
departuresByPhase = zeros(noOfLinks,numel(observedPhases));
departureTimeByPhase = zeros(1,numel(observedPhases));


for i = 2:size(RAW,1)-1
    if i == size(RAW,1)-1
        departureTimeByPhase(currentPhaseIndex) = RAW{i+1,timestampIndex} - phaseStart;
    end
    if RAW{i, maneuverIndex} == -1
        currentPhaseIndex = currentPhaseIndex + 1;
        departureTimeByPhase(currentPhaseIndex-1) = RAW{i,timestampIndex} - phaseStart;
        departureTime(currentPhase) = departureTime(currentPhase) + RAW{i,timestampIndex} - phaseStart;
        currentPhase = observedPhases(currentPhaseIndex);
        phaseStart = RAW{i,timestampIndex};
    else
        for j=1:noOfLinks
            if ismember(RAW{i,maneuverIndex}, maneuvers{j})
                departuresByPhase(j,currentPhaseIndex) = departuresByPhase(j,currentPhaseIndex) + 1;
                departures(j,currentPhase) = departures(j,currentPhase) + 1;
            end
        end
    end
end

for i = 1:noOfLinks
    for k = 1:numel(phaseSets)        
        arrivalRate(i) = arrivalRate(i) + departures(i,k)/simTime;
        if departureTime(k) ~= 0
            departureRate(i,k) = departureRate(i,k) + 1000*departures(i,k)/departureTime(k);
            if departureRate(i,k) < 0.3 && ismember(i,phaseSets{k})
                departureRate(i,k) = 0.3;
            end
        end
    end
end

cMax = numel(find(observedPhases == 2));
index = 1;
departuresByCycle = zeros(1,cMax);
departureTimeByCycle = zeros(1,cMax);
for c = 1:cMax
    for k = 1:noOfPhasesInACycle
        if k == noOfPhasesInACycle
            if observedPhases(index) == phaseSequence(k)
                departuresByCycle(c) = departuresByCycle(c) + sum(departuresByPhase(:,index));
                departureTimeByCycle(c) = departureTimeByCycle(c) + departureTimeByPhase(index);
                index = index + 1;
            end
            departureRateByCycle(c) = (1000*departuresByCycle(c)/departureTimeByCycle(c));
        else
            if observedPhases(index) == phaseSequence(k)
                departuresByCycle(c) = departuresByCycle(c) + sum(departuresByPhase(:,index));
                departureTimeByCycle(c) = departureTimeByCycle(c) + departureTimeByPhase(index);
                index = index + 1;
            end
        end
    end
end

for i = 1:noOfLinks
    for c = 1:cMax;
        for k = 1:noOfPhasesInACycle
            arrivalRateDistributed(i,(c-1)*noOfPhasesInACycle + k) = arrivalRate(i)*(departureRateByCycle(c)/mean(departureRateByCycle));
        end
    end
end