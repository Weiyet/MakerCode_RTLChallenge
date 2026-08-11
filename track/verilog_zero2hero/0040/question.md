# Writing a testbench (clock & reset)

**Difficulty:** ⭐⭐⭐ · **Topics:** `initial`, clock modelling, reset stimulus

> This module flips the usual exercise: instead of writing a *design*, you write a
> **testbench** — the code that drives a design and makes it do something. This is
> simulation-only verification work, and a core RTL skill.

## Background
A testbench provides the things a real system would: a **clock**, a **reset**
sequence, and **stimulus** on the inputs. The essentials:

- **Clock modelling** — a free-running clock: `always #5 clk = ~clk;` (after
  initialising `clk = 0`). One full period is 10 ns here.
- **`initial` block** — runs once at time 0; the natural place for a reset-then-
  drive sequence, using `#delay` to advance time.
- **Reset sequence** — assert reset, hold it a few cycles, then release it.

## The task
A counter DUT is **provided in `tb.sv`** and already **instantiated for you** as
`dut` inside `tb_top` (with signals `clk`, `rst_n` active-low, `en`, `count`).
Your job in `tb_top` is to **model the clock** and write an **`initial`** block
that: holds `rst_n = 0` (with `en = 0`) briefly, releases `rst_n = 1`, then asserts
`en = 1` so the counter starts counting.

```verilog
module counter_dut (input clk, input rst_n, input en, output [7:0] count);
  // counts up while en=1; async active-low reset
```

> **Do not call `$finish`** in `tb_top` — the grading harness owns simulation end.

## How to approach it
```systemverilog
initial clk = 1'b0;
always #5 clk = ~clk;          // 10 ns clock

initial begin
    rst_n = 1'b0; en = 1'b0;   // hold in reset
    #12 rst_n = 1'b1;          // release reset
    #10 en    = 1'b1;          // start counting
end
```

## Common mistakes
- Forgetting to initialise `clk` (it stays `x` and never toggles).
- Never releasing reset, or never asserting `en` — the counter stays at 0 and the
  check "DUT never counted" fires.
- Calling `$finish` yourself — let the harness end the run.
