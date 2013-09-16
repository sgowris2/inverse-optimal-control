function [arrival] = arrivals(linkNo,arrivalMeans,arrivalStdDev)

arrival = arrivalMeans(linkNo)+ arrivalStdDev(linkNo)*randn(1,1);
if arrival < 0
    arrival = 0;
end