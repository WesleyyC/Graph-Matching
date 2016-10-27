%% Random Graph Test

% The RandomGraphTest class will generate a 100 nodes graph and permutate
% it a bit. Then test the algorithm on the two graphs.

clear
tStart = tic();
%% Basic Configuration Setup

% How many rounds
rounds = 50;

% The size if the test graph
size = 20;

% The range of the edge rate
weight_range = 10;  % update with edge_compatibility/node_compatibility
% How often two nodes are connected
connected_rate = 0.1;
% How many noise are there
noise_rate = 0.05;

% Node Attribute Flag
atr_flag = 1;

% Scoring
score = [0,0];

%% Run the test
for i = 1:rounds
    loopStart=tic();
    score=score+RGTestLoop(size, weight_range,connected_rate,noise_rate,atr_flag);
    display('Singe Round');
    toc(loopStart);
end
%% Calculate the correct rate
correct_rate = score(1)/sum(score);
display(correct_rate);
display('Total Run Time');
toc(tStart);
display(' ')

