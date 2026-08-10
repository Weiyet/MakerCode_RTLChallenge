# Half adder

**Difficulty:** ⭐ · **Topics:** xor/and, arithmetic from gates

## Background
Adding two single bits can give 0, 1, or 2, which needs two output bits: a `sum`
(low bit) and a `cout` (carry). From the truth table, `sum` is 1 when the inputs
differ (XOR) and `cout` is 1 only when both are 1 (AND). This two-gate cell is the
**half adder** — the seed of all wider adders.

## The task
`sum = a xor b`, `cout = a and b`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b` | in  | std_logic | operands |
| `sum`    | out | std_logic | `a xor b` |
| `cout`   | out | std_logic | `a and b` |

## Truth table
| a | b | cout | sum |
|---|---|------|-----|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 0 |

## How to approach it
```vhdl
sum  <= a xor b;
cout <= a and b;
```

## Common mistakes
- Swapping `sum` and `cout`.
- It is "half" because there is no carry-*in* (that is the full adder).

## Run it (GHDL)
```bash
ghdl -a --std=08 0010/solution.vhdl 0010/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
