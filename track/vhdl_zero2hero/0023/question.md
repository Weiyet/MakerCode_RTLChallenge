# Enabled register (load enable)

**Difficulty:** ⭐⭐ · **Topics:** clock enable, hold

## Problem
`W`-bit register with async active-low reset. When `en='1'` load `d`; otherwise
hold.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / async reset |
| `en` | in  | std_logic | load enable |
| `d`  | in  | std_logic_vector(W-1 downto 0) | data |
| `q`  | out | std_logic_vector(W-1 downto 0) | stored value |

**Generic:** `W` (default 8)

## VHDL notes
Leaving out the `else` on `if en='1' then q<=d; end if;` makes the register
*hold* its value.
