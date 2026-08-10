# Up/down counter with load

**Difficulty:** ⭐⭐⭐ · **Topics:** counters, priority of load/enable

## Background
A counter is a register that adds (or subtracts) 1 each enabled cycle. Real
counters have several controls, and the key skill is expressing their **priority**
with an `if / else if` chain — the first true branch wins:
1. `load` beats everything (jam in `load_val`),
2. then `en` (count up or down),
3. otherwise hold.

## The task
`W`-bit up/down counter with synchronous load and async active-low reset.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`, `rst_n` | input | 1 | clock / async reset |
| `load`     | input  | 1 | synchronous load |
| `load_val` | input  | W | value to load |
| `en`       | input  | 1 | count enable |
| `up_down`  | input  | 1 | 1=up, 0=down |
| `count`    | output | W | counter value |

**Parameter:** `W` (default 8)

## How to approach it
```systemverilog
always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)    count <= '0;
    else if (load) count <= load_val;
    else if (en)   count <= up_down ? count + 1'b1 : count - 1'b1;
```

## Common mistakes
- Wrong priority order (checking `en` before `load`).
- Expecting an "else" hold to be written explicitly — the missing final else is
  the hold.

## SystemVerilog notes
The counter naturally wraps modulo `2^W` (all-ones + 1 = 0). Add a compare if you
need it to saturate or reload at a terminal count.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0025/tb.sv 0025/solution.sv && vvp sim
```
