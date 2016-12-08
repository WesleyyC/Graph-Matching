function [ M ] = heuristic( M, A, I )
%   HEURISTIC is a function that will make a matrix into a permuation
%   matrix according to some rules.

    % Heuristic
%     M = double(bsxfun(@eq, M, max(M, [], 1)));
    
    % Heuristic
    M=normr(M).*normr(M);
    for i = 1:A+1
        % get the index
        [~,index] = max(M(i,:));
        % set the row to zero
        M(i,:)=zeros(size(M(i,:)));
        if index ~= I
            M(:,index)=0;
        end
        % set the max to 1
        M(i,index)=1;
    end
    
    % get the right size
    M=M(1:A,1:I);
    

end

