# ALU with enum opcodes

**Difficulty:** ⭐⭐⭐ · **Topics:** `enum`, `case`, `always_comb`, status flags

## Learning objective
Use a named `enum` for opcodes instead of magic numbers, and produce a status
flag alongside the result.

## Problem
Implement an 8-bit ALU. `op` selects the operation; `zero` is 1 when the result
is all-zero.

| op | name | y |
|----|------|---|
| 0 | ADD | a + b |
| 1 | SUB | a - b |
| 2 | AND | a & b |
| 3 | OR  | a \| b |
| 4 | XOR | a ^ b |
| 5 | SLL | a << b[2:0] |
| 6 | SRL | a >> b[2:0] |
| 7 | SLT | (a < b) ? 1 : 0 (unsigned) |

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b` | input  | W | operands |
| `op`     | input  | 3 | opcode |
| `y`      | output | W | result |
| `zero`   | output | 1 | result == 0 |

**Parameter:** `W` (default 8)

## SystemVerilog notes
Declare `typedef enum logic [2:0] { OP_ADD, OP_SUB, ... } op_e;` and switch on the
named values — the intent is self-documenting and the tool checks the width.
