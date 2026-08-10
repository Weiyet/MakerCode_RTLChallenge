# Half adder

**Difficulty:** ⭐ · **Topics:** XOR/AND, arithmetic from gates

## Learning objective
Add two single bits and produce a sum and a carry.

## Problem
`sum = a XOR b`, `cout = a AND b`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b` | input  | 1 | operands |
| `sum`    | output | 1 | `a ^ b` |
| `cout`   | output | 1 | `a & b` |

## Truth table
| a | b | cout | sum |
|---|---|------|-----|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 0 |
