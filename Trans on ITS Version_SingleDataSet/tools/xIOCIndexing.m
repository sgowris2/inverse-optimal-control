function [weightsPos,lambdaPos,nuPos,r1Pos,r2Pos] = xIOCIndexing(weightsSize,lambdaSize,nuSize,r1Size)

xPos = 1;
for i=1:weightsSize
    weightsPos(i) = xPos;
    xPos = xPos+1;
end
for i=1:lambdaSize
    lambdaPos(i) = xPos;
    xPos = xPos+1;
end
for i=1:nuSize
    nuPos(i) = xPos;
    xPos = xPos+1;
end
for i=1:r1Size
    r1Pos(i) = xPos;
    xPos = xPos+1;
end
for i=1:1
    r2Pos(i) = xPos;
    xPos = xPos+1;
end