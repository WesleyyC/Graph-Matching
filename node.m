classdef node < handle
    %	node is a class representing the point in a graph
    %   node will have edge (also class) connected to it and its own
    %   attributes value represented with a vector
    
    properties (GetAccess=public,SetAccess=public)
        % The attributes
        ID = NaN;   % ID needs to start with 1 and increment by 1 every new nodes
        ARG = NaN
    end
    
    methods
        % Constructor for the class
        function  obj = node(id,ARG)
            % Throw error if not enough argument
            if nargin < 2
                error "NotEnoughArgument";
            end
            
            % Asssign the id
            obj.ID = id;
            % Assign the attributes
            obj.ARG = ARG;
        end
        
        % Check if the node has attributes
        function [tf] = hasAtrs(obj)
            tf = any(obj.getAtrs());
        end
        
        function [val] = getAtrs(obj)
            val = obj.ARG.nodes_vector{obj.ID};
        end
        
        % Get number of attributes
        function [no] = numberOfAtrs(obj)
            no=length(obj.getAtrs());
        end

    end
    
end

