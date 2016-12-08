classdef edge < handle
    %   edge is the connection between node and 
    %   it will have some assigned weight and two end points (nodes)
    
    properties (GetAccess=public,SetAccess=private)
        % The attributes
        ARG = NaN;   % the weight for the link, and be NaN if there is no link between node1 and node2
        node1 = NaN;
        node2 = NaN;
    end
    
    methods
        % Constructor for the class
        function  self = edge(ARG,node1,node2)
            % Throw error if not enough argument
            if nargin < 3
                error "NotEnoughArgument";
            end
            
            % Otherwise, we process the argument
            self.ARG = ARG;
            
            self.node1 = node1;
            self.node2 = node2;
            
        end
        
        function [tf] = trueEdge(obj)
            tf=obj.getAtrs()~=0;
        end
        
        function [val] = getAtrs(obj)
            val=obj.ARG.edges_matrix(obj.node1.ID,obj.node2.ID);
        end
        
        % Get number of attributes
        function [no] = numberOfAtrs(obj)
            no=length(obj.getAtrs());
        end
    end
    
end

