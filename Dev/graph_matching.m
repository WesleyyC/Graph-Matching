 function [ match_matrix ] = graph_matching( ARG1, ARG2, alpha, stochastic )
%   GRADUATED_ASSIGN_ALGORITHM is a function that compute the best match
%   matrix with two ARGs

    % show procedure flag
    sFlag=0;
    
    % set up condition and variable
    % beta is the converging for getting the maximize number
    beta_0 = 0.1;
    beta_f = 20;   % original is 10
    beta_r = 1.025; % original is 1.075
    
    % I control the iteration number for each round
    I_0 = 20;  % original is 4
    I_1 = 200;   % original is 30
    
    % e control a range
    e_B = 0.1;  % original is 0.5
    e_C = 0.01;   % original is 0.05
    
    % node attriubute compatability weight
    if ~exist('alpha','var')
     % third parameter does not exist, so default it to something
      alpha = 1;
    end
    
    if ~exist('stochastic','var')
     % third parameter does not exist, so default it to something
      stochastic = 0;
    end
    
    % the size of the real matchin matrix
    A=ARG1.num_nodes;
    I=ARG2.num_nodes;
    real_size = [A,I];
    
    % the size of the matrix with slacks
    augment_size = real_size+[1,1];
    
    % initial beta to beta_0
    beta = beta_0;
    
    % nil node compatibility percentage
    prct = 10;
    
    % pre-calculate the node compatability
    C_n=zeros(A+1,I+1);
    
    % create an function handle for calculating compatibility
    % calculate the compatibility
    node_compat_handle=@(atr1,atr2)compatiblity(atr1,atr2);
    C_n(1:A,1:I)=bsxfun(node_compat_handle,ARG1.nodes_vector',ARG2.nodes_vector);
    % calculate nil compatibility
    C_n(A+1, 1:I)=prctile(C_n(1:A,1:I),prct,1);
    C_n(1:A, I+1)=prctile(C_n(1:A,1:I),prct,2);
    C_n(A+1, I+1)=0;
    % times the alpha weight
    C_n=alpha*C_n;
    
    % pre-calculate the edge compatability
    C_e = zeros((A+1)*(A+1),(I+1)*(I+1)); 
    
    tmp_edges = NaN(A+1,A+1);
    tmp_edges(1:A,1:A) = ARG1.edges_matrix;
    tmp_edges(A+1,A+1) = Inf;
    edge_atr_1 = reshape(tmp_edges,1,[]);
    tmp_edges = NaN(I+1,I+1);
    tmp_edges(1:I,1:I) = ARG2.edges_matrix;
    tmp_edges(I+1,I+1) = Inf;
    edge_atr_2 = reshape(tmp_edges,1,[]);

    edge_compat_handle=@(atr1,atr2)compatiblity(atr1,atr2);
    
    parfor p = 1:(A+1)*(A+1)
        C_e(p,:)=bsxfun(edge_compat_handle,edge_atr_1(p),edge_atr_2);      
    end

    % nil<->a
    C_e(isnan(C_e)) = 0;
    % nil<->nil
    C_e(isinf(C_e)) = prctile(reshape(C_e(C_e~=0),1,[]),prct);
    
    % set up the matrix
    m_Head = rand(augment_size);
    m_Head(A+1, I+1)=0;
        
    if sFlag
        figure()
    end
    % start matching  
    while beta<beta_f   % do A until beta is less than beta_f
        
        converge_B = 0; % a flag for terminating process B
        I_B = 0;    % counting the iteration of B

        while ~converge_B && I_B <= I_0 % do B until B is converge or iteration exceeds
            
            if stochastic
                m_Head = m_Head + (2*rand(size(m_Head))-1)*(1/A);
            end
            
            old_B=m_Head;   % get the old matrix
            I_B = I_B+1;    % increment the iteration counting
            
            
            % Build the partial derivative matrix Q
            Q=zeros(A+1,I+1);
            for a = 1:A+1
                for i = 1:I+1
                    Q(a,i)=sum(sum(C_e(((a-1)*(A+1)+1):((a-1)*(A+1)+(A+1)),((i-1)*(I+1)+1):((i-1)*(I+1)+(I+1))).*m_Head));
                end
            end
            
            %add node attribute
            Q=Q+C_n;
            
            % Now update m_Head!
            m_Head=exp(beta*Q);
            m_Head(A+1, I+1)=0;

            % Setup converge in C step
            converge_C = 0; % a flag for terminating process B
            I_C = 0;    % counting the iteration of C
            
            while ~converge_C && I_C <= I_1    % Begin C
                I_C=I_C+1;  % increment C
                old_C=m_Head;   % get the m_Head before processing to determine convergence
                
                %normalize the row
                m_Head(1:A,:)=normr(m_Head(1:A,:)).*normr(m_Head(1:A,:));
                
                % normalize the column
                m_Head(:,1:I)=normc(m_Head(:,1:I)).*normc(m_Head(:,1:I));
                
                % check convergence
                convergeC();
            end
                        
            % check convergence
            if sFlag
                imshow(m_Head,'InitialMagnification',500);
            end
            convergeB();
        end
        
        % increment beta
        beta=beta_r*beta;
    end

    % Set up return
    
    % get the match_matrix in real size
    match_matrix = heuristic(m_Head,A,I);
    
    % debug purpose
    C_n = C_n/alpha;
    if sFlag
        close()
    end
    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % INNER FUNCTION SECTION
    function [] = convergeC()
        converge_C = abs(sum(sum(m_Head-old_C)))<e_C;
    end

    function [] = convergeB()
        converge_B = abs(sum(sum(m_Head(1:A,1:I)-old_B(1:A,1:I))))<e_B;
    end

    function [score] = compatiblity(atr1, atr2)
        score = exp(-0.5*(atr1-atr2).^2)/(2*pi)^0.5;
        score = score/(exp(-0.5*(0).^2)/(2*pi)^0.5);
        score = score.*(atr1~=0).*(atr2~=0);
    end

end

