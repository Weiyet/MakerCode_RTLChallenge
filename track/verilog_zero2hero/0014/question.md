# 2-to-4 Decoder (with enable)

**Difficulty:** ⭐⭐ · **Topics:** decoders, one-hot, enable

## Learning objective
Turn a binary code into a one-hot output, gated by an enable.

## Problem
When `en=1`, assert exactly the `out` bit selected by `in`; when `en=0`, all
outputs are 0.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`  | input  | 2 | binary code |
| `en`  | input  | 1 | enable |
| `out` | output | 4 | one-hot (or all-zero) |

## Truth table (en=1)
| in | out |
|----|-----|
| 00 | 0001 |
| 01 | 0010 |
| 10 | 0100 |
| 11 | 1000 |

## Hints
- `out = en ? (4'b1 << in) : 4'b0;` — or a `case`.
