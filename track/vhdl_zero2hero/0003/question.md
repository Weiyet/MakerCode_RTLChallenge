# Basic logic gates

**Difficulty:** ⭐ · **Topics:** logical operators, multiple outputs

## Problem
Produce the six basic gate results of `a` and `b`.

## Interface
| Port | Dir | Type | Function |
|------|-----|------|----------|
| `a`, `b`   | in  | std_logic | operands |
| `y_and`    | out | std_logic | a and b |
| `y_or`     | out | std_logic | a or b |
| `y_xor`    | out | std_logic | a xor b |
| `y_nand`   | out | std_logic | a nand b |
| `y_nor`    | out | std_logic | a nor b |
| `y_xnor`   | out | std_logic | a xnor b |

## VHDL notes
VHDL has dedicated `nand`/`nor`/`xnor` operators — no need to write `not(a and b)`.
