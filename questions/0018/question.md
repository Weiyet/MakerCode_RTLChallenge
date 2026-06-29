# Parameterizable Binary to One-Hot Encoder

## Problem Statement

Binary-to-one-hot encoders are essential components in digital systems, commonly used for address decoding, chip select generation, state machine one-hot encoding, priority encoding, and memory/register bank selection. These encoders provide efficient decoding functionality where only one output bit is asserted for each unique binary input combination.

Design a parameterizable binary-to-one-hot encoder that converts a binary input to a one-hot output. The module should be configurable to handle different input widths and corresponding output widths through parameters, making it reusable across various applications requiring different address spaces and selection schemes.

### Module Interface

**Module Name**: `binary_to_one_hot`

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| `bin_i` | Input | `[BIN_W-1:0]` | Binary input |
| `one_hot_o` | Output | `[ONE_HOT_W-1:0]` | One-hot encoded output |

**Parameters**:
| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| `BIN_W` | 4 | Width of binary input |
| `ONE_HOT_W` | 16 | Width of one-hot output (should be 2^BIN_W) |

### Functional Requirements

1. **Binary to One-Hot Conversion**: Convert binary input to one-hot encoded output
2. **Parameterizable Width**: Support different input/output widths through parameters
3. **Combinational Logic**: Pure combinational implementation (no clock required)
4. **One-Hot Encoding**: Only one bit should be high in the output
5. **Valid Range**: Input values should be within valid range (0 to 2^BIN_W - 1)

### Example Operation

**Encoding Behavior:**
- Input Range: `bin_i` can be from 0 to `(2^BIN_W - 1)`
- Output Format: `one_hot_o = 1 << bin_i`
- Bit Position: The bit at position `bin_i` is set to 1, all others are 0

For BIN_W = 4, ONE_HOT_W = 16:

| bin_i (decimal) | bin_i (binary) | one_hot_o (binary) | one_hot_o (hex) |
|-----------------|----------------|--------------------| ----------------|
| 0               | 0000           | 0000000000000001   | 0x0001          |
| 1               | 0001           | 0000000000000010   | 0x0002          |
| 5               | 0101           | 0000000000100000   | 0x0020          |
| 12              | 1100           | 0001000000000000   | 0x1000          |
| 15              | 1111           | 1000000000000000   | 0x8000          |

For BIN_W = 3, ONE_HOT_W = 8:

| bin_i (decimal) | bin_i (binary) | one_hot_o (binary) | one_hot_o (hex) |
|-----------------|----------------|--------------------|-----------------|
| 0               | 000            | 00000001           | 0x01            |
| 2               | 010            | 00000100           | 0x04            |
| 7               | 111            | 10000000           | 0x80            |

## Constraints
- `ONE_HOT_W` should equal `2^BIN_W` for complete encoding
- Input `bin_i` should be in range [0, ONE_HOT_W-1]
- If `bin_i >= ONE_HOT_W`, behavior is undefined