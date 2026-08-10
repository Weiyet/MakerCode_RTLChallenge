# BCD to 7-segment

**Difficulty:** ⭐⭐⭐ · **Topics:** `case`, look-up mapping

## Background
A seven-segment display lights combinations of segments `a`..`g` to show a digit.
Converting a 4-bit decimal digit to the right segment pattern is a pure
**look-up table**, naturally written as a `case`. This example drives an
**active-high, common-cathode** display where a `1` lights a segment, and packs
the segments as `seg[6:0] = {g,f,e,d,c,b,a}` (so bit 0 is segment `a`).

```
 aaa
f   b
f   b
 ggg
e   c
e   c
 ddd
```

## The task
For digits 0-9 output the standard pattern; for A-F (10-15) output all-off.

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

## How to approach it
```systemverilog
always_comb begin
    case (bcd)
        4'd0: seg = 7'h3F;
        // ... 1 through 9 ...
        default: seg = 7'h00;   // blanks 10-15
    endcase
end
```

## Common mistakes
- Getting the segment order wrong — confirm whether the display is `{a..g}` or
  `{g..a}` and whether it is active-high or -low. Here it is `{g,f,e,d,c,b,a}`,
  active-high.
- Missing the `default` for the non-decimal codes.

## SystemVerilog notes
A `case` like this synthesizes to a small ROM/logic look-up. Deriving each
segment as a boolean of `bcd` is possible but far less readable than the table.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0016/tb.sv 0016/solution.sv && vvp sim
```
