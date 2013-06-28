function [departure] = departures(linkNo,departureMeans,departureStdDev)


departure = departureMeans(linkNo)+ departureStdDev(linkNo)*randn(1,1);

if departure < 0 
    departure = 0;
end