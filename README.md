# Polar Code Simulation over BEC

This repository contains a MATLAB script (`main.m`) that simulates the transmission of data over a **Binary Erasure Channel (BEC)** using **polar codes**, following the method introduced by Erdal Arıkan in his seminal paper on channel polarization.

## Overview

The simulation performs the following steps:

1. **Define Parameters**: Set the erasure probability (`EPSILON`), block length, and code rate.
2. **Channel Construction**: Compute Bhattacharyya parameters for synthetic channels and select the best `K` channels for data transmission.
3. **Encoding**: Encode a binary input vector using a polar encoder.
4. **Channel Simulation**: Transmit the encoded bits through a simulated BEC.
5. **Decoding**: Recover the original input using a successive cancellation decoder (tree-based).
6. **Validation**: Compare decoded output with the original input to determine transmission success.

```
Input → [Encoder] → Encoded Input → [BEC Channel] → Received Output → [Decoder] → Decoded Output
```

## File Structure

- `main.m`: Main simulation script.
- `compute_bhattacharyya_BEC.m`: Computes Bhattacharyya parameters for BEC.
- `find_good_channels.m`: Selects the most reliable synthetic channels.
- `polarEncoder.m`: Encodes information bits into a polar codeword.
- `simulate_BEC_channel.m`: Simulates transmission over a BEC.
- `polarDecoderTree.m`: Decodes received vector using tree-based decoding.

## Parameters

| Parameter      | Description                                      |
|----------------|--------------------------------------------------|
| `EPSILON`      | Erasure probability of the BEC                   |
| `BLOCKLENGTH`  | Length of the codeword (must be a power of 2)    |
| `RATE`         | Code rate = K / BLOCKLENGTH                      |
| `K`            | Number of information bits per block             |

## Reference

E. Arıkan, “Channel polarization: A method for constructing capacity-achieving codes for symmetric binary-input memoryless channels,” *IEEE Trans. Inf. Theory*, vol. 55, no. 7, pp. 3051–3073, July 2009.

## Example

By default, the script uses:
- `EPSILON = 0.3`
- `BLOCKLENGTH = 16`
- `RATE = 1/2`

It will display whether the transmission was successful based on whether the decoded output matches the original input.
