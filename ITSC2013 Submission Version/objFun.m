function [R] = objFun(x)

global A;
global Aeq;
global b;
global beq;
global xExpert;
global noOfLinks;
global noOfPhases;
global l;
global delta;
global t;
global Q;
global H;

n = noOfPhases;
iMax = noOfLinks;

weights(1,1) = x(1);
weights(2,1) = x(2);
lambda(:,1) = x(3:(2*iMax*n)+(2*n)+2, 1);
nu(:,1) = x((2*iMax*n)+(2*n)+3:(2*iMax*n)+(2*n)+2+n+1);

% Create Q Here
Q = zeros(size(xExpert, 1));
objNum = 1;
for k = 1:n
    for i = 1:iMax
        Q(objNum,l(i,k)) = (weights(1));
        objNum = objNum + 1;
    end
end
for k = 1:n
    Q(objNum, t(k)) = 0;
    objNum = objNum + 1;
end
for k = 1:n
    Q(objNum,delta(k)) = (weights(2));
    objNum = objNum + 1;
end

% Compute r1 here.
r1 = 2*Q*xExpert + (lambda'*A)' + (nu'*Aeq)';

%Compute r2 here.
r2 = lambda.*(A*xExpert - b);

%Compute r3 here.
%r3 = Aeq*xExpert - beq;

%Compute r4 here.
%r4 = A*xExpert - b;

%R = norm(r1,2) + r2^2;
R = norm(r1,2)^2 + norm(r2,2)^2;


