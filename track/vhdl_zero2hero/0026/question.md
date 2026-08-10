# LFSR (pseudo-random)

**Difficulty:** ⭐⭐⭐ · **Topics:** feedback shift register, XOR taps

## Background
A **Linear-Feedback Shift Register** feeds back the XOR of chosen bits (**taps**)
as its serial input. With the right taps it visits all `2^N-1` non-zero states — a
cheap pseudo-random generator. This 8-bit LFSR uses taps 8,6,5,4
(`x^8 + x^6 + x^5 + x^4 + 1`).

## The task
`fb = q(7) xor q(5) xor q(4) xor q(3)`, then shift left inserting `fb`. Seed to
`x"FF"` on reset; advance only when `en='1'`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / async reset (seed FF) |
| `en`  | in  | std_logic | advance enable |
| `q`   | out | std_logic_vector(7 downto 0) | LFSR state |

## How to approach it
```vhdl
fb <= q_i(7) xor q_i(5) xor q_i(4) xor q_i(3);
process(clk, rst_n)
begin
    if rst_n = '0' then q_i <= x"FF";
    elsif rising_edge(clk) then
        if en = '1' then q_i <= q_i(6 downto 0) & fb; end if;
    end if;
end process;
q <= q_i;
```

## Common mistakes
- Seeding to 0 — all-zero is a lock-up state.
- Wrong tap set (only specific taps give the maximal-length sequence).

## Run it (GHDL)
```bash
ghdl -a --std=08 0026/solution.vhdl 0026/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
