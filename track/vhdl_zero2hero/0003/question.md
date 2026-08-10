# Basic logic gates

**Difficulty:** ⭐ · **Topics:** logical operators, multiple outputs

## Background
Every combinational circuit is built from primitive gates. Here you compute all
six from the same two inputs — and see that an entity can have many outputs.
Unlike Verilog, VHDL has **dedicated** `nand`/`nor`/`xnor` operators, so you do
not have to write `not (a and b)`.

| gate | VHDL |
|------|------|
| AND  | `a and b` |
| OR   | `a or b` |
| XOR  | `a xor b` |
| NAND | `a nand b` |
| NOR  | `a nor b` |
| XNOR | `a xnor b` |

## The task
Drive the six gate outputs from `a` and `b`.

## Interface
| Port | Dir | Type | Function |
|------|-----|------|----------|
| `a`, `b`   | in  | std_logic | operands |
| `y_and`    | out | std_logic | a and b |
| `y_or`     | out | std_logic | a or b |
| `y_xor`    | out | std_logic | a xor b |
| `y_nand`   | out | std_logic | a nand b |
| `y_nor`    | out | std_logic | a nor b |
| `y_xnor`   | out | std_logic | a xnor b |

## How to approach it
One concurrent assignment per output, e.g. `y_nand <= a nand b;`.

## Common mistakes
- Naming a signal after an operator keyword (`and`) — illegal; hence `y_and`.
- In VHDL, `and`/`or` have **equal** precedence, so mixed expressions need
  parentheses: `(a and b) or c`.

## VHDL notes
These operators also apply to `std_logic_vector` lane-by-lane.

## Run it (GHDL)
```bash
# from track/vhdl_zero2hero/
ghdl -a --std=08 0003/solution.vhdl 0003/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
A correct run prints `Test PASS`. Swap `solution.vhdl` for `interface.vhdl` to test
your own answer.
