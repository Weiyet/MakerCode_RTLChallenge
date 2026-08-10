# Up/down counter with load

**Difficulty:** ⭐⭐⭐ · **Topics:** counters, priority

## Problem
`W`-bit counter, async active-low reset. Priority each clock:
1. `load` -> `count <= load_val`
2. else `en` -> +1 if `up_down='1'`, else -1
3. else hold.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / async reset |
| `load`     | in  | std_logic | synchronous load |
| `load_val` | in  | std_logic_vector(W-1 downto 0) | value to load |
| `en`       | in  | std_logic | count enable |
| `up_down`  | in  | std_logic | 1=up, 0=down |
| `count`    | out | std_logic_vector(W-1 downto 0) | counter |

**Generic:** `W` (default 8)

## VHDL notes
Keep the count as `unsigned` internally (`ieee.numeric_std`) for `+ 1` / `- 1`,
and convert to `std_logic_vector` on the output.
