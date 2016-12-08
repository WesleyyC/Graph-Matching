
function [score, score_old] = single_graph_test_compare(size, weight_range,connected_rate,noise_rate)

% Scoring Setup
% [correct_count, test_size, total_grep]
score=[0,0,0];
score_old=[0,0,0];

% Generate a Random Matrix for Pattern
M = triu((rand(size)*2-1)*weight_range,1);    %  upper left part of a random matrix with weight_range
connected_nodes = triu(rand(size)<connected_rate,1);    % how many are connected
M = M.*connected_nodes;
M = M + M'; % make it symmetric

% Generate the Permutation of M1 and M2
M1_size = round((1+rand*noise_rate*2)*size);
M1 = triu((rand(M1_size)*2-1)*weight_range,1);    %  upper left part of a random matrix with weight_range
connected_nodes = triu(rand(M1_size)<connected_rate,1);    % how many are connected
M1 = M1.*connected_nodes;
M1 = M1 + M1'; % make it symmetric
M2_size = round((1+rand*noise_rate*2)*size);
M2 = triu((rand(M2_size)*2-1)*weight_range,1);    %  upper left part of a random matrix with weight_range
connected_nodes = triu(rand(M2_size)<connected_rate,1);    % how many are connected
M2 = M2.*connected_nodes;
M2 = M2 + M2'; % make it symmetric

% Get the base testing_Matrix
M1(1:size,1:size) = M;
M2(1:size,1:size) = M;

V = (rand([1,size])*2-1)*weight_range;
V1 = (rand([1,M1_size])*2-1)*weight_range;
V2 = (rand([1,M2_size])*2-1)*weight_range;
V1(1:size) = V;
V2(1:size) = V;

%Generate Random Permutation Matrix
idx1 = randperm(M1_size);
idx1 = 1:M1_size;
clearvars rev1;  % the rev memory will mess up the indexes so clear it before we generate the new rev
rev1(idx1)=1:M1_size;
idx2 = randperm(M2_size);
idx2 = 1:M2_size;
clearvars rev2;  % the rev memory will mess up the indexes so clear it before we generate the new rev
rev2(idx2)=1:M2_size;

% Permute the matrix
M1=M1(idx1,idx1);
V1=V1(idx1);
M2=M2(idx2,idx2);
V2=V2(idx2);

% Adding Noise
% adding noise to edge
M1_noise = randn(M1_size); %-1~1
M1_noise = M1_noise*weight_range*noise_rate;
M1 = M1 + M1_noise.*(M1~=0);
M2_noise = randn(M2_size); %-1~1
M2_noise = M2_noise*weight_range*noise_rate;
M2 = M2 + M2_noise.*(M2~=0);
% adding noise to node
V1_noise = randn([1,M1_size]);
V1_noise = V1_noise*weight_range*noise_rate;
V1 = V1+V1_noise;
V2_noise = randn([1,M2_size]);
V2_noise = V2_noise*weight_range*noise_rate;
V2 = V2+V2_noise;


% Generate the Graph
ARG1 = ARG(M1,V1);
ARG2 = ARG(M2,V2);

% Do the match algorithm
match = graph_matching(ARG1,ARG2,1,1);
match_old = graph_matching_old(ARG1,ARG2,1,0);

% Get back the original
result = match(rev1,rev2);
result_old = match_old(rev1,rev2);

% Counting correct or mistaken match
for i = 1:size
    if result(i,i)==1
        score(1) = score(1)+1;
    end
    if result_old(i,i)==1
        score_old(1) = score_old(1)+1;
    end
end

score(2)=size;
score_old(2)=size;

score(3)=length(find(result));
score_old(3)=length(find(result_old));

