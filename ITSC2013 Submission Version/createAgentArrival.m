function [arrivalRateAgent] = createAgentArrival(stdDev)

global arrivalRate;

epsilon = normrnd(0, stdDev);
arrivalRateAgent = arrivalRate + (arrivalRate * epsilon);
arrivalRateAgent = max(arrivalRateAgent, 0);

