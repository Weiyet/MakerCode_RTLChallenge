# Gray / binary codec (functions)

**Difficulty:** ⭐⭐⭐ · **Topics:** `function automatic`, reuse

## Learning objective
Factor repeated combinational math into `function`s and call them from `assign`.

## Problem
Provide two conversions:
- `gray`    = binary-to-Gray of `bin`   (`g = b ^ (b >> 1)`)
- `bin_out` = Gray-to-binary of `gray_in`

Gray code changes only one bit between consecutive values — useful for counters
that cross clock domains.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `bin`     | input  | W | binary in |
| `gray_in` | input  | W | Gray in |
| `gray`    | output | W | Gray of `bin` |
| `bin_out` | output | W | binary of `gray_in` |

**Parameter:** `W` (default 4)

## Hints
- `bin2gray`: `return b ^ (b >> 1);`
- `gray2bin`: MSB copies through, then `b[i] = b[i+1] ^ g[i]`.

## SystemVerilog notes
`function automatic` gives each call its own storage (safe for reuse/recursion)
and may contain loops and local variables — a clean way to share logic.
