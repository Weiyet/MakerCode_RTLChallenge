# ALU with an enumerated opcode

**Difficulty:** ⭐⭐⭐ · **Topics:** enumerated `type`, `'val`, `case`, `numeric_std`

## Background
An **ALU** does one of several operations chosen by an opcode. Rather than switch
on raw numbers, define an **enumerated type** (`type op_t is (OP_ADD, ...)`) for
readable names. The opcode arrives as a `std_logic_vector`, so convert it with
`op_t'val(to_integer(unsigned(op)))` — the `'val` attribute maps an integer
position to the matching enum value. Arithmetic uses `unsigned` from
`ieee.numeric_std`.

## The task
8-bit ALU with a `zero` flag.

| op | name | y |
|----|------|---|
| 0 | ADD | a + b |
| 1 | SUB | a - b |
| 2 | AND | a and b |
| 3 | OR  | a or b |
| 4 | XOR | a xor b |
| 5 | SLL | a shifted left by b(2:0) |
| 6 | SRL | a shifted right by b(2:0) |
| 7 | SLT | 1 if a < b (unsigned) else 0 |

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b` | in  | std_logic_vector(W-1 downto 0) | operands |
| `op`     | in  | std_logic_vector(2 downto 0)   | opcode |
| `y`      | out | std_logic_vector(W-1 downto 0) | result |
| `zero`   | out | std_logic | result = 0 |

**Generic:** `W` (default 8)

## How to approach it
```vhdl
type op_t is (OP_ADD, OP_SUB, OP_AND, OP_OR, OP_XOR, OP_SLL, OP_SRL, OP_SLT);
...
case op_t'val(to_integer(unsigned(op))) is
    when OP_ADD => ys := std_logic_vector(unsigned(a) + unsigned(b));
    when OP_SLL => ys := std_logic_vector(shift_left(unsigned(a), sh));
    -- ...
end case;
```
Use `shift_left`/`shift_right` (numeric_std) for the shifts and derive `zero`
from the result.

## Common mistakes
- Forgetting `use ieee.numeric_std.all;`.
- Trying to do arithmetic directly on `std_logic_vector` — cast to `unsigned`
  first.

## VHDL notes
`op_t'val(n)` is the inverse of `op_t'pos(v)`. Enumerated states/opcodes show up
by name in the waveform.

## Run it (GHDL)
```bash
ghdl -a --std=08 0017/solution.vhdl 0017/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
