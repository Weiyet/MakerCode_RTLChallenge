# Up/down counter with load

**Difficulty:** ⭐⭐⭐ · **Topics:** counters, priority

## Background
A counter adds/subtracts 1 each enabled cycle. Real ones have several controls; the
skill is expressing **priority** with an `if / elsif` chain: `load` beats `en`,
`en` beats hold. Keep the count as `unsigned` for `+1`/`-1`.

## The task
`W`-bit up/down counter with synchronous load and async active-low reset.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / async reset |
| `load`     | in  | std_logic | synchronous load |
| `load_val` | in  | std_logic_vector(W-1 downto 0) | value to load |
| `en`       | in  | std_logic | count enable |
| `up_down`  | in  | std_logic | 1=up, 0=down |
| `count`    | out | std_logic_vector(W-1 downto 0) | counter |

**Generic:** `W` (default 8)

## How to approach it
```vhdl
process(clk, rst_n)
begin
    if rst_n = '0' then cnt <= (others => '0');
    elsif rising_edge(clk) then
        if    load = '1' then cnt <= unsigned(load_val);
        elsif en   = '1' then
            if up_down = '1' then cnt <= cnt + 1; else cnt <= cnt - 1; end if;
        end if;
    end if;
end process;
count <= std_logic_vector(cnt);
```

## Common mistakes
- Wrong priority order (checking `en` before `load`).
- Doing arithmetic on `std_logic_vector` — use an `unsigned` `cnt`.

## VHDL notes
`unsigned` wraps modulo `2^W` automatically. Add a compare if you want saturation
or a terminal-count reload.

## Run it (GHDL)
```bash
ghdl -a --std=08 0025/solution.vhdl 0025/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
