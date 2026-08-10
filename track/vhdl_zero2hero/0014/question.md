# 2-to-4 Decoder (with enable)

**Difficulty:** ⭐⭐ · **Topics:** one-hot, `to_integer`

## Background
A **decoder** turns an N-bit code into a **one-hot** output — exactly one line
high. An **enable** gates it off entirely. Indexing a vector by an integer
(`y(to_integer(unsigned(code)))`) is a compact way to set the selected bit.

## The task
When `en='1'`, assert the `y` bit chosen by `code`; else all zero. (`in` is
reserved, so the code is named `code`.)

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `code` | in  | std_logic_vector(1 downto 0) | binary code |
| `en`   | in  | std_logic | enable |
| `y`    | out | std_logic_vector(3 downto 0) | one-hot |

## How to approach it
```vhdl
process(all)
begin
    y <= (others => '0');
    if en = '1' then
        y(to_integer(unsigned(code))) <= '1';
    end if;
end process;
```

## Common mistakes
- Not clearing `y` first (leaves a latch / stale bits).
- Forgetting `use ieee.numeric_std.all;` for `unsigned`/`to_integer`.

## VHDL notes
`numeric_std` provides the numeric interpretations of vectors; converting through
`unsigned` then `to_integer` is the standard idiom for a dynamic index.

## Run it (GHDL)
```bash
ghdl -a --std=08 0014/solution.vhdl 0014/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
