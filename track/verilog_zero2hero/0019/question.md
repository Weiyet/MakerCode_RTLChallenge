# Population count (parameterized)

**Difficulty:** ⭐⭐⭐ · **Topics:** `parameter`, `$clog2`, accumulate in `always_comb`

## Learning objective
Count how many bits are set, with an output width that scales with the input
using `$clog2`.

## Problem
Return the number of 1s in a `WIDTH`-bit input.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`    | input  | WIDTH | data |
| `count` | output | $clog2(WIDTH+1) | number of set bits |

**Parameter:** `WIDTH` (default 8)

## Hints
- `count` needs `$clog2(WIDTH+1)` bits (0..WIDTH inclusive).
- Accumulate `count += in[i]` in a `for` loop.

## SystemVerilog notes
`$clog2(n)` is the ceiling of log2 — the number of bits needed to represent
values `0..n-1`. Using it keeps ports correctly sized as `WIDTH` changes.
