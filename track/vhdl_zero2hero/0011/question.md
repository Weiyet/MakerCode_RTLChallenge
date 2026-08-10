# Combinational logic (priority encoder)

**Difficulty:** ⭐⭐⭐ · **Topics:** priority via `if/elsif`

## Background
A **priority encoder** reports the highest-priority active input when several are
active at once — here the highest set bit — plus a `valid` flag for "none set". In
VHDL the natural expression is a chained `if / elsif`: the first true branch wins,
so listing the MSB first gives it priority.

## The task
Report the index of the highest set bit of `d`; `valid='0'` if none set. (Input is
named `d`.)

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d`     | in  | std_logic_vector(3 downto 0) | request bits |
| `pos`   | out | std_logic_vector(1 downto 0) | index of highest set bit |
| `valid` | out | std_logic | any bit set |

## Behaviour
| d    | valid | pos |
|------|-------|-----|
| 1xxx | 1 | 3 |
| 01xx | 1 | 2 |
| 001x | 1 | 1 |
| 0001 | 1 | 0 |
| 0000 | 0 | 0 |

## How to approach it
```vhdl
process(all)
begin
    valid <= '1';
    if    d(3) = '1' then pos <= "11";
    elsif d(2) = '1' then pos <= "10";
    elsif d(1) = '1' then pos <= "01";
    elsif d(0) = '1' then pos <= "00";
    else  pos <= "00"; valid <= '0';
    end if;
end process;
```

## Common mistakes
- Listing bits low-to-high (that would give lowest-bit priority).
- Forgetting the final `else` to set `valid='0'`.

## VHDL notes
`if/elsif` inherently encodes priority — no wildcard `casez` needed (VHDL has
`std_match` for don't-care matching if you ever want it).
