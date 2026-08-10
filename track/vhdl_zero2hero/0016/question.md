# Parameters (generic population count)

**Difficulty:** ⭐⭐⭐ · **Topics:** `generic`, `math_real` sizing, loop accumulate

## Background
"Popcount" = number of set bits. Counting `WIDTH` bits gives 0..WIDTH, needing
`ceil(log2(WIDTH+1))` output bits. VHDL has no `$clog2`, so size the port with
`integer(ceil(log2(real(WIDTH+1))))` from `ieee.math_real`. Inside, accumulate
into an `integer` and convert back.

## The task
Return the number of 1s in a `WIDTH`-bit input.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d`     | in  | std_logic_vector(WIDTH-1 downto 0) | data |
| `count` | out | std_logic_vector(ceil(log2(WIDTH+1))-1 downto 0) | number of 1s |

**Generic:** `WIDTH` (default 8)

## How to approach it
```vhdl
process(all)
    variable c : integer;
begin
    c := 0;
    for i in d'range loop
        if d(i) = '1' then c := c + 1; end if;
    end loop;
    count <= std_logic_vector(to_unsigned(c, count'length));
end process;
```

## Common mistakes
- Under-sizing `count` (miss the all-ones = WIDTH case).
- Forgetting `use ieee.math_real.all;` for `ceil`/`log2`.

## VHDL notes
`count'length` gives the port width, so `to_unsigned(c, count'length)` always
matches — no magic numbers.
