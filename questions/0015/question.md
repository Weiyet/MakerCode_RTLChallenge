# Parameterizable Binary to Gray Code Converter

## Problem Statement

Binary-to-Gray code converters are essential components in digital systems, commonly used in counters, rotary encoders, position sensors, and asynchronous data transfer applications. Gray code (also known as reflected binary code) ensures that only one bit changes at a time when incrementing, reducing errors in digital systems and eliminating race conditions.

Design a parameterizable binary-to-Gray code converter that converts standard binary input to Gray code output. The module should be configurable to handle different word widths through a parameter, making it reusable across various applications requiring different data widths.

### Module Interface

**Module Name**: `binary_to_gray_code`

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| `bin_i` | Input | `[VEC_W-1:0]` | Binary input |
| `gray_o` | Output | `[VEC_W-1:0]` | Gray code output |

**Parameters**:
| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| `VEC_W` | 4 | Width of input/output vectors |

### Functional Requirements

1. **Binary to Gray Conversion**: Convert standard binary to Gray code
2. **Parameterizable Width**: Support different word widths through parameter
3. **Combinational Logic**: Pure combinational implementation (no clock required)
4. **Single Bit Change**: Gray code ensures only one bit changes between consecutive values
5. **Reflective Property**: Gray code exhibits reflective symmetry

### Example Operation

**Conversion Algorithm:**
- MSB of Gray code: `gray_o[VEC_W-1] = bin_i[VEC_W-1]`
- Other bits: `gray_o[i] = bin_i[i+1] ^ bin_i[i]` for i = VEC_W-2 down to 0

For VEC_W = 4:

| Decimal | Binary (bin_i) | Gray Code (gray_o) | Bits Changed |
|---------|----------------|-------------------|--------------|
| 0       | 0000           | 0000              | -            |
| 1       | 0001           | 0001              | 1            |
| 2       | 0010           | 0011              | 1            |
| 3       | 0011           | 0010              | 1            |
| 4       | 0100           | 0110              | 1            |
| 5       | 0101           | 0111              | 1            |
| 6       | 0110           | 0101              | 1            |
| 7       | 0111           | 0100              | 1            |
| 8       | 1000           | 1100              | 1            |
| 9       | 1001           | 1101              | 1            |
| 10      | 1010           | 1111              | 1            |
| 11      | 1011           | 1110              | 1            |
| 12      | 1100           | 1010              | 1            |
| 13      | 1101           | 1011              | 1            |
| 14      | 1110           | 1001              | 1            |
| 15      | 1111           | 1000              | 1            |

## Constraints
NA