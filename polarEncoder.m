function encoded_input = polarEncoder(input, frozen_bits, A, A_c)
BLOCKLENGTH = length(A);

% Concatenate input and frozen bits
bits_to_combine = zeros(1, BLOCKLENGTH);
bits_to_combine(A) = input;
bits_to_combine(A_c) = frozen_bits;

% Recursively combine the bits using polar transformation
encoded_input = combine_bits(bits_to_combine, BLOCKLENGTH);

end


function x = combine_bits(u, BLOCKLENGTH)
if(BLOCKLENGTH == 1)
    x = u;
    return;
end

u_odd = u(1:2:BLOCKLENGTH-1);
u_even = u(2:2:BLOCKLENGTH);

s_odd = mod(u_odd+u_even, 2);
s_even = u_even;

% Reverse shuffle operation R_N
v_first_half = s_odd;
v_second_half = s_even;

% Recursively encode v
x_first_half = combine_bits(v_first_half, BLOCKLENGTH / 2);
x_second_half = combine_bits(v_second_half, BLOCKLENGTH / 2);

x = [x_first_half x_second_half];
end