# Writing a testbench (stimulus with a procedure)

**Difficulty:** ⭐⭐⭐⭐ · **Topics:** `procedure`, driving transactions, reuse

> Simulation-only verification work — you are writing the testbench, not a design.

## Background
When a testbench sends many similar stimuli, wrap the steps in a **`procedure`**
and call it repeatedly. A procedure may contain `wait`, so it is ideal for a
"drive one transaction" routine — the VHDL counterpart of a Verilog testbench
`task`.

## The task
An accumulator DUT is **provided in `tb.vhdl`** and **instantiated as `dut`** in
`tb_top` (`clk`, `rst_n`, `valid`, `din(7:0)`, `sum(15:0)`). It adds `din` to
`sum` on each clock where `valid = '1'`.

In `tb_top`: model the clock, apply reset, then write a **`procedure`**
`send(b)` that drives one accumulate transaction (present `din`, pulse `valid`
for exactly one clock, then drop it), and send these four values in order:
**10, 20, 30, 40**. The accumulator must end at **100** after exactly **4**
transactions.

```vhdl
entity acc_dut port (clk, rst_n, valid : in std_logic;
                     din  : in  std_logic_vector(7 downto 0);
                     sum  : out std_logic_vector(15 downto 0));
```

> **Do not call `std.env.finish`** in `tb_top` — the harness owns the end.

## How to approach it
```vhdl
process
  procedure send(constant b : in std_logic_vector(7 downto 0)) is
  begin
    wait until falling_edge(clk);
    din <= b; valid <= '1';
    wait until falling_edge(clk);
    valid <= '0';
  end procedure;
begin
  rst_n <= '0'; valid <= '0'; din <= (others => '0');
  wait for 12 ns; rst_n <= '1';
  send(x"0A"); send(x"14"); send(x"1E"); send(x"28");   -- 10,20,30,40
  wait;
end process;
```

## Common mistakes
- Holding `valid = '1'` across several clocks — the DUT then adds every cycle and
  the sum / transaction count are wrong. Pulse it for exactly one clock.
- Sending the wrong values or count — the checker verifies both.
