# Combinational logic (half & full adder)

**Difficulty:** ⭐⭐ · **Topics:** arithmetic from gates, carry

## Background
A **half adder** adds two bits: `sum = a ^ b`, `carry = a & b`. A **full adder**
also takes a carry-in, so it can be chained: `{cout, sum} = a + b + cin`. The full
adder is the cell a ripple-carry adder is built from.

## The task
Build `adders` exposing both: half-adder outputs (`h_sum`, `h_cout`) from `a`,`b`,
and full-adder outputs (`sum`, `cout`) from `a`,`b`,`cin`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b` | input  | 1 | operands |
| `cin`    | input  | 1 | carry-in (full adder) |
| `h_sum`, `h_cout` | output | 1 | half-adder sum/carry |
| `sum`, `cout`     | output | 1 | full-adder sum/carry |

## How to approach it
```systemverilog
assign {h_cout, h_sum} = a + b;         // half adder
assign {cout,  sum}    = a + b + cin;   // full adder
```

## Common mistakes
- Forgetting the concatenation `{carry, sum}` to capture the 2-bit result.
