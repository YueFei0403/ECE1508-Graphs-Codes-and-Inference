function decoded = polarDecoder(y,frozen_bits,A,A_c,epsilon)
N = length(y);
m = log2(N);
frozen_bits_expanded = nan(1,N);
frozen_bits_expanded(A_c) = frozen_bits;

P_lambda = zeros(N,2);
B_lambda = zeros(N,1);

% Init
phi = 0; lambda = 0;
for beta = 0:N-1
    idx = phi + 2^lambda*beta;
    P_lambda(idx+1,1) = computeW_BEC(y(beta+1),0,epsilon);
    P_lambda(idx+1,2) = computeW_BEC(y(beta+1),1,epsilon);
end

% Main Loop
lambda = m; beta = 0;
for phi = 0:N-1
    P_lambda = calculateP(P_lambda,B_lambda,lambda,phi,m);
    if A_c(phi+1) % frozen bit
        frozen_idx = phi + 2^lambda*beta;
        B_lambda(frozen_idx+1) = frozen_bits_expanded(phi+1);
    else
        curr_idx = phi + 2^lambda*beta;
        if P_lambda(curr_idx+1,1) > P_lambda(curr_idx+1,2)
            B_lambda(curr_idx+1) = 0;
        else
            B_lambda(curr_idx+1) = 1;
        end
    end
    if mod(phi,2) == 1
        B_lambda = updateB(B_lambda,m,phi,m);
    end
end

lambda = 0; phi = 0; beta = 1:N;
final_idx = phi + 2^lambda.*beta;
decoded = B_lambda(final_idx);
decoded = decoded(A);
end

function P_lambda = calculateP(P_lambda,B_lambda,lambda,phi,m)
    if lambda == 0
        return; %% stopping condition
    end
    psi = floor(phi/2);
    
    %% Recursive first, if needed
    if mod(phi,2) == 0
        P_lambda = calculateP(P_lambda,B_lambda,lambda-1,psi,m);
    end

    beta_length = 2^(m-lambda);
    for beta = 0:beta_length-1
        if mod(phi,2) == 0      % first branch   u1+u2
            curr_idx = phi + 2^lambda*beta;
            prev_idxFirst = psi + 2^(lambda-1)*2*beta;
            prev_idxSecond = psi + 2^(lambda-1)*(2*beta+1);
            P_lambda(curr_idx+1,1) = 1/2*P_lambda(prev_idxFirst+1,1)*P_lambda(prev_idxSecond+1,1); % u1 = 0; u2 = 0; 
            P_lambda(curr_idx+1,1) = P_lambda(curr_idx+1,1) + 1/2*P_lambda(prev_idxFirst+1,2)*P_lambda(prev_idxSecond+1,2); % u1 = 0; u2 = 1;
            P_lambda(curr_idx+1,2) = 1/2*P_lambda(prev_idxFirst+1,2)*P_lambda(prev_idxSecond+1,1); % u1 = 1; u2 = 0; 
            P_lambda(curr_idx+1,2) = P_lambda(curr_idx+1,2) + 1/2*P_lambda(prev_idxFirst+1,1)*P_lambda(prev_idxSecond+1,2); % u1 = 1; u2 = 1;
        else                    % second branch  u2
            u1_idx = phi - 1 + 2^lambda*beta;
            prev_idxFirst = psi + 2^(lambda-1)*2*beta;
            prev_idxSecond = psi + 2^(lambda-1)*(2*beta+1);
            
            u1 = B_lambda(u1_idx+1);
            u2 = 0;
            bXOR = mod(u1+u2,2);
            curr_idx = phi + 2^lambda*beta;
            P_lambda(curr_idx+1,1) = 1/2*P_lambda(prev_idxFirst+1,bXOR+1)*P_lambda(prev_idxSecond+1,1); % u2 = 0;
            u2 = 1;
            bXOR = mod(u1+u2,2);
            P_lambda(curr_idx+1,2) = 1/2*P_lambda(prev_idxFirst+1,bXOR+1)*P_lambda(prev_idxSecond+1,2); % u2 = 1; 
        end
    end
end

function B_lambda = updateB(B_lambda,lambda,phi,m)
    %% require phi is odd
    if lambda == 0 || mod(phi,2)==0
        return; %% stopping condition
    end
    psi = floor(phi / 2);
    beta_length = 2^(m-lambda);
    for beta = 0:beta_length-1
        outer_idxFirst = phi - 1 + 2^lambda*beta;
        outer_idxSecond = phi + 2^lambda*beta;
        inner_idxFirst = psi + 2^(lambda-1)*2*beta;
        inner_idxSecond = psi + 2^(lambda-1)*(2*beta+1);
        B_lambda(inner_idxFirst+1) = mod(B_lambda(outer_idxFirst+1)+B_lambda(outer_idxSecond+1),2);
        B_lambda(inner_idxSecond+1) = B_lambda(outer_idxSecond+1);
    end
    if mod(psi,2) == 1
        B_lambda = updateB(B_lambda,lambda-1,psi,m);
    end
end

function L = computeW_BEC(y,b,epsilon)
    if isnan(y)
        L = eps; 
    elseif y == b
        L = 1;
    else 
        L = 0;
    end
end