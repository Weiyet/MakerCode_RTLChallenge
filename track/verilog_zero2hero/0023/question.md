# Enabled register (load enable)

**Difficulty:** ⭐⭐ · **Topics:** clock enable, hold

## Background
Often a register should update only on certain cycles and **hold** its value
otherwise. A **clock enable** does this: when `en` is high, load `d`; when low,
keep the current value. The trick is simply to have *no `else`* on the enable —
the flop then retains its state.

## The task
`W`-bit register with async active-low reset and a load enable.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`, `rst_n` | input | 1 | clock / async reset |
| `en`  | input  | 1 | load enable |
| `d`   | input  | W | data |
| `q`   | output | W | stored value |

**Parameter:** `W` (default 8)

## How to approach it
```systemverilog
always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)  q <= '0;
    else if (en) q <= d;   // no else -> holds when en=0
```

## Common mistakes
- Adding an `else q <= q;` — harmless but redundant; omitting the else already
  means "hold".
- Gating the *clock* itself instead of using a data enable (clock gating is a
  specialised technique; a data enable is the safe default).

## Run it
```bash
iverilog -g2012 -s tb -o sim 0023/tb.sv 0023/solution.sv && vvp sim
```
