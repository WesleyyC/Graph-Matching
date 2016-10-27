function [ M ] = heuristic( M, A, I )
%   HEURISTIC is a function that will make a matrix into a permuation
%   matrix according to some rules.

%   In this version, the cleanM will make the largest number in each row 1
%   and the others to 0.

    A=A+1;
    I=I+1;
    
    % create a directed graph according to the weight
    DG=zeros(A+I);
    DG(1:A,A+1:end)=M;
    
    % convert the maximum problem to a minimum problem
    DG=1-DG;
    
    % convert the matrix to a undirected graph
    DG=sparse(DG);
    UG = tril(DG + DG');
    
    % calculate the minimum spanning tree
    [Tree, ~] = graphminspantree(UG);
    
    % convert the result to the right size
    M = full(Tree);
    M = M((A+1):end,1:A)';

    % convert the problem to a maximum one
    not_zero_index=M~=0;
    M(not_zero_index)=2-M(not_zero_index);
    
    
    % get the number of row in M
    row = length(M(:,1));

    % clean up
    for i = 1:row
        % get the index
        [~,index] = max(M(i,:));
        % set the row to zero
        M(i,:)=zeros(size(M(i,:)));
        M(:,index)=zeros(size(M(:,index)));
        % set the max to 1
        M(i,index)=1;
    end
    
    M=M(1:A-1,1:I-1);

end

