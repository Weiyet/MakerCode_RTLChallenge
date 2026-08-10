# BCD to 7-segment

**Difficulty:** ⭐⭐⭐ · **Topics:** `case`, look-up mapping

## Learning objective
Map a 4-bit decimal digit to the seven segments of a display.

## Problem
Drive an **active-high**, common-cathode display. `seg[6:0]` maps to segments
`{g,f,e,d,c,b,a}` (bit 0 = segment a). For digits 0-9 output the standard
pattern; for A-F (10-15) output all segments off (`7'b0000000`).

```
 aaa
f   b
f   b
 ggg
e   c
e   c
 ddd
```

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `bcd` | input  | 4 | digit 0-15 |
| `seg` | output | 7 | `{g,f,e,d,c,b,a}` active-high |

## Segment table (hex value of {g,f,e,d,c,b,a})
| digit | seg | | digit | seg |
|-------|-----|-|-------|-----|
| 0 | 3F | | 5 | 6D |
| 1 | 06 | | 6 | 7D |
| 2 | 5B | | 7 | 07 |
| 3 | 4F | | 8 | 7F |
| 4 | 66 | | 9 | 6F |

## Hints
- A `case (bcd)` with a `default: seg = 7'b0` handles 10-15 cleanly.
