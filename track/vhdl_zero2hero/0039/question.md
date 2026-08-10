# Concurrency (concurrent processes)

**Difficulty:** ⭐⭐⭐ · **Topics:** concurrent processes, `wait`, simulation time

## Background
Verilog reaches for `fork ... join` to run things in parallel. **VHDL doesn't
need it** — *every* process (and every concurrent signal assignment) in an
architecture already runs **concurrently**. Parallelism is the default; you get it
just by writing more than one process.

So the VHDL way to "launch three parallel branches" is simply to write **three
processes**. Each waits for a start edge, delays its own amount, then acts — all
three timing out independently, at the same time.

> **Simulation timing:** the `wait for` delays below are for a *testbench-style*
> demonstration of concurrency; unbounded `wait for N ns` is not synthesizable,
> but the concept — independent concurrent processes — is the heart of RTL.

## The task
Build `parallel_procs`. On a rising edge of `start`, three **separate concurrent
processes** must set `flag(0)` after 10 ns, `flag(1)` after 20 ns, and `flag(2)`
after 30 ns. Drive `done = '1'` once all three flags are set. Because the
processes run in parallel, `flag(1)` must be set at **+20 ns** (not +30) and
`done` at **+30 ns** (not +60).

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `start` | in  | std_logic | rising edge launches the branches |
| `flag`  | out | std_logic_vector(2:0) | `flag(k)` set by process k |
| `done`  | out | std_logic | `'1'` once all flags are set |

## How to approach it
```vhdl
architecture rtl of parallel_procs is
  signal f : std_logic_vector(2 downto 0) := "000";
begin
  p0 : process begin
    wait until rising_edge(start); wait for 10 ns; f(0) <= '1'; wait;
  end process;
  p1 : process begin
    wait until rising_edge(start); wait for 20 ns; f(1) <= '1'; wait;
  end process;
  p2 : process begin
    wait until rising_edge(start); wait for 30 ns; f(2) <= '1'; wait;
  end process;

  flag <= f;
  done <= '1' when f = "111" else '0';
end architecture rtl;
```
The final `wait;` parks each process forever after it fires (so it runs once).

## Common mistakes
- Putting all three delays in **one** process — they then run *sequentially*
  (`flag(1)` at +30, `done` at +60) and the test fails. Use separate processes.
- Forgetting the trailing `wait;`, so a process loops and re-fires.
