# 4-to-1 Multiplexer

**Difficulty:** ⭐⭐ · **Topics:** `always_comb`, `case`, parameterized width

## Learning objective
Select one of four data buses using a `case` statement inside `always_comb`.

## Problem
Route one of `d0..d3` to `y` according to `sel`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `d0`..`d3` | input  | W | data inputs |
| `sel`      | input  | 2 | select |
| `y`        | output | W | selected data |

**Parameter:** `W` (default 8)

## Hints
- Cover every `sel` value; add a `default` to avoid latches.
