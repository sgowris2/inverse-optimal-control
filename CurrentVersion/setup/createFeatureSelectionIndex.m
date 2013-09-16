featureSelectionIndex = zeros(1,weightsSize);
index = 1;
for i = 1:numel(featureSelection)
    if featureSelection(i) == 1
        featureSelectionIndex(i) = index;
        index = index + 1;
    else
        featureSelectionIndex(i) = 0;
    end
end