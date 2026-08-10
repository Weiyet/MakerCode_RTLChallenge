# Population count (generic)

**Difficulty:** ⭐⭐⭐ · **Topics:** `generic`, `math_real` for sizing, loop accumulate

## Learning objective
Count set bits with an output width that scales with the input.

## Problem
Return the number of 1s in a `WIDTH`-bit input.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d`     | in  | std_logic_vector(WIDTH-1 downto 0) | data |
| `count` | out | std_logic_vector(ceil(log2(WIDTH+1))-1 downto 0) | number of 1s |

**Generic:** `WIDTH` (default 8)

## VHDL notes
VHDL has no `$clog2`; size the port with
`integer(ceil(log2(real(WIDTH+1))))` from `ieee.math_real`. Inside, accumulate
into an `integer` and convert with `to_unsigned(c, count'length)`.
