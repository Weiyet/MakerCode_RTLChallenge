# Reduction operators

**Difficulty:** ⭐⭐ · **Topics:** reduction `&` `|` `^`

## Learning objective
Collapse a whole vector to a single bit with *reduction* operators.

## Problem
For an 8-bit input compute:
- `all_ones`  = AND of every bit
- `any_one`   = OR  of every bit
- `parity`    = XOR of every bit (even parity)

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`       | input  | 8 | data |
| `all_ones` | output | 1 | `&in` |
| `any_one`  | output | 1 | `|in` |
| `parity`   | output | 1 | `^in` |

## Hints
- A unary `&`, `|`, or `^` in front of a vector is a reduction.

## SystemVerilog notes
Reduction differs from bitwise: `&in` returns one bit (`in[0]&in[1]&...`),
whereas `a & b` operates lane-by-lane.
