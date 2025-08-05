function Z = compute_bhattacharyya_BEC(EPSILON, BLOCKLENGTH)

if(BLOCKLENGTH == 1)
    % Recursion termination
    Z = EPSILON;
else
    % Recursively compute bhattacharyya parameters for half the blocklength
    Z_half = compute_bhattacharyya_BEC(EPSILON, BLOCKLENGTH / 2);
    
    % Compute odd and even-indices bhattacharyya parameters that we obtain when
    % performing one more transform
    Z_half_odd = 2*Z_half-Z_half.^2;
    Z_half_even = Z_half.^2;
    
    % Merge odd and even indices into a 1 x BLOCKLENGTH vector
    Z = reshape([Z_half_odd; Z_half_even], 1, BLOCKLENGTH);
end

end