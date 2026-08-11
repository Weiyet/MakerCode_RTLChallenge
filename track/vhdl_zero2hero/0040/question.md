# Writing a testbench (clock & reset)

**Difficulty:** ⭐⭐⭐ · **Topics:** clock process, `wait`, reset stimulus

> This module flips the usual exercise: instead of writing a *design*, you write a
> **testbench** — the code that drives a design. Simulation-only verification work,
> and a core RTL skill.

## Background
A testbench supplies what a real system would: a **clock**, a **reset** sequence,
and **stimulus**. In VHDL:

- **Clock modelling** — a concurrent assignment `clk <= not clk after 5 ns;`
  (a 10 ns period).
- **Stimulus process** — a `process` with `wait for`/`wait until` that drives the
  reset and inputs over time, ending in a bare `wait;` so it runs once.

## The task
A counter DUT is **provided in `tb.vhdl`** and already **instantiated for you** as
`dut` in `tb_top` (signals `clk`, `rst_n` active-low, `en`, `count`). In `tb_top`,
**model the clock** and write a **stimulus process** that holds `rst_n = '0'` (with
`en = '0'`), releases `rst_n = '1'`, then asserts `en = '1'` so it counts.

```vhdl
entity counter_dut port (clk, rst_n, en : in std_logic;
                         count : out std_logic_vector(7 downto 0));
```

> **Do not call `std.env.finish`** in `tb_top` — the grading harness owns the end.

## How to approach it
```vhdl
clk <= not clk after 5 ns;

process begin
  rst_n <= '0'; en <= '0';
  wait for 12 ns; rst_n <= '1';
  wait for 10 ns; en    <= '1';
  wait;                          -- run once
end process;
```

## Common mistakes
- Never releasing reset, or never asserting `en` — the counter stays 0 and the
  "DUT never counted" check fires.
- Calling `finish` yourself — let the harness end the run.
