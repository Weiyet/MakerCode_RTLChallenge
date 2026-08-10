# Enabled register (load enable)

**Difficulty:** ⭐⭐ · **Topics:** clock enable, hold

## Learning objective
Update a register only when an enable is asserted; otherwise hold its value.

## Problem
`W`-bit register with async active-low reset. When `en=1`, load `d`; when `en=0`,
keep the current value.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`   | input  | 1 | clock |
| `rst_n` | input  | 1 | async active-low reset |
| `en`    | input  | 1 | load enable |
| `d`     | input  | W | data |
| `q`     | output | W | stored value |

**Parameter:** `W` (default 8)

## Hints
- `if (!rst_n) q<=0; else if (en) q<=d;` — no `else`, so it holds.
