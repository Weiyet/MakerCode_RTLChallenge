# Ripple-carry adder (for-generate)

**Difficulty:** ⭐⭐⭐ · **Topics:** `generic`, `for ... generate`, carry chain

## Learning objective
Build a parameterized adder with a `for ... generate` that instantiates one
full-adder stage per bit.

## Problem
Add two `WIDTH`-bit numbers plus `cin`, giving a `WIDTH`-bit `sum` and `cout`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b` | in  | std_logic_vector(WIDTH-1 downto 0) | operands |
| `cin`    | in  | std_logic | carry in |
| `sum`    | out | std_logic_vector(WIDTH-1 downto 0) | result |
| `cout`   | out | std_logic | carry out |

**Generic:** `WIDTH` (default 4)

## VHDL notes
`for i in 0 to WIDTH-1 generate ... end generate;` elaborates structure. Use an
internal `carry` vector of length `WIDTH+1` to chain the stages.
