# Edge detector (one-pulse)

**Difficulty:** ⭐⭐⭐ · **Topics:** registering history, one-cycle pulse

## Background
To react to a *change* rather than a level, compare a signal with its value one
clock ago. Store the previous value in a flip-flop: a rising edge is "now 1 AND
was 0", a falling edge is "now 0 AND was 1". The result is a clean one-cycle pulse
per edge.

## The task
Register `sig` into `prev`; output registered `rise`/`fall` pulses. Async
active-low reset.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / reset |
| `sig`  | in  | std_logic | monitored signal |
| `rise` | out | std_logic | rising-edge pulse |
| `fall` | out | std_logic | falling-edge pulse |

```wavedrom
{ "signal": [
  {"name":"clk","wave":"p......"},
  {"name":"sig","wave":"0.1..0."},
  {"name":"rise","wave":"0..10.."},
  {"name":"fall","wave":"0....10"}
]}
```

## How to approach it
```vhdl
process(clk, rst_n)
begin
    if rst_n = '0' then
        prev <= '0'; rise <= '0'; fall <= '0';
    elsif rising_edge(clk) then
        prev <= sig;
        rise <= sig and (not prev);
        fall <= (not sig) and prev;
    end if;
end process;
```

## Common mistakes
- Forgetting the registered `prev` (comparing `sig` to itself).
- A pulse wider than one cycle means `prev` is not updating each clock.

## Run it (GHDL)
```bash
ghdl -a --std=08 0027/solution.vhdl 0027/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
