# Shift register (SIPO)

**Difficulty:** ⭐⭐ · **Topics:** shifting, serial-in parallel-out

## Learning objective
Shift serial data through a register, oldest bit falling off the top.

## Problem
Each clock, shift left by one and insert `sin` at the LSB:
`q <= {q[W-2:0], sin}`. Async active-low reset clears `q`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`   | input  | 1 | clock |
| `rst_n` | input  | 1 | async active-low reset |
| `sin`   | input  | 1 | serial input |
| `q`     | output | W | parallel output |

**Parameter:** `W` (default 8)

```wavedrom
{ "signal": [
  {"name":"clk","wave":"p....."},
  {"name":"sin","wave":"01.0.1"},
  {"name":"q[0]","wave":"0.1.0."}
]}
```

## Hints
- `{q[W-2:0], sin}` drops the MSB and appends `sin`.
