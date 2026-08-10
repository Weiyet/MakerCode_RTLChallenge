# Full adder

**Difficulty:** ⭐⭐ · **Topics:** carry logic

## Background
A **full adder** adds three bits: `a`, `b`, and a carry-in `cin`. This is the
cell you chain together to build any-width adders (each stage's `cout` feeds the
next stage's `cin`). The result is again `{cout, sum}`:
- `sum  = a ^ b ^ cin` — parity of the three inputs.
- `cout = 1` when **two or more** inputs are 1 (the majority function).

## The task
`{cout, sum} = a + b + cin`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b`, `cin` | input  | 1 | operands + carry in |
| `sum`  | output | 1 | sum bit |
| `cout` | output | 1 | carry out |

## How to approach it
```systemverilog
assign sum  = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);
```

## Worked example
`a=1, b=1, cin=1` → three 1s → `sum=1`, `cout=1` (i.e. binary 11 = 3).

## Common mistakes
- Writing `cout = a & b & cin` (only true when *all three* are 1). The carry needs
  the **majority** (any two), hence the three ORed AND terms.

## SystemVerilog notes
You will rarely hand-write wide adders — `a + b` infers one. The point here is to
understand the cell so the generate-based ripple adder (0012) makes sense.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0011/tb.sv 0011/solution.sv && vvp sim
```
