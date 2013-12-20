function [A,bL,bU,cL,cU,xL,xU] = tomlabGenerateOCConstSet(m,n,l,t,delta,alpha,minPhaseLength,maxPhaseLength,zeroTimePhases,l0,simTime,agentSimTime,expertFlag)

t0 = 0;
tf = simTime;
deltaMin = minPhaseLength;
deltaMax = maxPhaseLength;

% start generating constraints....-----------
eqNum = 1; %equality constraint number (i.e. index, location, etc) 
ineqNum = 1; %inequality constraint number (index)

% I am ignoring the constraint t0=0, I will take care of it later, as you will see

A = zeros(((m+2)*n)+(n+1), m*n+2*n); %preallocate
bL = zeros(((m+2)*n)+(n+1),1);
bU = zeros(((m+2)*n)+(n+1),1);

%first constraint t(n)=tf
A(eqNum,t(n)) = 1;
bL(eqNum) = tf;
bU(eqNum) = tf;
eqNum = eqNum + 1;  %DONT FORGET TO ALWAYS INCREMENT!!!

%skipping l(i,0) constraints, will treat later...

% delta definition delta(k)-t(k)+t(k-1)=0
%treat first the case when k=1;
k = 1;
    A(eqNum,delta(k)) = 1;
    A(eqNum,t(k)) = -1;
    bL(eqNum,1) = -t0;
    bU(eqNum,1) = -t0;
    eqNum = eqNum + 1;
% now treat the rest of the ks
for k = 2:n
    A(eqNum,delta(k)) = 1;
    A(eqNum,t(k)) = -1;
    A(eqNum,t(k-1)) = 1;
    bL(eqNum,1) = 0; %not really needed, b was initialized as zeros
    bU(eqNum,1) = 0;
    eqNum = eqNum + 1;
end

ineqNum = eqNum;

%delta Min and Max constraints:  deltaMin <= delta(k)<= deltaMax
for k = 1:n
    A(ineqNum,delta(k)) = 1;
    bL(ineqNum,1) = deltaMin;
    bU(ineqNum,1) = deltaMax;
    ineqNum = ineqNum + 1;
end

% constraint on l: l(i,k)+alpha(i,k+1)*delta(k+1)-l(i,k+1)<=0
% special equation for k=0, since we did not make l(i,0) a variable
% specifcally, it handles alpha(i,k+1)*delta(k+1)-l(i,k+1)<=-l0(i)
k = 0;
    for i = 1:m
        A(ineqNum,delta(k+1)) = alpha(i,k+1);
        A(ineqNum,l(i,k+1)) = -1;
        bU(ineqNum,1) = -l0(i); %this line handles the initial condition on led b as zeros
        bL(ineqNum,1) = -1e99;
        ineqNum = ineqNum + 1; 
    end

for k = 1:n-1
    for i = 1:m
        A(ineqNum,l(i,k)) = 1;
        A(ineqNum,delta(k+1)) = alpha(i,k+1);
        A(ineqNum,l(i,k+1)) = -1;
        bU(ineqNum,1) = 0; %this line is technically not needed since we initialized b as zeros
        bL(ineqNum,1) = -1e99;
        ineqNum = ineqNum + 1;
    end
end

for k = 1:n
    for i = 1:m
        A(ineqNum, l(i,k)) = -1;
        bU(ineqNum,1) = 0;
        bL(ineqNum,1) = -1e99;
        ineqNum = ineqNum + 1;
    end
end

xL = zeros((m*n + 2*n), 1);
for i = (m*n + n)+1 : size(xL,1)
    if ~ismember(i-(m*n+n),zeroTimePhases)
        xL(i) = minPhaseLength;
    end
end

xU = zeros((m*n + 2*n), 1);
for i = (m*n+n)+1 : size(xU,1)
    if ismember(i-(m*n+n),zeroTimePhases)
        %xU(i) = 0;
        xU(i) = maxPhaseLength;
    else
        xU(i) = maxPhaseLength;
    end
end
for i = 1:m*n
    xU(i) = 10000;
end
for i = m*n+1 : m*n + n
    if expertFlag == 1
        xU(i) = simTime;
    else
        xU(i) = agentSimTime;
    end
end

cL = [];
cU = [];


