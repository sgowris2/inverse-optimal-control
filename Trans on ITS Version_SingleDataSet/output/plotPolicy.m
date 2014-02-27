function [] = plotPolicy(DataSet, agentDataSet)

global noOfPhasesInACycle;
global policyIndex;

figure;
plot(DataSet{policyIndex},mod(1:size(DataSet{policyIndex}),-noOfPhasesInACycle)+8 ,'o:')
hold on;
plot(agentDataSet{policyIndex}, mod(1:size(DataSet{policyIndex}),-noOfPhasesInACycle)+8,'sr-')

title('True vs. estimated policy');
xlabel('Time(s)');
ylabel('Phase #');
legend('True phase switches','Estimated phase switches');

figure;
plot(DataSet{policyIndex},1:size(DataSet{policyIndex}) ,'o')
hold on;
plot(agentDataSet{policyIndex}, 1:size(DataSet{policyIndex}),'sr')
title('True vs. estimated policy');
xlabel('Time(s)');
ylabel('Phase switch #');
legend('True phase switches','Estimated phase switches');

figure;
A = DataSet{policyIndex}(2:end) - DataSet{policyIndex}(1:end-1);
A = [DataSet{policyIndex}(1);A];
B = (agentDataSet{policyIndex}(2:end) - agentDataSet{policyIndex}(1:end-1));
B = [agentDataSet{policyIndex}(1);B];
A = [A,B];
bar(A,'grouped');
title('True vs. Estimated phase lengths');
xlabel('Phase #');
ylabel('Phase length (s)');
legend('True phase lengths', 'Estimated phase lengths');
