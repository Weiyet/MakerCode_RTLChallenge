# Switch debouncer

**Difficulty:** ⭐⭐⭐⭐ · **Topics:** counter + condition, glitch rejection

## Background
A mechanical switch bounces for a few milliseconds before settling. A
**debouncer** accepts a new level only after `noisy` has stayed different from
`clean` for `STABLE` consecutive clocks; any match restarts the count. It is a
counter guarding a single output bit.

## The task
Update `clean` only after `STABLE` stable clocks; async active-low reset clears it.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / reset |
| `noisy` | in  | std_logic | raw input |
| `clean` | out | std_logic | debounced output |

**Generic:** `STABLE` (default 4)

## How to approach it
```vhdl
process(clk, rst_n)
begin
    if rst_n = '0' then clean_i <= '0'; cnt <= 0;
    elsif rising_edge(clk) then
        if noisy /= clean_i then
            if cnt = STABLE-1 then clean_i <= noisy; cnt <= 0;
            else cnt <= cnt + 1; end if;
        else
            cnt <= 0;             -- input matches output -> reset timer
        end if;
    end if;
end process;
clean <= clean_i;
```

## Common mistakes
- Not clearing the counter when input matches output (bounces would accumulate).
- Off-by-one on the threshold (`STABLE` vs `STABLE-1`).

## VHDL notes
Real designs size `STABLE` for milliseconds at the true clock rate; a small value
keeps this exercise quick.

## Run it (GHDL)
```bash
ghdl -a --std=08 0030/solution.vhdl 0030/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
