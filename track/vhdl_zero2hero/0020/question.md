# Gray / binary codec (functions)

**Difficulty:** ⭐⭐⭐ · **Topics:** `function`, reuse

## Learning objective
Factor combinational math into `function`s and call them from concurrent
assignments.

## Problem
- `gray`    = binary-to-Gray of `bin`   (`g = b xor (b >> 1)`)
- `bin_out` = Gray-to-binary of `gray_in`

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `bin`     | in  | std_logic_vector(W-1 downto 0) | binary in |
| `gray_in` | in  | std_logic_vector(W-1 downto 0) | Gray in |
| `gray`    | out | std_logic_vector(W-1 downto 0) | Gray of `bin` |
| `bin_out` | out | std_logic_vector(W-1 downto 0) | binary of `gray_in` |

**Generic:** `W` (default 4)

## VHDL notes
Declare functions in the architecture's declarative region. A right shift by one
is just `'0' & b(b'high downto 1)`.
