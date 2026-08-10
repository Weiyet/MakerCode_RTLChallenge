# 2-to-1 Multiplexer

**Difficulty:** ⭐⭐ · **Topics:** conditional signal assignment

## Problem
`sel = '0'` selects `a`; `sel = '1'` selects `b`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`   | in  | std_logic | data 0 |
| `b`   | in  | std_logic | data 1 |
| `sel` | in  | std_logic | select |
| `y`   | out | std_logic | selected data |

## VHDL notes
The `when ... else` conditional assignment reads like the truth table:
`y <= b when sel = '1' else a;`
