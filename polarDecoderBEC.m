function decoded = polarDecoderBEC(y,frozen_bits,A,A_c)

N = length(y);

frozen_bits_expanded = nan(1,N);
frozen_bits_expanded(A_c) = frozen_bits;

decoded = nan(1,N);

for phi = 1:N
    if (A_c(phi))
        decoded(phi) = frozen_bits_expanded(phi);
    else
        % Use previously decoded bits to assist decoding
        current_lr = computeLLR(y,decoded(1:phi-1),N,phi);

        decoded(phi) = decide(current_lr);

        if (isnan(decoded(phi)))
            break;
        end
    end
end

decoded = decoded(A);
end

function L = computeLLR(y,u,N,phi)
if (N==1)
    if(y == 0)
        L = Inf;
    elseif(y == 1)
        L = 0;
    elseif(isnan(y)) % Erasure
        L = 1;
    else
        error('Unexpected value for y')
    end

    return;
end

if (mod(phi,2)==1)
    u_odd = u(1:2:phi-2);
    u_even = u(2:2:phi-1);

    L1 = computeLLR(y(1:N/2),mod(u_odd+u_even,2),N/2,(phi+1)/2);
    L2 = computeLLR(y(N/2+1:N),u_even,N/2,(phi+1)/2);

    % Use table decision for border cases (make diagram to understand)
    if((L1 == 0 && L2 == 0) || (isinf(L1) && isinf(L2)))
        L = Inf;
    elseif((L1 == 0 && isinf(L2)) || (isinf(L1) && L2 == 0))
        L = 0;
    elseif((L1 == 1 && isinf(L2)) || (isinf(L1) && L2 == 1))
        L = 1;
    else
        L = (L1*L2 + 1)/(L1+L2);
    end
else
    u_odd = u(1:2:phi-3);
    u_even = u(2:2:phi-2);
    
    L1 = computeLLR(y(1:N/2), mod(u_odd + u_even, 2), N/2, phi/2);
    L2 = computeLLR(y(N/2+1:N), u_even, N/2, phi/2);
    
    if(u(phi-1) == 0)
        L = L2 * L1;
    else
        L = L2 / L1;
    end
end
end



function decoded_bit = decide(current_lr)
if(current_lr == 0)
    decoded_bit = 1;
elseif(current_lr == Inf)
    decoded_bit = 0;
elseif(current_lr == 1)
    decoded_bit = nan;
else
    error('Unexpected likelihood ratio')
end
end
