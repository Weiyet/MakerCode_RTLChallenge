# Edge detector (one-pulse)

**Difficulty:** ⭐⭐⭐ · **Topics:** registering history, one-cycle pulse

## Learning objective
Detect rising and falling edges of a slow signal by remembering its previous
value, and emit a single-cycle pulse.

## Problem
Register `sig` into `prev`. Each clock produce:
- `rise` = 1 for one cycle when `sig` went 0→1
- `fall` = 1 for one cycle when `sig` went 1→0

Async active-low reset. Outputs are **registered** (delayed one cycle).

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`, `rst_n` | input | 1 | clock / reset |
| `sig`  | input  | 1 | monitored signal |
| `rise` | output | 1 | rising-edge pulse |
| `fall` | output | 1 | falling-edge pulse |

```wavedrom
{ "signal": [
  {"name":"clk","wave":"p......"},
  {"name":"sig","wave":"0.1..0."},
  {"name":"rise","wave":"0..10.."},
  {"name":"fall","wave":"0....10"}
]}
```

## Hints
- `rise <= sig & ~prev;`  `fall <= ~sig & prev;`  `prev <= sig;`
