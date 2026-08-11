# Writing a testbench (stimulus with a task)

**Difficulty:** ⭐⭐⭐⭐ · **Topics:** `task`, driving transactions, reuse

> Simulation-only verification work — you are writing the testbench, not a design.

## Background
When a testbench sends many similar stimuli, wrap the steps in a **`task`** and
call it repeatedly. A task can consume time (`@(posedge clk)`), so it is perfect
for "drive one transaction" routines. This keeps stimulus readable and reusable —
exactly how real testbenches are built.

## The task
An accumulator DUT is **provided in `tb.sv`** and **instantiated as `dut`** in
`tb_top` (`clk`, `rst_n`, `valid`, `din[7:0]`, `sum[15:0]`). It adds `din` to
`sum` on each clock where `valid = 1`.

In `tb_top`: model the clock, apply reset, then write a **`task`** `send(byte)`
that drives one accumulate transaction (present `din`, pulse `valid` for exactly
one clock, then drop it), and use it to send these four values in order:
**10, 20, 30, 40**. The accumulator must end at **100** after exactly **4**
transactions.

```verilog
module acc_dut (input clk, input rst_n, input valid, input [7:0] din, output [15:0] sum);
  // sum <= sum + din  when valid=1 (async active-low reset)
```

> **Do not call `$finish`** in `tb_top` — the harness owns simulation end.

## How to approach it
```systemverilog
task automatic send(input logic [7:0] b);
    begin
        @(negedge clk);
        din = b; valid = 1'b1;
        @(negedge clk);
        valid = 1'b0;
    end
endtask

initial begin
    rst_n = 0; valid = 0; din = 0;
    #12 rst_n = 1;
    send(8'd10); send(8'd20); send(8'd30); send(8'd40);
end
```

## Common mistakes
- Holding `valid` high across several clocks — the DUT then adds `din` every cycle
  and the sum/transaction count are wrong. Pulse it for exactly one clock.
- Sending the wrong values or the wrong count — the checker verifies both.
