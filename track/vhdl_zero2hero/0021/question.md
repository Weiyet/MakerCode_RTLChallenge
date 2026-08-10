# Sequential logic (signal vs variable)

**Difficulty:** ⭐⭐⭐ · **Topics:** `<=` signals vs `:=` variables, scheduling

## Background
VHDL has two kinds of assignment, and the difference is exactly the VHDL version
of "blocking vs non-blocking":

- **Signal `<=`** — the update is *scheduled* and takes effect at the end of the
  process step. Reads elsewhere in the same step see the **old** value. This is
  what registers/shift chains want.
- **Variable `:=`** — updates **immediately**; the next line sees the new value.

Build a shift chain with **signals** and each stage sees its neighbour's *old*
value, so data delays one stage per clock. Build it with variables and the chain
collapses (every stage equals the input).

## The task
Build `shift3`, a 3-stage shift register: each clock, stage 0 takes `din`, stage 1
takes the old stage 0, stage 2 the old stage 1. Use **signal** assignments.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk` | in  | std_logic | clock |
| `din` | in  | std_logic | serial in |
| `q`   | out | std_logic_vector(2:0) | `q(k)` = din delayed k+1 cycles |

## How to approach it
```vhdl
signal r : std_logic_vector(2 downto 0) := "000";
...
process(clk) begin
  if rising_edge(clk) then
    r(0) <= din;
    r(1) <= r(0);   -- sees OLD r(0): signal semantics
    r(2) <= r(1);
  end if;
end process;
q <= r;
```

## Common mistakes
- Using a **variable** with `:=` for the chain — each line sees the new value, so
  all three stages become `din` and the staggered-delay test fails.
