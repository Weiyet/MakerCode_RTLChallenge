# Up/down counter with load

**Difficulty:** ⭐⭐⭐ · **Topics:** counters, priority of load/enable

## Learning objective
Combine several control inputs with a clear priority order in one register.

## Problem
`W`-bit counter, async active-low reset. Priority each clock:
1. `load` : `count <= load_val`
2. else `en` : `count <= count + 1` if `up_down`, else `count - 1`
3. else hold.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`      | input  | 1 | clock |
| `rst_n`    | input  | 1 | async active-low reset |
| `load`     | input  | 1 | synchronous load |
| `load_val` | input  | W | value to load |
| `en`       | input  | 1 | count enable |
| `up_down`  | input  | 1 | 1=up, 0=down |
| `count`    | output | W | counter value |

**Parameter:** `W` (default 8)

## Hints
- Write the `if / else if / else if` in priority order.
