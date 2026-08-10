# Priority encoder

**Difficulty:** ⭐⭐⭐ · **Topics:** priority via `if/elsif`

## Problem
Report the index of the **highest** set bit of `d`; `valid='0'` if none set.
(`in` is reserved, so the input is named `d`.)

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d`     | in  | std_logic_vector(3 downto 0) | request bits |
| `pos`   | out | std_logic_vector(1 downto 0) | index of highest set bit |
| `valid` | out | std_logic | any bit set |

## VHDL notes
A chained `if d(3)='1' then ... elsif d(2)='1' then ...` naturally encodes
priority — the first matching branch wins, highest bit first.
