function [A,b,Aeq,beq,lb,ub] = cplexGenerateOCConstSet(m,n,l,t,delta,alpha,minPhaseLength,maxPhaseLength,zeroTimePhases,l0,simTime,agentSimTime,expertFlag)

t0 = 0;
tf = simTime;
deltaMin = minPhaseLength;
deltaMax = maxPhaseLength;

% start generating constraints....-----------
eqNum = 1; %equality constraint number (i.e. index, location, etc) 
ineqNum = 1; %inequality constraint number (index)

% I am ignoring the constraint t0=0, I will take care of it later, as you will see

A=zeros((m+2)*n,m*n + 2*n); %preallocate
Aeq=zeros(n+1,m*n + 2*n); %preallocate
b=zeros((m+2)*n,1); %preallocate
beq=zeros(n+1,1); %preallocate

%first constraint t(n)=tf
Aeq(eqNum,t(n)) = 1;
beq(eqNum) = tf;
eqNum = eqNum + 1;  %DONT FORGET TO ALWAYS INCREMENT!!!

%skipping l(i,0) constraints, will treat later...

% delta definition delta(k)-t(k)+t(k-1)=0
%treat first the case when k=1;
k = 1;
    Aeq(eqNum,delta(k)) = 1;
    Aeq(eqNum,t(k)) = -1;
    beq(eqNum,1) = -t0;
    eqNum = eqNum + 1;
% now treat the rest of the ks
for k = 2:n
    Aeq(eqNum,delta(k)) = 1;
    Aeq(eqNum,t(k)) = -1;
    Aeq(eqNum,t(k-1)) = 1;
    beq(eqNum,1) = 0; %not really needed, b was initialized as zeros
    eqNum = eqNum + 1;
end
% now we treat the zero length phases
% for k = 1:n
%     if ismember(k,zeroTimePhases)
%         Aeq(eqNum,delta(k)) = 1;
%         beq(eqNum,1) = 0; % not really needed
%         eqNum = eqNum + 1;
%     end
% end

%delta Min constraints: -delta(k)<=-deltaMin
for k = 1:n
    A(ineqNum,delta(k)) = -1;
    b(ineqNum,1) = -deltaMin;
    ineqNum = ineqNum + 1;
end

%deltaMax constraints: delta(k)<=deltaMax
for k = 1:n
    A(ineqNum,delta(k)) = 1;
    b(ineqNum,1)= deltaMax;
    ineqNum = ineqNum + 1;
end

% constraint on l: l(i,k)+alpha(i,k+1)*delta(k+1)-l(i,k+1)<=0
% special equation for k=0, since we did not make l(i,0) a variable
% specifcally, it handles alpha(i,k+1)*delta(k+1)-l(i,k+1)<=-l0(i)
k = 0;
    for i = 1:m
        A(ineqNum,delta(k+1)) = alpha(i,k+1);
        A(ineqNum,l(i,k+1)) = -1;
        b(ineqNum,1) = -l0(i); %this line handles the initial condition on led b as zeros
        ineqNum = ineqNum + 1; 
    end

for k = 1:n-1
    for i = 1:m
        A(ineqNum,l(i,k)) = 1;
        A(ineqNum,delta(k+1)) = alpha(i, k+1);
        A(ineqNum,l(i,k+1)) = -1;
        b(ineqNum,1) = 0; %this line is technically not needed since we initialized b as zeros
        ineqNum = ineqNum + 1;
    end
end

for k = 1:n
    for i = 1:m
        A(ineqNum, l(i,k)) = -1;
        b(ineqNum,1) = 0;
        ineqNum = ineqNum + 1;
    end
end

lb = zeros((m*n + 2*n), 1);
for i = (m*n + n)+1 : size(lb,1)
    if ~ismember(i-(m*n+n),zeroTimePhases)
        lb(i) = minPhaseLength;
    end
end

ub = zeros((m*n + 2*n), 1);
for i = (m*n+n)+1 : size(ub,1)
    if ismember(i-(m*n+n),zeroTimePhases)
        %ub(i) = 0;
        ub(i) = maxPhaseLength;
    else
        ub(i) = maxPhaseLength;
    end
end
for i = 1:m*n
    ub(i) = 10000;
end
for i = m*n+1 : m*n + n
    if expertFlag == 1
        ub(i) = simTime;
    else
        ub(i) = agentSimTime;
    end
end

