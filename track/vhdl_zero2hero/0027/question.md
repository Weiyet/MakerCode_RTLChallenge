# Edge detector (one-pulse)

**Difficulty:** ⭐⭐⭐ · **Topics:** registering history, one-cycle pulse

## Problem
Register `sig` into `prev`. Each clock, produce a one-cycle `rise` on a 0->1
transition and `fall` on a 1->0 transition. Outputs are registered. Async
active-low reset.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / reset |
| `sig`  | in  | std_logic | monitored signal |
| `rise` | out | std_logic | rising-edge pulse |
| `fall` | out | std_logic | falling-edge pulse |

```wavedrom
{ "signal": [
  {"name":"clk","wave":"p......"},
  {"name":"sig","wave":"0.1..0."},
  {"name":"rise","wave":"0..10.."},
  {"name":"fall","wave":"0....10"}
]}
```
