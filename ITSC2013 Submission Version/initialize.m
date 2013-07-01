function [noOfLinks, noOfPhases, simTime, departureRate, minPhaseLength, maxPhaseLength, lInitial] = initialize()

noOfPhases = 15;
noOfLinks = 2;
simTime = 1200; % seconds
departureRate = [3200/3600; 3200/3600]; %per second
minPhaseLength = 45;
maxPhaseLength = 180;
lInitial = [10 10];



