# Byte reverse (array type)

**Difficulty:** ⭐⭐ · **Topics:** array `type`, byte addressing

## Learning objective
Use a user-defined array `type` as scratch storage — the VHDL equivalent of an
"unpacked array".

## Problem
Reverse the **byte** order of a 32-bit word:
`y = d(7 downto 0) & d(15 downto 8) & d(23 downto 16) & d(31 downto 24)`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d` | in  | std_logic_vector(31 downto 0) | packed word |
| `y` | out | std_logic_vector(31 downto 0) | byte-swapped |

## VHDL notes
Declare `type byte_arr is array(0 to 3) of std_logic_vector(7 downto 0);` — an
array *of* vectors, distinct from one wide vector. Element `b(0)` is one byte.
