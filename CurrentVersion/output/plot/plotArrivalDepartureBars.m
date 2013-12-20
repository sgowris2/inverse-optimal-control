function [] = plotArrivalDeparture(arrivalRate, departureRate)

figure;

subplot(2,1,1);
bar(arrivalRate,'grouped');
xlabel('Link #');
ylabel('ArrivalRate (veh/s)');
title('ArrivalRate(veh/s) for each link of the intersection for all phases');

subplot(2,1,2);
bar(departureRate, 'grouped');
xlabel('Link #');
ylabel('DepartureRate (veh/s)');
title('DepartureRate(veh/s) for each link of the intersection for each individual phase');
legend('Phase1','Phase2','Phase3','Phase4','Phase5','Phase6','Phase7','Phase8','Phase9');





