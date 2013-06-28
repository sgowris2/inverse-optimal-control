function [noOfLinks, noOfPhases, simTime, departureRate, minPhaseLength, maxPhaseLength, lInitial] = initialize()

noOfPhases = 15;
noOfLinks = 2;
simTime = 1800; % seconds
%arrivalRate = [0.15; 0.04]; % per second
departureRate = [3200/3600; 3200/3600]; %per second
minPhaseLength = 45;
maxPhaseLength = 180;
lInitial = [10 10];
%alpha = createAlpha(noOfLinks, noOfPhases, arrivalRate, departureRate);



