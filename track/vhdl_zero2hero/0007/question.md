# Concatenation & replication

**Difficulty:** ⭐⭐ · **Topics:** `&` concatenation

## Background
The `&` operator joins vectors into a wider one, most-significant part on the
left. VHDL has **no** `{N{x}}` replication shortcut, so you either write the copies
out (`a & a & a & a`) or use an aggregate. Rearranging and padding buses like this
is pure wiring — no gates.

## The task
From bytes `a`, `b` build `cat = a & b`, `rep4` = four copies of `a`, and
`nib_swap` = `a` with its nibbles swapped.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b`   | in  | std_logic_vector(7 downto 0)  | operands |
| `cat`      | out | std_logic_vector(15 downto 0) | `a & b` |
| `rep4`     | out | std_logic_vector(31 downto 0) | 4 copies of `a` |
| `nib_swap` | out | std_logic_vector(7 downto 0)  | nibble swap |

## How to approach it
```vhdl
cat      <= a & b;
rep4     <= a & a & a & a;
nib_swap <= a(3 downto 0) & a(7 downto 4);
```

## Common mistakes
- Order: the **leftmost** operand of `&` lands in the MSBs.
- Total width must equal the target width.

## VHDL notes
Concatenation composes for sign-extension too:
`( (7 downto 0 => v(7)) ) & v` extends an 8-bit `v` to 16 bits.

## Run it (GHDL)
```bash
# from track/vhdl_zero2hero/
ghdl -a --std=08 0007/solution.vhdl 0007/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
A correct run prints `Test PASS`. Swap `solution.vhdl` for `interface.vhdl` to test
your own answer.
