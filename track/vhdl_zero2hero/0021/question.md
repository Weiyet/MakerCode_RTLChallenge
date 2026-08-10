# D flip-flop

**Difficulty:** ⭐⭐ · **Topics:** clocked `process`, `rising_edge`

## Background
Combinational logic follows its inputs instantly; a **flip-flop** adds memory — it
samples `d` on the rising clock edge and holds it. This is the atom of sequential
logic. In VHDL you write it as a `process(clk)` guarded by `rising_edge(clk)`,
using signal assignment `<=`.

## The task
On each rising edge of `clk`, `q` takes `d`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk` | in  | std_logic | clock |
| `d`   | in  | std_logic | data |
| `q`   | out | std_logic | registered data |

```wavedrom
{ "signal": [
  {"name":"clk","wave":"p......"},
  {"name":"d",  "wave":"0.1..0."},
  {"name":"q",  "wave":"0..1..0"}
]}
```

## How to approach it
```vhdl
process(clk)
begin
    if rising_edge(clk) then
        q <= d;
    end if;
end process;
```

## Common mistakes
- Assigning outside the `if rising_edge(clk)` guard (creates a latch or a wire).
- Using `:=` on a signal — flops use `<=`.

## VHDL notes
`rising_edge`/`falling_edge` (from `std_logic_1164`) are the idiomatic edge tests,
safer than `clk'event and clk='1'`.

## Run it (GHDL)
```bash
ghdl -a --std=08 0021/solution.vhdl 0021/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
