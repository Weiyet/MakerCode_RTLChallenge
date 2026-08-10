# Combinational logic (basic gates incl. NOT)

**Difficulty:** ⭐ · **Topics:** logical operators, multiple outputs

## Background
VHDL has the logic operators `not`, `and`, `or`, `xor`, `nand`, `nor`, `xnor`.
One architecture can drive many outputs, each with its own concurrent assignment.

## The task
Build `gates`: from `a`, `b` drive NOT (of `a`), AND, OR, XOR, NAND, NOR and XNOR.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b` | in  | std_logic | operands |
| `y_not`  | out | std_logic | `not a` |
| `y_and`, `y_or`, `y_xor` | out | std_logic | and/or/xor |
| `y_nand`, `y_nor`, `y_xnor` | out | std_logic | negated forms |

## How to approach it
```vhdl
y_not  <= not a;
y_and  <= a and b;
y_or   <= a or  b;
y_xor  <= a xor b;
y_nand <= a nand b;
y_nor  <= a nor  b;
y_xnor <= a xnor b;
```

## VHDL notes
Unlike some languages, `nand`/`nor` are first-class operators in VHDL.
