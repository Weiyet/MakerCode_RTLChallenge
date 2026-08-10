# Full adder

**Difficulty:** ⭐⭐ · **Topics:** carry logic

## Background
A **full adder** sums three bits: `a`, `b`, and a carry-in `cin`. Chaining these
(each stage's `cout` into the next `cin`) builds any-width adders. `sum` is the
parity `a xor b xor cin`; `cout` is 1 when **two or more** inputs are 1 (majority).

## The task
`(cout, sum) = a + b + cin`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b`, `cin` | in  | std_logic | operands + carry in |
| `sum`  | out | std_logic | sum bit |
| `cout` | out | std_logic | carry out |

## How to approach it
```vhdl
sum  <= a xor b xor cin;
cout <= (a and b) or (a and cin) or (b and cin);
```

## Common mistakes
- `cout <= a and b and cin` is wrong — the carry is the **majority** of the three.

## VHDL notes
Wide adders are normally inferred from `unsigned` `+`; this cell just builds the
intuition for the generate-based ripple adder next.

## Run it (GHDL)
```bash
ghdl -a --std=08 0011/solution.vhdl 0011/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
