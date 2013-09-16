function [expertWeights] = drawRandomWeights(weightIndex, featureSelectionIndex)

global noOfLinks;

if sum(weightIndex(2:9)) < noOfLinks && sum(weightIndex(10:17)) < noOfLinks
    addqueueWeights = 1;
else
    addqueueWeights = 0;
end

expertWeightNum = 0;
for j = 1:numel(featureSelectionIndex)
    if featureSelectionIndex(j) > 0
        expertWeightNum = expertWeightNum + 1;
        if weightIndex(j) > 0
            expertWeights(expertWeightNum) = rand(1,1);
        else
            if addqueueWeights == 1 && ismember(j,[10,11,12,13,14,15,16,17])
                expertWeights(expertWeightNum) = 0.01;
            else
                expertWeights(expertWeightNum) = 0;
            end
        end
    end
end

expertWeights = normalizeWeights(expertWeights);
