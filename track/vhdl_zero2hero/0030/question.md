# Switch debouncer

**Difficulty:** ⭐⭐⭐⭐ · **Topics:** counter + condition, glitch rejection

## Problem
Only accept a new level after `noisy` has stayed different from `clean` for
`STABLE` consecutive clocks. Any match resets the counter. Async active-low reset
clears `clean`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / reset |
| `noisy` | in  | std_logic | raw input |
| `clean` | out | std_logic | debounced output |

**Generic:** `STABLE` (default 4)
