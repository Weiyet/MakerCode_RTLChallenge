# Full adder

**Difficulty:** ⭐⭐ · **Topics:** carry logic

## Learning objective
Add three bits (two operands + carry-in) — the cell used to build wide adders.

## Problem
`{cout, sum} = a + b + cin`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b`, `cin` | input  | 1 | operands + carry in |
| `sum`  | output | 1 | sum bit |
| `cout` | output | 1 | carry out |

## Hints
- `sum  = a ^ b ^ cin`
- `cout = (a & b) | (a & cin) | (b & cin)`
