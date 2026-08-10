# D flip-flop

**Difficulty:** ⭐⭐ · **Topics:** clocked `process`, `rising_edge`

## Learning objective
Your first sequential element: capture `d` on the rising clock edge.

## Problem
On every rising edge of `clk`, `q` takes `d`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk` | in  | std_logic | clock |
| `d`   | in  | std_logic | data |
| `q`   | out | std_logic | registered data |

```wavedrom
{ "signal": [
  {"name":"clk","wave":"p......"},
  {"name":"d",  "wave":"0.1..0."},
  {"name":"q",  "wave":"0..1..0"}
]}
```

## VHDL notes
`process(clk) ... if rising_edge(clk) then q <= d; end if;` is the canonical flop.
`rising_edge` comes from `ieee.std_logic_1164`.
