# Reduction operators

**Difficulty:** ⭐⭐ · **Topics:** VHDL-2008 unary reduction

## Learning objective
Collapse a whole vector to one bit.

## Problem
For an 8-bit input `d`:
- `all_ones` = AND of every bit
- `any_one`  = OR  of every bit
- `parity`   = XOR of every bit

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d`        | in  | std_logic_vector(7 downto 0) | data |
| `all_ones` | out | std_logic | `and d` |
| `any_one`  | out | std_logic | `or d` |
| `parity`   | out | std_logic | `xor d` |

## VHDL notes
VHDL-2008 added **unary reduction** operators: `and d`, `or d`, `xor d` return a
single `std_logic`. (Before 2008 you had to write a loop.) Compile with
`--std=08`.
