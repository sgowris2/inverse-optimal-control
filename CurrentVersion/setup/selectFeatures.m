        
maxPhases = 8;
maxLinks = 8;

        cycle = 1;
        
         allPhases = 1;
            phase1 = allPhases;                  
            phase2 = allPhases;            
            phase3 = allPhases;            
            phase4 = allPhases;
            phase5 = allPhases;
            phase6 = allPhases;
            phase7 = allPhases;
            phase8 = allPhases;
            
         allQueuesL1 = 1;
            queue1LengthL1 = allQueuesL1;
            queue2LengthL1 = allQueuesL1;
            queue3LengthL1 = allQueuesL1;
            queue4LengthL1 = allQueuesL1;
            queue5LengthL1 = allQueuesL1;
            queue6LengthL1 = allQueuesL1;
            queue7LengthL1 = allQueuesL1;
            queue8LengthL1 = allQueuesL1;
            
        allQueuesL2 = 1;
            queue1 = allQueuesL2;
            queue2 = allQueuesL2;
            queue3 = allQueuesL2;
            queue4 = allQueuesL2;
            queue5 = allQueuesL2;
            queue6 = allQueuesL2;
            queue7 = allQueuesL2;
            queue8 = allQueuesL2;        
            
        allDelay = 1;
            delay1 = allDelay;
            delay2 = allDelay;
            delay3 = allDelay;
            delay4 = allDelay;
            delay5 = allDelay;
            delay6 = allDelay;
            delay7 = allDelay;
            delay8 = allDelay;
            
            
        allPhasesAvgLength = 1;
        if experimentalData == 0
            allPhasesAvgLength = 0;
        end
            phase1AvgLength = allPhasesAvgLength;
            phase2AvgLength = allPhasesAvgLength;
            phase3AvgLength = allPhasesAvgLength;
            phase4AvgLength = allPhasesAvgLength;
            phase5AvgLength = allPhasesAvgLength;
            phase6AvgLength = allPhasesAvgLength;
            phase7AvgLength = allPhasesAvgLength;
            phase8AvgLength = allPhasesAvgLength;
            
         
    featureSelection = [cycle...
                    ,phase1,phase2,phase3,phase4,phase5,phase6,phase7,phase8...
                    ,queue1LengthL1,queue2LengthL1,queue3LengthL1,queue4LengthL1,queue5LengthL1,queue6LengthL1,queue7LengthL1,queue8LengthL1...
                    ,queue1,queue2,queue3,queue4,queue5,queue6,queue7,queue8...
                    ,delay1,delay2,delay3,delay4,delay5,delay6,delay7,delay8...
                    ,phase1AvgLength, phase2AvgLength,phase3AvgLength,phase4AvgLength,phase5AvgLength,phase6AvgLength,phase7AvgLength,phase8AvgLength...
                    %phase1LengthL1,phase2LengthL1,phase3LengthL1,phase4LengthL1,phase5LengthL1,phase6LengthL1,phase7LengthL1,phase8LengthL1,...
                    %queue1LeftTurnPenalty,queue2LeftTurnPenalty,queue3LeftTurnPenalty,queue4LeftTurnPenalty,queue5LeftTurnPenalty,queue6LeftTurnPenalty,queue7LeftTurnPenalty,queue8LeftTurnPenalty...
                    ];