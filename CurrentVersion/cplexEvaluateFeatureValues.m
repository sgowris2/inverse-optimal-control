function [featureArray] = cplexEvaluateFeatureValues(x)

global xExpertCombined;
global noOfCycles;
global noOfPhasesInACycle;
global phaseSequence;
global noOfLinks;
global featureSelection;

[l,t,delta] = xIndexing(noOfLinks,noOfCycles{1}*noOfPhasesInACycle);

J{1} = objJ1_allQ(l,numel(xExpertCombined));
J{2} = objJ2_cycleLength(delta,noOfCycles{1},noOfPhasesInACycle,numel(xExpertCombined));
for i = 1:noOfLinks
    J{i+2} = objJ_queueLength(i,l,numel(xExpertCombined));
end
for i = 1:numel(phaseSequence)
    J{i+10} = objJ_phaseLength(i,xExpertCombined,phaseSequence,delta,noOfCycles{1},numel(xExpertCombined));
end
for i = 1:numel(phaseSequence)
    [J{i+18} f{i+18} g{i+18}] = objJ_phaseAvgLength(i,xExpertCombined,phaseSequence,delta,numel(xExpertCombined));
end
for i = 1:numel(phaseSequence)
    [J{i+26} f{i+26}] = objJ_phaseLengthL1(i,phaseSequence,delta,numel(xExpertCombined));
end
for i = 1:noOfLinks
    [J{i+34} f{i+34}] = objJ_queueLengthL1(i,l,numel(xExpertCombined));
end

for i = 1:42
    if numel(J) >= i
        if numel(J{i})>1 && numel(f{i})>1
            featureArray(i) = featureSelection(i) * (x'*J{i}*x + f{i}*x);
        elseif numel(J{i})>1 && numel(f{i})<1
            featureArray(i) = featureSelection(i) * x'*J{i}*x;
        elseif numel(J{i})<1 && numel(f{i})>1
            featureArray(i) = featureSelection(i) * f{i}*x;
        else
            featureArray(i) = 0;
        end
        if numel(g) >= i
            if numel(g{i}) == 1
                featureArray(i) = featureArray(i) + g{i};
            end
        end
    end
end

