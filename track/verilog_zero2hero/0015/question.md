# Priority encoder (casez)

**Difficulty:** ⭐⭐⭐ · **Topics:** `casez`, don't-cares, priority

## Learning objective
Encode the position of the highest-priority set bit using `casez` wildcards.

## Problem
Report the index of the **highest** set bit of a 4-bit input; `valid` is 0 when
no bits are set.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`    | input  | 4 | request bits |
| `pos`   | output | 2 | index of highest set bit |
| `valid` | output | 1 | 1 if any bit set |

## Behaviour
| in    | valid | pos |
|-------|-------|-----|
| 1xxx  | 1 | 3 |
| 01xx  | 1 | 2 |
| 001x  | 1 | 1 |
| 0001  | 1 | 0 |
| 0000  | 0 | 0 |

## Hints
- In `casez`, `?` (or `z`) in a pattern is a wildcard, so `4'b1???` matches any
  input whose MSB is 1.

## SystemVerilog notes
`casez` treats `?`/`z` bits in the *case items* as don't-cares. Prefer it over
`casex` (which also wild-cards `x`, hiding bugs).
