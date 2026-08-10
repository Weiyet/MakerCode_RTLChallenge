# Combinational logic (wires, assign & constants)

**Difficulty:** ⭐ · **Topics:** entity/architecture, concurrent assignment, constants

## Background
The most basic block is a signal driven by a **concurrent assignment** (`<=`
outside a process). An entity declares **ports**; the architecture drives outputs.
Outputs can also be tied to **constants** with the bit literals `'0'` and `'1'`.

## The task
Build `wires_const`: pass `a` straight to `y`, and drive `one` high and `zero` low.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`    | in  | std_logic | data in |
| `y`    | out | std_logic | copy of `a` |
| `one`  | out | std_logic | constant `'1'` |
| `zero` | out | std_logic | constant `'0'` |

## How to approach it
```vhdl
y    <= a;
one  <= '1';
zero <= '0';
```

## VHDL notes
Concurrent assignments run in parallel, not top-to-bottom — order does not matter.
