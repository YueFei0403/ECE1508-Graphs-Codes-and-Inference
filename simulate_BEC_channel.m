function received_output = simulate_BEC_channel(encoded_input, EPSILON)
received_output = encoded_input;

received_output(rand(1, length(encoded_input)) < EPSILON) = nan;
end