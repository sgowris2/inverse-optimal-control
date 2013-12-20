function [C,d] = cplexGenerateIOCvars(xSize,r1Size,r2Size,r1Pos,r2Pos)

C = zeros(r1Size+r2Size,xSize);
CPos = 1;
for i = 1:r1Size
    C(CPos,r1Pos(i)) = 1;
    CPos = CPos+1;
end
for i = 1:r2Size
    C(CPos,r2Pos(i)) = 1;
    CPos = CPos+1;
end

d = zeros(size(C,1),1);