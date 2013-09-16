function R = R_2(x)

global r1Size;
global r2Size;

R = sum((x(1:r1Size)).^2) + sum((x(r1Size+1:r1Size+r2Size)).^2);
%R = norm(x(1:r1Size),2)^2 + norm(x(r1Size+1:r1Size+r2Size),2)^2;
