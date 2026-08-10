# Shift register (SIPO)

**Difficulty:** ⭐⭐ · **Topics:** shifting, `&`

## Problem
Each clock shift left and insert `sin` at the LSB: `q <= q(W-2 downto 0) & sin`.
Async active-low reset clears `q`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / async reset |
| `sin` | in  | std_logic | serial input |
| `q`   | out | std_logic_vector(W-1 downto 0) | parallel output |

**Generic:** `W` (default 8)
