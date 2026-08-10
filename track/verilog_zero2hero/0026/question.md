# LFSR (pseudo-random)

**Difficulty:** ⭐⭐⭐ · **Topics:** feedback shift register, XOR taps

## Learning objective
Build a maximal-length 8-bit Linear-Feedback Shift Register — a compact
pseudo-random generator.

## Problem
8-bit Fibonacci LFSR using taps 8,6,5,4 (polynomial x^8 + x^6 + x^5 + x^4 + 1):
`feedback = q[7] ^ q[5] ^ q[4] ^ q[3]`, then shift left inserting `feedback`.
Async active-low reset seeds the register to `8'hFF`. Advance only when `en=1`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`   | input  | 1 | clock |
| `rst_n` | input  | 1 | async active-low reset (seed = FF) |
| `en`    | input  | 1 | advance enable |
| `q`     | output | 8 | LFSR state |

## Hints
- `feedback = ^(q & 8'b1011_1000)` also works (same tap set).
- Seeding with a non-zero value is essential — all-zero is a lock-up state.
