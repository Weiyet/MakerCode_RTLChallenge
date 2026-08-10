# 4-to-1 Multiplexer

**Difficulty:** ⭐⭐ · **Topics:** `process`, `case`, generic width

## Problem
Route one of `d0..d3` to `y` according to `sel`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d0`..`d3` | in  | std_logic_vector(W-1 downto 0) | data |
| `sel`      | in  | std_logic_vector(1 downto 0) | select |
| `y`        | out | std_logic_vector(W-1 downto 0) | selected |

**Generic:** `W` (default 8)

## VHDL notes
`case sel is when "00" => ... when others => ... end case;` inside a
`process(all)` (VHDL-2008) covers every choice with no latch.
