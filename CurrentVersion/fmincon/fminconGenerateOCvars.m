function [A,b,Aeq,beq] = fminconGenerateOCvars(localDataSet)

%to modify as needed (possibly output f too)

%the inputs is:
%one DataSet structure that contains all the data in a format that is
%defined and known to unpackDataSet.m

%alpha is a iMax by n matrix of alpha(i,k) values.
%to make life simple, I store alpha(i,0) values in the vector alpha0(i),
%which you must also send in.

%l0 is a vector of length iMax with l0(i) values (it is ell zero, not ten)
%deltaMin and deltaMax are the scalar bounds on delta

% the first block of code builds variables which help with indexing-----
% define the index of the human readable variables are stored in x.

% assume x=[l(1,1),l(2,1),...,l(i,k),...,l(iMax,n), t0,...,tn,delta1,...,deltan]
% note I got rid of all variables at time zero, this means I need to 
% write special equations later, but will simplify constraint generation
% syntax.

[noOfLinks, noOfPhasesInACycle, minPhaseLength, ...
maxPhaseLength, noOfCycles, simTime, arrivalRate,...
departureRate, lInitial, phaseSets, phaseSequence, zeroTimePhases] = unpackDataSet(localDataSet);

iMax = noOfLinks;
n = noOfPhasesInACycle*noOfCycles;
tf = simTime;
t0 = 0;
deltaMin = minPhaseLength;
deltaMax = maxPhaseLength;
l0 = lInitial;
alpha = createAlpha(iMax, noOfPhasesInACycle, arrivalRate, departureRate, phaseSets, noOfCycles, phaseSequence);

global l;
global delta;
global t;

%define a variable l, which stores the indexes of where l(i,k) is located
%in the generic x
l = zeros(iMax,n);
xLocation = 1;
for k = 1:n
    for i = 1:iMax
    l(i,k)= xLocation;
    xLocation = xLocation + 1; % increment the marker
    end
end

%similarly, define t (note we do not reset xLocation, it is currently
%at iMax*n+1) 
t = zeros(n, 1);
for k = 1:n
    t(k) = xLocation;
    xLocation = xLocation + 1; % increment the marker
end

% finally, define delta
delta = zeros(n, 1);
for k = 1:n
    delta(k) = xLocation;
    xLocation = xLocation + 1; % increment the marker
end

%End of variable index----------



% start generating constraints....-----------
eqNum = 1; %equality constraint number (i.e. index, location, etc) 
ineqNum = 1; %inequality constraint number (index)

% I am ignoring the constraint t0=0, I will take care of it later, as you will see

A=zeros((noOfLinks+2)*n,iMax*n + 2*n); %preallocate
Aeq=zeros(n+1,iMax*n + 2*n); %preallocate
b=zeros((noOfLinks+2)*n,1); %preallocate
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
for k = 1:n
    if ismember(k,zeroTimePhases)
        Aeq(eqNum,delta(k)) = 1;
        beq(eqNum,1) = 0; % not really needed
        eqNum = eqNum + 1;
    end
end

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
    for i = 1:iMax
        A(ineqNum,delta(k+1)) = alpha(i,k+1);
        A(ineqNum,l(i,k+1)) = -1;
        b(ineqNum,1) = -l0(i); %this line handles the initial condition on led b as zeros
        ineqNum = ineqNum + 1; 
    end

for k = 1:n-1
    for i = 1:iMax
        A(ineqNum,l(i,k)) = 1;
        A(ineqNum,delta(k+1)) = alpha(i, k+1);
        A(ineqNum,l(i,k+1)) = -1;
        b(ineqNum,1) = 0; %this line is technically not needed since we initialized b as zeros
        ineqNum = ineqNum + 1;
    end
end

for k = 1:n
    for i = 1:iMax
        A(ineqNum, l(i,k)) = -1;
        b(ineqNum,1) = 0;
        ineqNum = ineqNum + 1;
    end
end

% you can continue to add in constraints in Aeq (e.g. -l(i,k)<=0), or you
% could directly build the vectors lb and rb, and return those.

% you also need to build the objective function values, in a similar way.

%this is just an example to give you an idea of how to do this, you can
%extend it to run your weights optimization problem.