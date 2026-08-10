# Switch debouncer

**Difficulty:** ⭐⭐⭐⭐ · **Topics:** counter + FSM, glitch rejection

## Learning objective
Filter a bouncing mechanical input: only accept a new level after it has been
stable for `STABLE` consecutive clocks.

## Problem
Track `noisy`. When it differs from the current `clean` output, count matching
clocks; once it has stayed different for `STABLE` cycles, update `clean`. Any
change resets the counter. Async active-low reset clears `clean` to 0.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`, `rst_n` | input | 1 | clock / reset |
| `noisy` | input  | 1 | raw (bouncy) input |
| `clean` | output | 1 | debounced output |

**Parameter:** `STABLE` (default 4)

## Hints
- Compare `noisy != clean`; count up while different, clear the count when equal.
- When the count reaches `STABLE-1`, latch `clean <= noisy`.
