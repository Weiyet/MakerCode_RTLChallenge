# Shift register (SIPO)

**Difficulty:** ⭐⭐ · **Topics:** shifting, serial-in parallel-out

## Background
A **shift register** moves its bits along by one each clock. A serial-in
parallel-out (SIPO) shifter collects a serial bit stream into a parallel word — the
receiver half of any serial link. Each clock: drop the top bit, shift everyone up,
and drop the new `sin` into the LSB, i.e. `q <= {q[W-2:0], sin}`.

## The task
Shift left, inserting `sin` at the LSB; async active-low reset clears `q`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`, `rst_n` | input | 1 | clock / async reset |
| `sin` | input  | 1 | serial input |
| `q`   | output | W | parallel output |

**Parameter:** `W` (default 8)

```wavedrom
{ "signal": [
  {"name":"clk","wave":"p....."},
  {"name":"sin","wave":"01.0.1"},
  {"name":"q[0]","wave":"0.1.0."}
]}
```

## How to approach it
```systemverilog
always_ff @(posedge clk or negedge rst_n)
    if (!rst_n) q <= '0;
    else        q <= {q[W-2:0], sin};
```

## Common mistakes
- Shifting the wrong direction — `{q[W-2:0], sin}` shifts toward the MSB and
  inserts at the LSB. `{sin, q[W-1:1]}` would be the opposite.

## SystemVerilog notes
Adding a parallel-load input turns this into a PISO/universal shift register — a
small extension of the same pattern.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0024/tb.sv 0024/solution.sv && vvp sim
```
