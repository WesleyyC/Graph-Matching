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
noise_rate = 0.2;

% Node Attribute Flag
atr_flag = 1;

% Scoring
score = [0,0,0];

%% Run the test
for i = 1:rounds
    disp(['Round ' num2str(i)])
    score=score+single_graph_test(size, weight_range,connected_rate,noise_rate,atr_flag);
    disp(' ')
end
%% Calculate the correct rate
disp(['Final Recall: ' num2str(score(1)/score(2))])
disp(['Final Precision: ' num2str(score(1)/score(3))])
disp(['Size: ' num2str(size)])
disp(['Connected Rate: ' num2str(connected_rate)])
disp(['Noise Rate: ' num2str(noise_rate)])
toc(tStart);

