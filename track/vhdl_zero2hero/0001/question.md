# Constants

**Difficulty:** ⭐ · **Topics:** literals, concurrent assignment

## Background
An output can be tied to a fixed value — physically a connection to ground (`'0'`)
or the supply rail (`'1'`). In VHDL a single-bit literal uses **single quotes**
(`'0'`, `'1'`); multi-bit literals use **double quotes** (`"1010"`). You drive a
constant onto a port with a concurrent assignment.

## The task
`zero` is always `'0'`; `one` is always `'1'`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `zero` | out | std_logic | constant 0 |
| `one`  | out | std_logic | constant 1 |

## How to approach it
```vhdl
zero <= '0';
one  <= '1';
```

## Common mistakes
- Using double quotes for a single bit (`"0"` is a 1-element vector, not a
  `std_logic`).

## VHDL notes
For a wide constant, an **aggregate** fills every bit: `bus <= (others => '0');`
clears a vector of any width.

## Run it (GHDL)
```bash
# from track/vhdl_zero2hero/
ghdl -a --std=08 0001/solution.vhdl 0001/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
A correct run prints `Test PASS`. Swap `solution.vhdl` for `interface.vhdl` to test
your own answer.
