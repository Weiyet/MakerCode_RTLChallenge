# Inverter (NOT)

**Difficulty:** ⭐ · **Topics:** logical `not`

## Problem
`y = not a`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a` | in  | std_logic | source |
| `y` | out | std_logic | inverted source |

## VHDL notes
`not`, `and`, `or`, `xor`, `nand`, `nor`, `xnor` are logical operators (and
reserved words) — that is why signals are named `y_and` etc., not `and`.
