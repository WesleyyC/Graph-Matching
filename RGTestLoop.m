function [score] = RGTestLoop(size, weight_range,connected_rate,noise_rate,atr_flag)

% Scoring Setup
% [correct_count, mistaken_count]
score=[0,0];


% Generate a Random Matrix
M = triu(rand(size)*weight_range,1);    %  upper left part of a random matrix with weight_range
connected_nodes = triu(rand(size)<connected_rate,1);    % how many are connected
M = M.*connected_nodes;
M = M + M'; % make it symmetric


% Generate the Permutation of M

% Determine the size of the permutation of M
low_limit = round(0.1*size+1);    % control the limit of lower bound so that the permutation is large enough
low_bound = randi([1 low_limit],1,1);
up_limit =round(0.9*size);   % control the limit of up_bound so that the permutation matrix is large enough
up_bound = randi([up_limit,size],1,1);
test_size = up_bound-low_bound+1;
test_range = low_bound:up_bound;

% Get the base testing_Matrix
test_M=M(test_range,test_range);

%Generate Random Permutation Matrix
idx = randperm(test_size);
clearvars rev;  % the rev memory will mess up the indexes so clear it before we generate the new rev
rev(idx)=1:test_size;

% Permute the matrix
test_M=test_M(idx,idx);

% Node Attribute
nodes_atrs=NaN;
test_nodes_atrs=NaN;
if atr_flag
    nodes_atrs=rand([1,size])*weight_range;
    test_nodes_atrs = nodes_atrs(test_range);
    test_nodes_atrs = test_nodes_atrs(idx);
end

% Adding Noise
if noise_rate~=0
    % adding noise to edge
    edge_noise = rand(test_size)*2-1; %-1~1
    edge_noise = edge_noise*weight_range*noise_rate;
    test_M = test_M + edge_noise.*(test_M~=0);
    if atr_flag
        % adding noise to node
        node_noise = rand([1,test_size])*2-1;
        node_noise = node_noise*weight_range*noise_rate;
        test_nodes_atrs=test_nodes_atrs+node_noise;
    end
end

% Generate the Graph
ARG1 = ARG(M,nodes_atrs);
ARG2 = ARG(test_M,test_nodes_atrs);

% Do the match algorithm
match = graph_matching(ARG2,ARG1);

% Get back the original
result = match(rev,:);

% Counting correct or mistaken match
for i = 1:test_size
    if result(i,test_range(i))==1
        score(1) = score(1)+1;
    else
        score(2) = score(2)+1;
    end
end