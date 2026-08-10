# BCD to 7-segment

**Difficulty:** ⭐⭐⭐ · **Topics:** `case`, look-up

## Background
A seven-segment display shows a digit by lighting segments `a`..`g`. Mapping a
4-bit digit to the segment pattern is a pure **look-up table**, written as a
`case`. This uses an **active-high** display with `seg(6 downto 0) = {g,f,e,d,c,b,a}`
(bit 0 = segment `a`).

## The task
Digits 0-9 use the standard pattern; 10-15 output all-off.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `bcd` | in  | std_logic_vector(3 downto 0) | digit |
| `seg` | out | std_logic_vector(6 downto 0) | segments |

## Segment values ({g,f,e,d,c,b,a}, hex)
`0=3F 1=06 2=5B 3=4F 4=66 5=6D 6=7D 7=07 8=7F 9=6F`

## How to approach it
```vhdl
process(all)
begin
    case bcd is
        when "0000" => seg <= "0111111";  -- 3F
        -- ... 1 through 9 ...
        when others => seg <= "0000000";
    end case;
end process;
```
Use 7-bit **binary** string literals so the width matches `seg`.

## Common mistakes
- Using an 8-bit hex literal (`x"3F"`) for a 7-bit port — width mismatch. Use the
  7-bit binary strings.
- Getting the segment order/polarity wrong.

## VHDL notes
This `case` synthesizes to a small look-up. `when others` covers both the
non-decimal codes and any metavalue inputs.

## Run it (GHDL)
```bash
ghdl -a --std=08 0016/solution.vhdl 0016/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
