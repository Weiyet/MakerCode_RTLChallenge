# BCD to 7-segment

**Difficulty:** ⭐⭐⭐ · **Topics:** `case`, look-up

## Problem
Map a 4-bit digit to seven active-high segments `{g,f,e,d,c,b,a}` (bit 0 =
segment a). Digits 0-9 use the standard pattern; 10-15 output all off.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `bcd` | in  | std_logic_vector(3 downto 0) | digit |
| `seg` | out | std_logic_vector(6 downto 0) | segments |

## Segment values ({g,f,e,d,c,b,a}, hex)
0=3F 1=06 2=5B 3=4F 4=66 5=6D 6=7D 7=07 8=7F 9=6F
