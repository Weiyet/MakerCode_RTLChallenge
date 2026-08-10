# Sequential logic (shift register)

**Difficulty:** ⭐⭐ · **Topics:** shifting, `&`

## Background
A **shift register** moves its bits along each clock. Serial-in parallel-out
collects a serial stream into a word — the receiver half of a serial link. Each
clock: `q <= q(W-2 downto 0) & sin` drops the MSB, shifts up, and inserts `sin` at
the LSB.

## The task
Shift left, inserting `sin` at the LSB; async active-low reset clears `q`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / async reset |
| `sin` | in  | std_logic | serial input |
| `q`   | out | std_logic_vector(W-1 downto 0) | parallel output |

**Generic:** `W` (default 8)

## How to approach it
```vhdl
process(clk, rst_n)
begin
    if rst_n = '0' then
        q_i <= (others => '0');
    elsif rising_edge(clk) then
        q_i <= q_i(W-2 downto 0) & sin;
    end if;
end process;
q <= q_i;
```
(An internal `q_i` is used because an `out` port cannot be read back.)

## Common mistakes
- Reading the `out` port `q` directly — keep an internal signal and drive `q` from
  it.
- Shifting the wrong direction.
