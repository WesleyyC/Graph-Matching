classdef ARG < handle
    %	Attributed Relational Graphs represents a graph data strucutre with
    %	a list of node
    %   We have a E_arg(M) that we want to minimize
    
    properties (GetAccess=public,SetAccess=private)
        num_nodes = NaN;
        nodes = {};
        edges = {};
        matrix = NaN;
        
    end
    
    methods
        function self = ARG(M,nodes_atrs)
            % Throw error if not enough argument
            if nargin < 2
                error "NotEnoughArgument";
            end
            
            % Throw error if the matrix is not a square
            if size(M)~=size(M')
                error "MisNotSquare";
            end
            
            % Throw error if the graph matrix and the nodes_atrs does not
            % match
            if all(~isnan(nodes_atrs)) && length(M)~=length(nodes_atrs)
                    error "AtrributeArrasySizeNotMatch";
            end
            
            % Get the number of nodes
            self.num_nodes=length(M);
            
            % Allocate memory for nodes and edges
            self.nodes = cell(1,self.num_nodes);
            self.edges = cell(self.num_nodes,self.num_nodes);
            
            % Check if the nodes_atrs is NaN, if it is, we will need to
            % make a NaN array for the loop
            if isnan(nodes_atrs)
                nodes_atrs = NaN(1,self.num_nodes);
            end
            
            % Create Nodes
            for ID = 1:self.num_nodes
                self.nodes{ID}=node(ID,nodes_atrs(ID));
            end
            
            % Create Edge
            for i = 1:self.num_nodes
                for j = 1:self.num_nodes
                    self.edges{i,j}=edge(M(i,j),i,j,self.nodes);
                end
            end
            
            self.matrix = M;

        end
        
    end
    
end

