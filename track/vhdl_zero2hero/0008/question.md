# Vector reverse

**Difficulty:** ⭐⭐ · **Topics:** `process`, `for` loop

## Background
Some wiring is tedious to write bit-by-bit; a `for` loop inside a combinational
**`process`** describes it compactly. The loop is **unrolled** at elaboration —
it is not a runtime loop, just shorthand for repetitive connections. Reversing a
vector (`y(i) <= d(7-i)`) is the classic example.

## The task
Reverse the bit order of an 8-bit vector.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d` | in  | std_logic_vector(7 downto 0) | data |
| `y` | out | std_logic_vector(7 downto 0) | bit-reversed |

## How to approach it
```vhdl
process(d)
begin
    for i in 0 to 7 loop
        y(i) <= d(7 - i);
    end loop;
end process;
```

## Common mistakes
- Incomplete sensitivity list — list every signal read (or use `process(all)` in
  VHDL-2008) so simulation matches synthesis.
- Off-by-one in `d(7-i)`.

## VHDL notes
`process(all)` (VHDL-2008) builds the sensitivity list automatically, avoiding a
common source of sim/synth mismatch.

## Run it (GHDL)
```bash
# from track/vhdl_zero2hero/
ghdl -a --std=08 0008/solution.vhdl 0008/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
A correct run prints `Test PASS`. Swap `solution.vhdl` for `interface.vhdl` to test
your own answer.
