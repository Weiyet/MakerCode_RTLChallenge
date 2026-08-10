# Concatenation & replication

**Difficulty:** ⭐⭐ · **Topics:** `&` concatenation

## Learning objective
Build wider vectors from smaller pieces.

## Problem
Given bytes `a` and `b`:
- `cat`      = `a & b` (16 bits, `a` in the MSBs)
- `rep4`     = four copies of `a` (32 bits)
- `nib_swap` = `a` with its two nibbles swapped

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b`   | in  | std_logic_vector(7 downto 0)  | operands |
| `cat`      | out | std_logic_vector(15 downto 0) | `a & b` |
| `rep4`     | out | std_logic_vector(31 downto 0) | 4 copies of `a` |
| `nib_swap` | out | std_logic_vector(7 downto 0)  | nibble swap |

## VHDL notes
`&` is the concatenation operator. VHDL has no `{N{x}}` replication syntax — write
the copies out, or use an aggregate.
