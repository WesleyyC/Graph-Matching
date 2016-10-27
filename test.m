%% Simple Test

% Test the algorithm using DELICATED setup ARGs.

clear

%% Create the 1st graph matrix

num_nodes = 3;
links = {[1,2],[2,3],[3,1]};
%weight = [10,5,2];
weight = [1,1,1];

M=zeros(num_nodes);

for i = 1:length(links)
    index = links{i};
    node1 = index(1);
    node2 = index(2);
    M(node1,node2)=weight(i);
    M(node2,node1)=weight(i); %Symmetric
end

nodes_atrs = [1,10,20];
%nodes_atrs = NaN;

%% Build the 1st ARG

ARG1 = ARG(M,nodes_atrs);

%% Create the 2nd matrix

num_nodes = 5;
links = {[1,2],[2,3],[3,1],[2,4],[4,5],[3,5]};
%weight = [10,5,2,30,1,100];
weight = [1,1,1,1,1,1];

M=zeros(num_nodes);

for i = 1:length(links)
    index = links{i};
    node1 = index(1);
    node2 = index(2);
    M(node1,node2)=weight(i);
    M(node2,node1)=weight(i); %Symmetric
end

nodes_atrs = [1,10,20,50,30];
%nodes_atrs = NaN;
%% Build the 2nd ARG

ARG2 = ARG(M,nodes_atrs);

%% Try to Match
tic()
match = graph_matching(ARG1,ARG2)
toc()