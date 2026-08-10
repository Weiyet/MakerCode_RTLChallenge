# Enabled register (load enable)

**Difficulty:** ⭐⭐ · **Topics:** clock enable, hold

## Background
A register that updates only on some cycles uses a **clock enable**: load `d` when
`en='1'`, otherwise hold. The "hold" is free — simply have no `else` on the enable.

## The task
`W`-bit register with async active-low reset and a load enable.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / async reset |
| `en` | in  | std_logic | load enable |
| `d`  | in  | std_logic_vector(W-1 downto 0) | data |
| `q`  | out | std_logic_vector(W-1 downto 0) | stored value |

**Generic:** `W` (default 8)

## How to approach it
```vhdl
process(clk, rst_n)
begin
    if rst_n = '0' then
        q <= (others => '0');
    elsif rising_edge(clk) then
        if en = '1' then q <= d; end if;   -- no else -> holds
    end if;
end process;
```

## Common mistakes
- Adding `else q <= q;` (redundant — omitting it already means hold).
- Resetting with `q <= '0'` (a scalar) instead of the aggregate
  `(others => '0')` for a vector.

## Run it (GHDL)
```bash
ghdl -a --std=08 0023/solution.vhdl 0023/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
