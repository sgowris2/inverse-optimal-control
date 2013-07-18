function [DataSet] = LearnWeights(DataSet, experiment, simulator)

global xExpertCombined;
global xIndex;
global policyIndex;
global dataSetLoopIndex;
global A;
global Aeq;
global b;
global beq;
global weights;
global noOfPhasesIndex;
global agentNoOfPhases;
global fvalExpert;
global noOfCycles;
global noOfLinks;
global noOfPhasesInACycle;
global phaseSets;
global phaseSequence;
global mandatoryPhases;

d = numel(DataSet);

first = 1;
for dataSetLoopIndex = 1:d
    %[ATemp,bTemp,AeqTemp,beqTemp] = fminconGenerateOCPvars(DataSet{dataSetLoopIndex});
    [HTemp,fTemp,ATemp,bTemp,AeqTemp,beqTemp,lbTemp,ubTemp] = cplexGenerateOCvars(DataSet{dataSetLoopIndex},1,experiment);
    if first == 1
        A = ATemp;
        b = bTemp;
        Aeq = AeqTemp;
        beq = beqTemp;
        first = 0;
        if experiment == 0
            if simulator == 0
                [DataSet{dataSetLoopIndex}{xIndex}, fvalExpert, DataSet{dataSetLoopIndex}{policyIndex}] = cplexOCSolver(HTemp,fTemp,ATemp,bTemp,AeqTemp,beqTemp,lbTemp,ubTemp,1,DataSet{dataSetLoopIndex});
            else
                [xSimulated policy observedPhases maneuversSequence simTime] = intersectionSimulatorSemiAdaptive(noOfCycles{dataSetLoopIndex});
                %[xSimulated policy observedPhases maneuversSequence simTime] = intersectionSimulatorFullyAdaptive(noOfCycles{dataSetLoopIndex});
                simulatedCSV = createSimulatedCSV(policy, maneuversSequence);
                maneuvers = generateSimulatedManeuvers();
                [arrivalRate, departureRate] = deduceArrivalDepartureRates(simulatedCSV, simTime, observedPhases, maneuvers);
                [alpha] = createAlpha(noOfLinks, noOfPhasesInACycle, arrivalRate, departureRate, phaseSets, noOfCycles{dataSetLoopIndex}, phaseSequence);
                [zeroTimePhases] = deduceZeroTimePhases(observedPhases, phaseSequence);
                DataSet{dataSetLoopIndex} = packageDataSets(1, noOfLinks, noOfPhasesInACycle,...
                                        0, 300, noOfCycles{dataSetLoopIndex},...
                                        simTime, arrivalRate, departureRate, zeros(1,noOfLinks),...
                                        phaseSets, phaseSequence, zeroTimePhases,alpha);
                DataSet{dataSetLoopIndex}{xIndex} = xSimulated;
                DataSet{dataSetLoopIndex}{policyIndex} = policy;
            end
        end
    else
        if experiment == 0
            [DataSet{dataSetLoopIndex}{xIndex}, fvalExpert, DataSet{dataSetLoopIndex}{policyIndex}] = cplexOCSolver(HTemp,fTemp,ATemp,bTemp,AeqTemp,beqTemp,lbTemp,ubTemp,1,DataSet{dataSetLoopIndex});
        end
        empty1 = zeros(size(A,1),size(ATemp,2));
        empty2 = zeros((size(ATemp,1)),(size(A,2)));
        A = [A empty1; empty2 ATemp];
        b = [b;bTemp];
        emptyEq1 = zeros(size(Aeq,1),size(AeqTemp,2));
        emptyEq2 = zeros((size(AeqTemp,1)),(size(Aeq,2)));
        Aeq = [Aeq emptyEq1;emptyEq2 AeqTemp];
        beq = [beq;beqTemp];
    end
end

% for i = 1:d
%     if i == 1
%         xExpertCombined = DataSet{i}{xIndex};
%     else
%         xExpertCombined = [xExpertCombined;DataSet{i}{xIndex}];
%     end
% end

%[AIOC,bIOC,AeqIOC,beqIOC,x0] = generateIOCvars(A,Aeq);
%weights = fminconIOCSolver();

xExpertCombined = DataSet{1}{xIndex};
weights = cplexIOCSolver(A,Aeq,DataSet{1});

