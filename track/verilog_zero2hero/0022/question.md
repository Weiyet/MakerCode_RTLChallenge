# Reset styles: synchronous vs asynchronous

**Difficulty:** ⭐⭐⭐ · **Topics:** reset, sensitivity lists

## Background
Registers need a known starting value — that is what **reset** provides. There are
two styles, differing in *when* the reset takes effect:
- **Synchronous**: reset is only examined on a clock edge. Sensitivity list is
  just `@(posedge clk)`.
- **Asynchronous**: reset acts the instant it asserts, no clock needed. The reset
  appears in the sensitivity list: `@(posedge clk or negedge rst_n)`.

`rst_n` is *active-low* (the trailing `_n`): the circuit is in reset when it is 0.

## The task
Produce two registered copies of `d`: `q_sync` (sync reset) and `q_async` (async
reset).

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`, `rst_n` | input | 1 | clock / active-low reset |
| `d`       | input  | 1 | data |
| `q_sync`  | output | 1 | sync-reset register |
| `q_async` | output | 1 | async-reset register |

## How to approach it
```systemverilog
always_ff @(posedge clk)                      // sync
    if (!rst_n) q_sync <= 1'b0; else q_sync <= d;

always_ff @(posedge clk or negedge rst_n)     // async
    if (!rst_n) q_async <= 1'b0; else q_async <= d;
```

## Common mistakes
- Putting the reset in the sensitivity list for a *sync* reset (or leaving it out
  for an *async* one) — the style is defined by that list.
- Mixed active levels: `!rst_n` because it is active-low.

## SystemVerilog notes
Pick one reset style per project. Async-assert / sync-deassert is common in real
chips, but the two pure styles here show the essential difference.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0022/tb.sv 0022/solution.sv && vvp sim
```
