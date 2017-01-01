%% Random Graph Test

% The RandomGraphTest class will generate a 100 nodes graph and permutate
% it a bit. Then test the algorithm on the two graphs.

clear
tStart = tic();
%% Basic Configuration Setup

% How many rounds
rounds = 100;

% The size if the test graph
size = 40;

% The range of the edge rate
weight_range = 1;  % update with edge_compatibility/node_compatibility
% How often two nodes are connected
connected_rate = 0.2;
% How many noise are there
noise_rate = 0.1;

% Scoring
score = zeros(rounds,3);
score_old = zeros(rounds,3);

%% Run the test
for i = 1:rounds
    disp(['Round ' num2str(i)])
    [s,s_o]=single_graph_test_compare(size, weight_range,connected_rate,noise_rate);
    score(i,:)=s;
    score_old(i,:)=s_o;
    disp(' ')
end
%% Calculate stat

recall = score(:,1)./score(:,2);
recall_old = score_old(:,1)./score_old(:,2);
[h_recall,p_recall] = ttest(recall, recall_old,'Alpha',0.05);
mean_recall = mean(recall)
mean_recall_old = mean(recall_old)
h_recall

precision = score(:,1)./score(:,3);
precision_old = score_old(:,1)./score_old(:,3);
[h_precision,p_precision] = ttest(precision, precision_old,'Alpha',0.05);
mean_precision = mean(precision)
mean_precision_old = mean(precision_old)
h_precision

f_measure = 2*precision.*recall./(precision+recall);
f_measure_old = 2*precision_old.*recall_old./(precision_old+recall_old);
f_measure(isnan(f_measure))=0;
f_measure_old(isnan(f_measure_old))=0;
[h_f,p_f] = ttest(f_measure, f_measure_old,'Alpha',0.05);
mean_f_measure = mean(f_measure)
mean_f_measure_old = mean(f_measure_old)
h_f

%% Plot Result

clf
subplot(2,3,1);
histogram(precision,0:0.02:1)
hold on
histogram(precision_old,0:0.02:1)
title('Precision Histogram Comparison')
xlabel('Precision') % x-axis label
ylabel('Percentage') % y-axis label
legend('new algo','old algo','Location','northwest')

subplot(2,3,2);
histogram(recall,0:0.02:1)
hold on
histogram(recall_old,0:0.02:1)
title('Recall Histogram Comparison')
xlabel('Recall') % x-axis label
ylabel('Percentage') % y-axis label
legend('new algo','old algo','Location','northwest')

subplot(2,3,3);
histogram(f_measure,0:0.02:1)
hold on
histogram(f_measure_old,0:0.02:1)
title('F Measure Histogram Comparison')
xlabel('F Measure') % x-axis label
ylabel('Percentage') % y-axis label
legend('new algo','old algo','Location','northwest')

subplot(2,3,4);
[f,x] = ecdf(precision);
plot(x,f);
[f,x] = ecdf(precision_old);
hold on
plot(x,f);
title('Precision Comparison')
xlabel('Precision') % x-axis label
ylabel('Cumulative Percentage') % y-axis label
legend('new algo','old algo','Location','northwest')

subplot(2,3,5);
[f,x] = ecdf(recall);
plot(x,f);
[f,x] = ecdf(recall_old);
hold on
plot(x,f);
title('Recall Comparison')
xlabel('Recall') % x-axis label
ylabel('Cumulative Percentage') % y-axis label
legend('new algo','old algo','Location','northwest')

subplot(2,3,6);
[f,x] = ecdf(f_measure);
plot(x,f);
[f,x] = ecdf(f_measure_old);
hold on
plot(x,f);
title('F Measure Comparison')
xlabel('F Measure') % x-axis label
ylabel('Cumulative Percentage') % y-axis label
legend('new algo','old algo','Location','northwest')
