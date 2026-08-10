# 2-to-4 Decoder (with enable)

**Difficulty:** ⭐⭐ · **Topics:** one-hot, `to_integer`

## Problem
When `en='1'`, assert the `y` bit selected by `code`; otherwise all zero.
(`in` is reserved, so the code input is named `code`.)

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `code` | in  | std_logic_vector(1 downto 0) | binary code |
| `en`   | in  | std_logic | enable |
| `y`    | out | std_logic_vector(3 downto 0) | one-hot |

## VHDL notes
Index a vector with an integer: `y(to_integer(unsigned(code))) <= '1';`
(`to_integer`/`unsigned` come from `ieee.numeric_std`).
