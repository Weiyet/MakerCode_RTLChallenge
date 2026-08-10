# ALU with an enumerated opcode

**Difficulty:** ⭐⭐⭐ · **Topics:** enumerated `type`, `'val`, `case`, `numeric_std`

## Learning objective
Decode a numeric opcode into a named enumerated type and switch on it.

## Problem
8-bit ALU. `op` selects the operation; `zero='1'` when the result is all-zero.

| op | name | y |
|----|------|---|
| 0 | ADD | a + b |
| 1 | SUB | a - b |
| 2 | AND | a and b |
| 3 | OR  | a or b |
| 4 | XOR | a xor b |
| 5 | SLL | a shifted left by b(2:0) |
| 6 | SRL | a shifted right by b(2:0) |
| 7 | SLT | 1 if a < b (unsigned) else 0 |

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b` | in  | std_logic_vector(W-1 downto 0) | operands |
| `op`     | in  | std_logic_vector(2 downto 0)   | opcode |
| `y`      | out | std_logic_vector(W-1 downto 0) | result |
| `zero`   | out | std_logic | result = 0 |

**Generic:** `W` (default 8)

## VHDL notes
`type op_t is (OP_ADD, OP_SUB, ...);` defines an enumerated type. `op_t'val(n)`
converts an integer position to the enum value, so you can `case` on readable
names. Arithmetic uses `unsigned` from `ieee.numeric_std`.
