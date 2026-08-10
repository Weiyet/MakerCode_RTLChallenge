# LFSR (pseudo-random)

**Difficulty:** ⭐⭐⭐ · **Topics:** feedback shift register, XOR taps

## Problem
8-bit Fibonacci LFSR, taps 8,6,5,4 (`x^8+x^6+x^5+x^4+1`):
`fb = q(7) xor q(5) xor q(4) xor q(3)`, then shift left inserting `fb`. Async
active-low reset seeds the register to `x"FF"`. Advance only when `en='1'`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / async reset (seed FF) |
| `en` | in  | std_logic | advance enable |
| `q`  | out | std_logic_vector(7 downto 0) | LFSR state |

## VHDL notes
Seeding with a non-zero value is essential — an all-zero LFSR is stuck forever.
