function [xSimulated policy simulatedPhaseSequence maneuversSequence simTime] = intersectionSimulatorSemiAdaptive(noOfCycles)

% global noOfLinks;
% global noOfPhasesInACycle;
% global phaseSequence;
% global arrivalMeans;
% global departureMeans;
% global arrivalStdDev;
% global departureStdDev;
% global maxPhaseLengths;
% global minPhaseLengths;
% global phaseSets;

noOfLinks = 4;                      % No of links at the intersection (There is no right turn lane)
phaseSequence = [1,2];  % Sequence of phases at the intersection
noOfPhasesInACycle = numel(phaseSequence);

phaseSets{1} = [1,2];       % Contains the indices of the links that have a green in phase 1
phaseSets{2} = [3,4];       % Contains the indices of the links that have a green in phase 2

departureStdDev = zeros(noOfLinks);
arrivalStdDev = zeros(noOfLinks);

arrivalMeans = [0.15 0.12 0.18 0.13];   % The mean arrival rate for the normal distribution from which arrival rates are chosen for each link
arrivalStdDev = [0.05 0.05 0.05 0.05];  % The standard deviation of arrivals for the normal distribution from which arrival rates are chosen for each link
departureMeans = [0.3 0.3 0.3 0.3]; % The mean departure rate for the normal distribution from which departure rates are chosen for each link

minPhaseLengths = [20 20];    % Minimum phase lengths for the corresponding phases
maxPhaseLengths = [40 40];  % Maximum phase lengths for the corresponding phases

rightTurnFraction = 0.2;

%%%%% IF YOU WANT TO CHANGE ANYTHING BEYOND THIS POINT, YOU BETTER KNOW
%%%%% WHAT YOU ARE DOING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maneuversSequence = [0];
maneuvers = zeros(noOfLinks, noOfCycles*noOfPhasesInACycle);

simulatedPhaseSequence = 1;

nextSet = [];

[l t delta] = xIndexing(noOfLinks, noOfCycles*noOfPhasesInACycle);

xSimulated = zeros(numel(l)+numel(t)+numel(delta),1);

currentQueues = zeros(noOfLinks,1);
currentPhase = 1;
currentCyclePhase = 1;
currentPhaseLength = 0;
k = 0;

while currentPhase <= noOfCycles*noOfPhasesInACycle
    
    k = k + 1;
        for i = 1:noOfLinks
            if ismember(i,phaseSets{currentCyclePhase})
                greenLight = 1;
            else
                greenLight = 0;
            end
            prevQueue(i) = currentQueues(i);
            currentArrivals = arrivals(i,arrivalMeans, arrivalStdDev);
            currentDepartures = departures(i,departureMeans,departureStdDev);
            currentQueues(i) = prevQueue(i) + (currentArrivals - greenLight*currentDepartures);
            if currentQueues(i) < 0
                maneuvers(i,currentPhase) = maneuvers(i,currentPhase) + prevQueue(i) + currentArrivals;
                currentQueues(i) = 0;                
            else
                maneuvers(i,currentPhase) = maneuvers(i,currentPhase) + greenLight*currentDepartures;
            end
        end
        currentPhaseLength = currentPhaseLength + 1;
        
        newPhase = intersectionLogicSemiAdaptive(currentCyclePhase,currentQueues,currentPhaseLength,maxPhaseLengths,minPhaseLengths);
        
        if newPhase ~= currentCyclePhase
            currentPhaseIndex = find(phaseSequence == currentCyclePhase);
            nextPhaseIndex = find(phaseSequence == newPhase);
            if nextPhaseIndex - currentPhaseIndex == -(numel(phaseSequence)-1)
                phasesSkipped = 0;

            elseif nextPhaseIndex - currentPhaseIndex >= 1
                phasesSkipped = nextPhaseIndex - currentPhaseIndex - 1;
            else
                error('Hold on there just one second, something is wrong with the logic here and I have no idea what it is.');
            end
            
            xSimulated(t(currentPhase)) = k;
            xSimulated(delta(currentPhase)) = currentPhaseLength;
            currentPhaseLength = 0;
            for i = 1:noOfLinks
                xSimulated(l(i,currentPhase)) = currentQueues(i);
            end
            currentPhase = currentPhase + 1;        
            currentCyclePhase = newPhase;
            simulatedPhaseSequence = [simulatedPhaseSequence, currentCyclePhase];
        end
end
simTime = k;

policy = xSimulated(t(1:end));
for k = 1:noOfPhasesInACycle*noOfCycles
    maneuversSequence = [maneuversSequence; -1];
    for i = 1:noOfLinks
        if maneuvers(i,k) > 0
            if randn(1,1) > 1
                m = ceil(maneuvers(i,k));
            else
                m = floor(maneuvers(i,k));
            end
            nextSet = i*ones(1,m);
            if i == 1 || i == 3 || i == 5 || i == 7
                for h = 1:floor(rightTurnFraction*m)
                    nextSet(h) = nextSet(h)+noOfPhasesInACycle;
                end
            end
            shuffle(nextSet);
        end
        maneuversSequence = [maneuversSequence; nextSet'];
        nextSet = [];
    end
end

maneuversSequence = [maneuversSequence(2:end); -1];


        
        
        
        
        

