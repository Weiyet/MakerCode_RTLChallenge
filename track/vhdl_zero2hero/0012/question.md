# Combinational logic (avoiding inferred latches)

**Difficulty:** ⭐⭐⭐ · **Topics:** combinational process, complete assignment, latches

## Background
In a combinational `process(all)`, **every output must be assigned on every
path**. If a branch leaves an output unassigned, the tool infers a **latch** to
hold the old value — almost always a bug. The fix is a **default assignment** at
the top of the process.

The checker detects the latch: with an unassigned path the output keeps its
previous value, which the testbench catches.

## The task
Build `sel_mux`: `y = a` when `sel="00"`, `b` when `"01"`, `c` when `"10"`, and a
defined **all-zeros** when `sel="11"`. Use a **default assignment** so no latch is
inferred.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `sel`     | in  | std_logic_vector(1:0) | selector |
| `a`,`b`,`c` | in | std_logic_vector(7:0) | data |
| `y`       | out | std_logic_vector(7:0) | selected, 0 when sel="11" |

## How to approach it
```vhdl
process(all) begin
  y <= (others => '0');            -- default => no latch, defines sel="11"
  case sel is
    when "00" => y <= a;
    when "01" => y <= b;
    when "10" => y <= c;
    when others => null;           -- default already covers this
  end case;
end process;
```

## Common mistakes
- Dropping the default *and* using `when others => null` — then `sel="11"` latches
  the old `y`, and the test fails.
