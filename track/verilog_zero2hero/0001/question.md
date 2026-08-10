# Constants

**Difficulty:** ⭐ · **Topics:** constant drivers, literals

## Learning objective
Drive fixed logic values (0 and 1) onto outputs.

## Problem
Build `constants` that outputs a constant low and a constant high.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `zero` | output | 1 | always 0 |
| `one`  | output | 1 | always 1 |

## Hints
- `1'b0` and `1'b1` are sized binary literals.

## SystemVerilog notes
A sized literal `N'b...` states the width explicitly; unsized `'0` / `'1` fill
all bits of the target and are handy for wide constants.
