# SystemVerilog types (enum & ALU)

**Difficulty:** ⭐⭐⭐ · **Topics:** `enum`, `case`, `always_comb`, status flags

## Background
An **ALU** performs one of several operations chosen by an opcode. Using raw
numbers (`3'd5`) for opcodes is error-prone; an **`enum`** gives each a readable
name and lets the tool width-check them. ALUs also produce **status flags** — here
`zero`, high when the result is all-zero — which control flow later depends on.

## The task
8-bit ALU driven by `op`, with a `zero` flag.

| op | name | y |
|----|------|---|
| 0 | ADD | a + b |
| 1 | SUB | a - b |
| 2 | AND | a & b |
| 3 | OR  | a \| b |
| 4 | XOR | a ^ b |
| 5 | SLL | a << b[2:0] |
| 6 | SRL | a >> b[2:0] |
| 7 | SLT | (a < b) ? 1 : 0 (unsigned) |

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b` | input  | W | operands |
| `op`     | input  | 3 | opcode |
| `y`      | output | W | result |
| `zero`   | output | 1 | result == 0 |

**Parameter:** `W` (default 8)

## How to approach it
Name the opcodes, then `case` on them inside `always_comb`, and derive `zero`
from the result:
```systemverilog
typedef enum logic [2:0] {OP_ADD, OP_SUB, OP_AND, OP_OR, OP_XOR, OP_SLL, OP_SRL, OP_SLT} op_e;
always_comb begin
    case (op)               // enum names are usable as case labels
        OP_ADD: y = a + b;
        // ...
        default: y = '0;
    endcase
    zero = (y == '0);
end
```

## Common mistakes
- Leaving an opcode unhandled (add a `default`).
- Shift amount width: use `b[2:0]` so shifting an 8-bit value is well-defined.
- Note some tools reject casting a plain vector to the enum type in the `case`
  expression, so this design cases on `op` directly with the enum names as labels.

## SystemVerilog notes
`typedef enum logic [2:0] {...}` fixes the underlying width, so the names are just
readable constants — the waveform shows `OP_SUB` instead of `3'd1`.
