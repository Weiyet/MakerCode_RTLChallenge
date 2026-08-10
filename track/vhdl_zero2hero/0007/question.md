# Combinational logic (half & full adder)

**Difficulty:** ⭐⭐ · **Topics:** arithmetic from gates, carry

## Background
A **half adder**: `sum = a xor b`, `carry = a and b`. A **full adder** adds a
carry-in so it chains: `sum = a xor b xor cin`, `cout = majority(a,b,cin)`.

## The task
Build `adders` exposing half-adder outputs (`h_sum`, `h_cout`) and full-adder
outputs (`sum`, `cout`).

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b` | in | std_logic | operands |
| `cin`    | in | std_logic | carry-in |
| `h_sum`, `h_cout` | out | std_logic | half-adder |
| `sum`, `cout`     | out | std_logic | full-adder |

## How to approach it
```vhdl
h_sum  <= a xor b;
h_cout <= a and b;
sum    <= a xor b xor cin;
cout   <= (a and b) or (a and cin) or (b and cin);
```
