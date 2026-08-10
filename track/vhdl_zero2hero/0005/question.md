# Vector split

**Difficulty:** ⭐ · **Topics:** `std_logic_vector`, slicing with `downto`

## Learning objective
Declare a multi-bit vector and pull out sub-fields with a slice.

## Problem
Split a 16-bit word into upper and lower bytes. (`in` is reserved, so the input
is named `d`.)

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d`  | in  | std_logic_vector(15 downto 0) | packed word |
| `hi` | out | std_logic_vector(7 downto 0)  | `d(15 downto 8)` |
| `lo` | out | std_logic_vector(7 downto 0)  | `d(7 downto 0)` |

## VHDL notes
Slices use the same direction as the declaration: with `(15 downto 0)` you slice
`d(15 downto 8)`. Widths must match on assignment.
