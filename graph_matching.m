function [ match_matrix ] = graph_matching( ARG1,ARG2 )
%   GRADUATED_ASSIGN_ALGORITHM is a function that compute the best match
%   matrix with two ARGs

    % set up condition and variable
    % beta is the converging for getting the maximize number
    beta_0 = 0.5;
    beta_f = 10;
    beta_r = 1.075;
    % I control the iteration number for each round
    I_0 = 4;
    I_1 = 30;
    % e control a range
    e_B = 0.5;
    e_C=0.05;    
    % node attriubute compatability weight
    alpha = 0.1;
    
    % make sure ARG1 is always the smaller graph
    if ARG1.num_nodes>ARG2.num_nodes
        tmp = ARG1;
        ARG1 = ARG2;
        ARG2 = tmp;
    end
    % the size of the real matchin matrix
    A=ARG1.num_nodes;
    I=ARG2.num_nodes;
    real_size = [A,I];
    % the size of the matrix with slacks
    augment_size = [A+1,I+1];
    
    % set up the matrix
    % init a guest m_Head with 1+e
    e=1.5;
    m_Init = rand(augment_size)*e;
    m_Head = m_Init;
    % initial beta to beta_0
    beta = beta_0;
    
    % pre-calculate the node compatability
    % create an function handle for calculating compatibility
    node_compat_handle=@(node1,node2)node1.compatibility(node2);
    % calculate the compatibility
    C_n=cellfun(node_compat_handle,repmat(ARG1.nodes',1,I),repmat(ARG2.nodes,A,1));
    % times the alpha weight
    C_n=alpha*C_n;
    
    % pre-calculate the edge compatability
 
    % calculate the connected rate and decide which method to use
    connected_rate = ((sum(sum(ARG2.matrix~=0))/numel(ARG2.matrix)+...
        sum(sum(ARG1.matrix~=0))/numel(ARG1.matrix)))/2;

    if connected_rate<0.4
        
        % for low connected rate
        weight_handle = @(edge)edge.atrs;
        [i_1,j_1,~] = find(sparse(cellfun(weight_handle,ARG1.edges)));
        [i_2,j_2,~] = find(sparse(cellfun(weight_handle,ARG2.edges)));
        arg1_edges_num = length(i_1);
        arg2_edges_num = length(i_2);
        ARG1_edge_index = mat2cell([i_1,j_1],ones([1,arg1_edges_num]));
        ARG2_edge_index = mat2cell([i_2,j_2],ones([1,arg2_edges_num]));

        C_e = mat2cell(zeros([A*A,I*I]),ones([1,A])*A,ones([1,I])*I);    

        for z = 1:arg1_edges_num
            for y = 1:arg2_edges_num
                index1 = ARG1_edge_index{z};
                index2 = ARG2_edge_index{y};
                C_e{index1(1),index2(1)}(index1(2),index2(2)) = ARG1.edges{index1(1),index1(2)}.compatibility(ARG2.edges{index2(1),index2(2)});             
            end
        end 
        
    else
    
        % for high connected rate    
        % setup an function handle for caluculating compatibility
        edge_compat_handle=@(edge1,edge2)edge1.compatibility(edge2);
        % each cell will have a matrix
        C_e=cell(real_size);
        for a = 1:A
            for i = 1:I
                C_e{a,i}=cellfun(edge_compat_handle,...
                    repmat(ARG1.edges(a,:)',1,I),...
                    repmat(ARG2.edges(i,:),A,1));
            end
        end

%         % no much differnce between below and above so we choose the above one
%         % for a clearer logic
%         % a function help to build up matrix to reduce for loop
%         % this function will build a matrix and return to the cell C_e{a,i}
%         matrix_build_handle=@(a,i)cellfun(edge_compat_handle,...
%                 repmat(ARG1.edges(a,:)',1,I),...
%                 repmat(ARG2.edges(i,:),A,1));
%         % build up the matrix function
%         C_e = cellfun(matrix_build_handle,...
%             num2cell(repmat(1:A,I,1)'),...
%             num2cell(repmat(1:I,A,1)),...
%             'UniformOutput',false);
    end
        
    while beta<beta_f   % do A until beta is less than beta_f
        converge_B = 0; % a flag for terminating process B
        I_B = 0;    % counting the iteration of B
        while ~converge_B && I_B <= I_0 % do B until B is converge or iteration exceeds
            old_B=m_Head;   % get the old matrix
            I_B = I_B+1;    % increment the iteration counting
            
            % Build the partial derivative matrix Q
            m_Head_realsize = m_Head(1:A,1:I);
            % sum up the terms for partial differentiation
            sum_fun=@(mat)sum(sum(mat.*m_Head_realsize));
            Q=cellfun(sum_fun,C_e);
            
            %add node attribute
            Q=Q+C_n;
            
            % Normalize Q to avoid NaN/0 produce from exp()
            Q=normr(Q);
            % Now update m_Head!
            m_Head(1:A,1:I)=exp(beta*Q);
            
            converge_C = 0; % a flag for terminating process B
            I_C = 0;    % counting the iteration of C
            %m_One = zeros(size(m_Head));    % a middleware for doing normalization
            while ~converge_C && I_C <= I_1    % Begin C
                I_C=I_C+1;  % increment C
                old_C=m_Head;   % get the m_Head before processing to determine convergence
                
                %normalize the row
                s=sum(m_Head,2);
                n=repmat(s,1,I+1);
                n(A+1,:)=ones(size(n(A+1,:)));
                m_One=m_Head./n;
                
                % normalize the column
                s=sum(m_One,1);
                n=repmat(s,A+1,1);
                n(:,I+1)=ones(size(n(:,I+1)));
                m_Head=m_One./n;
                
                % check convergence
                converge_C = converge(m_Head,old_C,e_C);
            end
            % check convergence
            converge_B = converge(m_Head(1:A,1:I),old_B(1:A,1:I),e_B);
        end
        % increment beta
        beta=beta_r*beta;
    end
    
    % get the match_matrix in real size
    match_matrix = heuristic(m_Head,A,I);

end

