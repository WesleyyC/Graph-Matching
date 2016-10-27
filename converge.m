function [ tf ] = converge( M1,M2,e )
%   CONVERGE is a function checking if a matrix is a doubly stochastic
%   matrix
    
    tf = abs(sum(sum(M1-M2)))<e;

end

