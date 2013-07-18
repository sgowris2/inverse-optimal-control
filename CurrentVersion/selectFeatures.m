if generalizedObj == 1
    fprintf('Using a generalized objective function.\n');
    allQueuesPower = 3;
    allPhaseLengthsPower = 3;
    
    featureSelection = ones(1,allQueuesPower + allPhaseLengthsPower);
    
else
    if cycleFeatures == 0
        fprintf('Using feature selected objective function.\n');
        allQueues = 0;
        cycle = 1;
        allQueuesL2 = 1;
            queue1 = allQueuesL2;
            queue2 = allQueuesL2;
            queue3 = allQueuesL2;
            queue4 = allQueuesL2;
            queue5 = allQueuesL2;
            queue6 = allQueuesL2;
            queue7 = allQueuesL2;
            queue8 = allQueuesL2;
        
        allPhases = 1;
            phase1 = allPhases;                  
            phase2 = allPhases;            
            phase3 = allPhases;            
            phase4 = allPhases;
            phase5 = allPhases;
            phase6 = allPhases;
            phase7 = allPhases;
            phase8 = allPhases;
            
        allPhasesAvgLength = 1;    
            phase1AvgLength = allPhasesAvgLength;
            phase2AvgLength = allPhasesAvgLength;
            phase3AvgLength = allPhasesAvgLength;
            phase4AvgLength = allPhasesAvgLength;
            phase5AvgLength = allPhasesAvgLength;
            phase6AvgLength = allPhasesAvgLength;
            phase7AvgLength = allPhasesAvgLength;
            phase8AvgLength = allPhasesAvgLength;
            
        allPhasesLengthL1 = 0;
            phase1LengthL1 = allPhasesLengthL1;            
            phase2LengthL1 = allPhasesLengthL1;          
            phase3LengthL1 = allPhasesLengthL1;
            phase4LengthL1 = allPhasesLengthL1;
            phase5LengthL1 = allPhasesLengthL1;
            phase6LengthL1 = allPhasesLengthL1;
            phase7LengthL1 = allPhasesLengthL1;
            phase8LengthL1 = allPhasesLengthL1;
            
        allQueuesL1 = 1;
            queue1LengthL1 = allQueuesL1;
            queue2LengthL1 = allQueuesL1;
            queue3LengthL1 = allQueuesL1;
            queue4LengthL1 = allQueuesL1;
            queue5LengthL1 = allQueuesL1;
            queue6LengthL1 = allQueuesL1;
            queue7LengthL1 = allQueuesL1;
            queue8LengthL1 = allQueuesL1;
            
        allLeftTurnPenalties = 0;
            queue1LeftTurnPenalty = allLeftTurnPenalties;
            %queue1LeftTurnPenalty = 0;
            queue2LeftTurnPenalty = allLeftTurnPenalties;
            queue3LeftTurnPenalty = allLeftTurnPenalties;
            %queue3LeftTurnPenalty = 0;
            queue4LeftTurnPenalty = allLeftTurnPenalties;
            queue5LeftTurnPenalty = allLeftTurnPenalties;
            %queue5LeftTurnPenalty = 0;
            queue6LeftTurnPenalty = allLeftTurnPenalties;
            queue7LeftTurnPenalty = allLeftTurnPenalties;
            %queue7LeftTurnPenalty = 0;
            queue8LeftTurnPenalty = allLeftTurnPenalties;
        
    else
        n = 24;
        totalCombinations = 0;
        for i = 1:n
            totalCombinations = totalCombinations + factorial(n)/(factorial(i)*factorial(n-i));
        end
    end    
    featureSelection = [allQueues,cycle,...
                    queue1,queue2,queue3,queue4,queue5,queue6,queue7,queue8...
                    phase1,phase2,phase3,phase4,phase5,phase6,phase7,phase8...
                    phase1AvgLength, phase2AvgLength,phase3AvgLength,phase4AvgLength,phase5AvgLength,phase6AvgLength,phase7AvgLength,phase8AvgLength,...
                    phase1LengthL1,phase2LengthL1,phase3LengthL1,phase4LengthL1,phase5LengthL1,phase6LengthL1,phase7LengthL1,phase8LengthL1,...
                    queue1LengthL1,queue2LengthL1,queue3LengthL1,queue4LengthL1,queue5LengthL1,queue6LengthL1,queue7LengthL1,queue8LengthL1,...
                    queue1LeftTurnPenalty,queue2LeftTurnPenalty,queue3LeftTurnPenalty,queue4LeftTurnPenalty,queue5LeftTurnPenalty,queue6LeftTurnPenalty,queue7LeftTurnPenalty,queue8LeftTurnPenalty];
end