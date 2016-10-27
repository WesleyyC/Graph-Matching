function [ M ] = heuristic( M, A, I )
%   HEURISTIC is a function that will make a matrix into a permuation
%   matrix according to some rules.

%   In this version, the cleanM will make the largest number in each row 1
%   and the others to 0.

    % Heuristic
    M = double(bsxfun(@eq, M, max(M, [], 1)));
    
    % get the right size
    M=M(1:A,1:I);
    

end

