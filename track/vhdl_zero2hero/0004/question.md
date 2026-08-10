# Vectors (reduction operators)

**Difficulty:** ⭐⭐ · **Topics:** VHDL-2008 unary reduction

## Background
A **reduction** folds a whole vector into one bit. **VHDL-2008** added unary
operators for this: `and d`, `or d`, `xor d` each return a single `std_logic`.
(Before 2008 you wrote a loop.) This is distinct from the *binary* operators of
problem 0003, which combine two vectors lane-by-lane.

## The task
`all_ones = and d`, `any_one = or d`, `parity = xor d` for an 8-bit input.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d`        | in  | std_logic_vector(7 downto 0) | data |
| `all_ones` | out | std_logic | `and d` |
| `any_one`  | out | std_logic | `or d` |
| `parity`   | out | std_logic | `xor d` |

## How to approach it
```vhdl
all_ones <= and d;
any_one  <= or d;
parity   <= xor d;
```

## Common mistakes
- Compiling without `--std=08` — the unary reduction operators are a 2008 feature.
- Confusing `d and d` (binary, 8 bits) with `and d` (reduction, 1 bit).

## VHDL notes
`xor d` gives the parity (1 when an odd number of bits are set). Pre-2008 code
uses a `for` loop over the bits instead.
