# Vector reverse

**Difficulty:** ⭐⭐ · **Topics:** `process`, `for` loop

## Learning objective
Use a `for` loop inside a combinational `process` to wire logic bit-by-bit.

## Problem
Reverse the bit order of an 8-bit vector: `y(i) = d(7-i)`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d` | in  | std_logic_vector(7 downto 0) | data |
| `y` | out | std_logic_vector(7 downto 0) | bit-reversed |

## VHDL notes
A combinational `process(d)` with a `for i in 0 to 7 loop` is unrolled by the
synthesizer. List every read signal in the sensitivity list (or use
`process(all)` in VHDL-2008).
