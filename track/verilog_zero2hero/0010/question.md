# Half adder

**Difficulty:** ⭐ · **Topics:** XOR/AND, arithmetic from gates

## Background
Addition is built from gates. Adding two single bits gives a result that can be
0, 1, or 2 — which needs **two** output bits: a `sum` (the low bit) and a `cout`
(carry, the high bit). Looking at the truth table, `sum` is 1 exactly when the
inputs differ (that is XOR) and `cout` is 1 only when both are 1 (that is AND).
This two-gate cell is the **half adder**.

## The task
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

## How to approach it
```systemverilog
assign sum  = a ^ b;
assign cout = a & b;
```

## Common mistakes
- Swapping `sum` and `cout`.
- It is called "half" because it has no carry-*in* — that is the full adder
  (next problem).

## Run it
```bash
iverilog -g2012 -s tb -o sim 0010/tb.sv 0010/solution.sv && vvp sim
```
