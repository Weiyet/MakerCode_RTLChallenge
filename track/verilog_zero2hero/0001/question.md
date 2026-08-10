# Constants

**Difficulty:** ⭐ · **Topics:** literals, constant drivers

## Background
Sometimes an output must be tied to a fixed value — a `0` or a `1` — regardless
of any input. In hardware this is just a connection to ground (`0`) or to the
supply rail (`1`). In SystemVerilog you express a fixed value with a **literal**
and drive it onto a port with a continuous `assign`.

Literals carry a size and a base: `1'b0` means "1 bit, binary, value 0". The
number before the apostrophe is the width; the letter after it is the base
(`b` binary, `d` decimal, `h` hex).

## The task
Build `constants` with two outputs: `zero` always `0`, `one` always `1`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `zero` | output | 1 | always `0` |
| `one`  | output | 1 | always `1` |

## How to approach it
Two continuous assignments, one per output:
```systemverilog
assign zero = 1'b0;
assign one  = 1'b1;
```

## Common mistakes
- Forgetting the width/base and writing `assign one = 1;` — this works (it is an
  unsized decimal `1`) but sized literals like `1'b1` state your intent clearly.
- Mixing up which output is which.

## SystemVerilog notes
For wide constants the unsized fills `'0` and `'1` are handy: `'0` sets *all*
bits of the target to 0 and `'1` sets all bits to 1, whatever the width. So a
32-bit clear is simply `assign bus = '0;`.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0001/tb.sv 0001/solution.sv && vvp sim
```
