# Concatenation & replication

**Difficulty:** ⭐⭐ · **Topics:** `{a,b}` concat, `{N{x}}` replication

## Learning objective
Build wider vectors from smaller pieces and repeat a pattern.

## Problem
Given bytes `a` and `b`:
- `cat`        = `{a, b}` (16 bits, `a` in the MSBs)
- `rep4`       = four copies of `a` (32 bits)
- `nib_swap`   = `a` with its two nibbles swapped

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b`   | input  | 8  | operands |
| `cat`      | output | 16 | `{a,b}` |
| `rep4`     | output | 32 | `{4{a}}` |
| `nib_swap` | output | 8  | `{a[3:0], a[7:4]}` |

## Hints
- Concatenation packs left-to-right, MSB first.
- `{4{a}}` repeats `a` four times.
