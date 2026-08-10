# Basic logic gates

**Difficulty:** ⭐ · **Topics:** bitwise operators, multiple outputs

## Background
Every combinational circuit is built from a handful of primitive gates. Here you
compute all six at once from the same two inputs. This also shows that a module
can have **many outputs** — just add more ports and more `assign` lines.

The operators:

| gate | operator | meaning |
|------|----------|---------|
| AND  | `a & b`    | 1 only if both are 1 |
| OR   | `a \| b`   | 1 if either is 1 |
| XOR  | `a ^ b`    | 1 if the inputs differ |
| NAND | `~(a & b)` | inverted AND |
| NOR  | `~(a \| b)`| inverted OR |
| XNOR | `~(a ^ b)` | 1 if the inputs are equal |

## The task
Given `a` and `b`, drive the six gate outputs.

## Interface
| Port | Dir | Width | Function |
|------|-----|-------|----------|
| `a`, `b`   | input  | 1 | operands |
| `y_and`    | output | 1 | a AND b |
| `y_or`     | output | 1 | a OR b |
| `y_xor`    | output | 1 | a XOR b |
| `y_nand`   | output | 1 | a NAND b |
| `y_nor`    | output | 1 | a NOR b |
| `y_xnor`   | output | 1 | a XNOR b |

## How to approach it
One `assign` per output; wrap the inverted forms in parentheses:
```systemverilog
assign y_nand = ~(a & b);
```

## Common mistakes
- Precedence: `~a & b` is `(~a) & b`, **not** `~(a & b)`. Always parenthesise the
  NAND/NOR/XNOR forms.
- Confusing `^` (XOR) with `~^`/`^~` (XNOR).

## SystemVerilog notes
These same operators work on whole vectors lane-by-lane, so `8'hF0 & 8'h0F` is
`8'h00`. Reduction (a single `&`/`|`/`^` in front of one vector) is different and
is covered in a later problem.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0003/tb.sv 0003/solution.sv && vvp sim
```
