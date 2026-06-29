# Carry Lookahead Adder

## Problem Statement

Design a carry lookahead adder (CLA) that performs fast binary addition by computing carry signals in parallel rather than sequentially. This advanced adder architecture is used in high-performance processors where addition speed is critical.

### Module Interface

**Module Name**: `carry_lookahead_adder`

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| `a_in` | Input | `[WIDTH-1:0]` | First operand |
| `b_in` | Input | `[WIDTH-1:0]` | Second operand |
| `c_in` | Input | 1 | Carry input |
| `sum_out` | Output | `[WIDTH-1:0]` | Sum result |
| `c_out` | Output | 1 | Carry output |

**Parameters**:
| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| `WIDTH` | 4 | Bit width of operands (typically 4, 8, 16) |

### Functional Requirements

1. **Carry Lookahead Logic**: Implement true CLA algorithm, not ripple carry
2. **Generate and Propagate**: Compute G and P signals for each bit position
3. **Parallel Carry**: Calculate all carry bits simultaneously
4. **Fast Operation**: Minimize critical path delay
5. **Correct Results**: Produce same results as ripple carry adder
6. **Parameterizable**: Support different bit widths

### Carry Lookahead Theory

For each bit position i:
- **Generate**: Gi = Ai & Bi (creates carry regardless of input carry)
- **Propagate**: Pi = Ai ⊕ Bi (passes carry from previous stage)
- **Carry**: Ci+1 = Gi + Pi·Ci

For 4-bit CLA:
- C1 = G0 + P0·C0
- C2 = G1 + P1·C1 = G1 + P1·G0 + P1·P0·C0
- C3 = G2 + P2·C2 = G2 + P2·G1 + P2·P1·G0 + P2·P1·P0·C0
- C4 = G3 + P3·C3 = G3 + P3·G2 + P3·P2·G1 + P3·P2·P1·G0 + P3·P2·P1·P0·C0

### Example Operation

For WIDTH = 4, adding A=5 (0101) + B=3 (0011) + Cin=0:
- G = [0,0,1,0], P = [1,1,0,1]
- C = [0,0,1,1,1]
- Sum = 8 (1000), Cout = 0

## Constraints
- Use true carry lookahead logic (not ripple carry)
- All carry bits computed in parallel
- Generate and propagate signals for each bit
- Support WIDTH up to 16 bits efficiently
- Combinational implementation only