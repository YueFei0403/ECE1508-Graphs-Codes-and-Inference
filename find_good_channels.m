function [A, A_c] = find_good_channels(Z, K)
BLOCKLENGTH = length(Z);

[~, sorted_indices] = sort(Z);

A = false(1, BLOCKLENGTH);
A(sorted_indices(1:K)) = true;

A_c = false(1, BLOCKLENGTH);
A_c(sorted_indices(K+1:end)) = true;

end