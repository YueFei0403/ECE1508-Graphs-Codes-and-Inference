% This script simulates the transmission process on a BEC(EPSILON) at the 
% given RATE and with the given BLOCKLENGTH.
% 
%           ---------                       ---------                         ---------    
% input -> | Encoder | -> encoded_input -> | Channel | -> received_output -> | Decoder | -> decoded_output
%           ---------                       ---------                         ---------
% 
% 
% For details, please refer to:
% 
% E. Arikan, Channel polarization: a method for constructing 
% capacity-achieving codes for symmetric binary-input memoryless channels, 
% IEEE Trans. Inf. Theory, vol. 55, no. 7, pp. 3051-3073, July 2009.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set constants (and compute derived constants)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The parameter of the channel
EPSILON = 0.3;

% The block-length (note that it must be a power of 2)
BLOCKLENGTH = 16;

% The rate (note that RATE*BLOCKLENGTH must be an integer)
RATE = 1/2; 

% The number of information bits per block
K = RATE*BLOCKLENGTH;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the good sythetic channels channels (A)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the bhattacharyya parameters
Z = compute_bhattacharyya_BEC(EPSILON, BLOCKLENGTH);

% Find the K channels with the smallest value Z
% Note that A and A_c are logical vectors of length N
[A, A_c] = find_good_channels(Z, K);
% display(A); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose the frozen bits values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note that for a symmetric channel, the choice of frozen bits doesn't
% matter
frozen_bits = zeros(1, BLOCKLENGTH - K);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate a binary input vector of size 1 x K
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input = randi(2, 1, K) - 1;
input = [0    0    1     0     0     0     0     0];
disp(input)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Encode the input vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
encoded_input = polarEncoder(input, frozen_bits, A, A_c);
% display(encoded_input);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulate the channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
received_output = simulate_BEC_channel(encoded_input, EPSILON);
% display(received_output);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Decode the received vector (naive or optimized version)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frozen_bits_expanded = zeros(1,BLOCKLENGTH);
frozen_bits_expanded(A) = 1/2; % info bits
frozen_bits_expanded(A_c) = frozen_bits;
[u,x] = polarDecoderTree(received_output,frozen_bits_expanded);
% decoded_output = polarDecoderBEC(received_output,frozen_bits_expanded);
% decoded_output = decode_output_BEC(received_output, frozen_bits, A, A_c);
display("Decoded")
decoded = u(A);
disp(decoded)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if the transmission was successful
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(isequal(decoded, input))
    fprintf('Transmission: success\n')
else
    fprintf('Transmission: bad luck\n')
end
