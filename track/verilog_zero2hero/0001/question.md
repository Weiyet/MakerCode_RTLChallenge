# Combinational logic (basic gates incl. NOT)

**Difficulty:** ⭐ · **Topics:** bitwise operators, multiple outputs

## Background
The bitwise operators are the vocabulary of combinational logic: `~` (NOT),
`&` (AND), `|` (OR), `^` (XOR), and the negated forms NAND/NOR/XNOR. A single
module can drive many outputs, each with its own `assign`.

## The task
Build `gates`: from inputs `a`, `b`, drive NOT (of `a`), AND, OR, XOR, NAND, NOR
and XNOR.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b` | input  | 1 | operands |
| `y_not`  | output | 1 | `~a` |
| `y_and`, `y_or`, `y_xor` | output | 1 | a·b, a+b, a⊕b |
| `y_nand`, `y_nor`, `y_xnor` | output | 1 | negated forms |

## How to approach it
```systemverilog
assign y_not  = ~a;
assign y_and  =  a & b;
assign y_or   =  a | b;
assign y_xor  =  a ^ b;
assign y_nand = ~(a & b);
assign y_nor  = ~(a | b);
assign y_xnor =  a ~^ b;   // or ~(a ^ b)
```

## Common mistakes
- Confusing bitwise `&`/`|` with logical `&&`/`||` (fine here on 1-bit, but they
  differ on vectors).
