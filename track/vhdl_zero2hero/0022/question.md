# Reset styles: synchronous vs asynchronous

**Difficulty:** ⭐⭐⭐ · **Topics:** reset, sensitivity lists

## Background
Registers need a defined start value from **reset**. Two styles differ in *when*
reset acts:
- **Synchronous**: reset only checked at a clock edge; process is sensitive to
  `clk` only.
- **Asynchronous**: reset acts immediately; process is sensitive to `clk` **and**
  `rst_n`, and the reset is tested *before* `rising_edge`.

`rst_n` is active-low (`_n`): reset when 0.

## The task
Produce `q_sync` (sync reset) and `q_async` (async reset) copies of `d`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / active-low reset |
| `d`       | in  | std_logic | data |
| `q_sync`  | out | std_logic | sync-reset register |
| `q_async` | out | std_logic | async-reset register |

## How to approach it
```vhdl
process(clk)                       -- synchronous
begin
    if rising_edge(clk) then
        if rst_n = '0' then q_sync <= '0'; else q_sync <= d; end if;
    end if;
end process;

process(clk, rst_n)                -- asynchronous
begin
    if rst_n = '0' then q_async <= '0';
    elsif rising_edge(clk) then q_async <= d;
    end if;
end process;
```

## Common mistakes
- Wrong sensitivity list for the chosen style.
- Testing `rising_edge` *before* the async reset — the reset check must come first.

## VHDL notes
Choose one reset style per project. The two pure forms here isolate the essential
difference.

## Run it (GHDL)
```bash
ghdl -a --std=08 0022/solution.vhdl 0022/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
