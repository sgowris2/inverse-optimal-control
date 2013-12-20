function [] = plotPolicyWithoutZeros(DataSet, agentDataSet)

global noOfPhasesInACycle;
global policyIndex;

figure;
plot(DataSet{policyIndex},mod(1:size(DataSet{policyIndex}),-noOfPhasesInACycle)+8 ,'o:')
hold on;
plot(agentDataSet{policyIndex}, mod(1:size(DataSet{policyIndex}),-noOfPhasesInACycle)+8,'sr-')

title('Observed vs. Simulated policy');
xlabel('Time(s)');
ylabel('Phase #');
legend('Observed phase switches','Simulated phase switches');

figure;
plot(DataSet{policyIndex},1:size(DataSet{policyIndex}) ,'o')
hold on;
plot(agentDataSet{policyIndex}, 1:size(DataSet{policyIndex}),'sr')
title('Observed vs. Simulated policy');
xlabel('Time(s)');
ylabel('Phase switch #');
legend('Observed phase switches','Simulated phase switches');

figure;
A = DataSet{policyIndex}(2:end) - DataSet{policyIndex}(1:end-1);
A = [DataSet{policyIndex}(1);A];
B = (agentDataSet{policyIndex}(2:end) - agentDataSet{policyIndex}(1:end-1));
B = [agentDataSet{policyIndex}(1);B];
C = [A,B];
AWithoutZeros = [];
for i = 1:size(C,1)
    if C(i,1) > 0.1 || C(i,2) > 0.1
        AWithoutZeros = [AWithoutZeros;C(i,:)];
    end
end
bar(AWithoutZeros,'grouped');
title('Observed vs. Simulated phase lengths');
xlabel('Phase #');
ylabel('Phase length (s)');
legend('Observed phase lengths', 'Simulated phase lengths');