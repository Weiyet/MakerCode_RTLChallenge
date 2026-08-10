# D flip-flop

**Difficulty:** ⭐⭐ · **Topics:** `always_ff`, non-blocking `<=`, clock edge

## Learning objective
Your first sequential element: capture `d` on the rising clock edge.

## Problem
On every rising edge of `clk`, `q` takes the value of `d`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk` | input  | 1 | clock |
| `d`   | input  | 1 | data |
| `q`   | output | 1 | registered data |

```wavedrom
{ "signal": [
  {"name": "clk", "wave": "p......"},
  {"name": "d",   "wave": "0.1..0."},
  {"name": "q",   "wave": "0..1..0"}
]}
```

## Hints
- Use `always_ff @(posedge clk)` with a non-blocking assignment `q <= d;`.

## SystemVerilog notes
`always_ff` documents intent (a flip-flop) and lets the tool flag accidental
combinational/latch logic. Always use `<=` (non-blocking) for sequential state.
