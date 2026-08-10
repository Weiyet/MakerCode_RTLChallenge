# Combinational logic (wires, assign & constants)

**Difficulty:** ⭐ · **Topics:** modules, ports, `assign`, constant drivers

## Background
The most basic building block is a **wire** driven by a continuous `assign`. A
module has **ports** (its inputs/outputs) and `assign` continuously drives an
output from an expression. Outputs can also be tied to **constants** with sized
literals: `1'b0` (low), `1'b1` (high).

## The task
Build `wires_const`: pass input `a` straight to `y`, and drive `one` constantly
high and `zero` constantly low.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`    | input  | 1 | data in |
| `y`    | output | 1 | copy of `a` |
| `one`  | output | 1 | constant `1'b1` |
| `zero` | output | 1 | constant `1'b0` |

## How to approach it
```systemverilog
assign y    = a;
assign one  = 1'b1;
assign zero = 1'b0;
```

## Common mistakes
- Writing `1` instead of `1'b1` — prefer sized literals in RTL.
- Using `logic`/`always` where a simple `assign` is clearer.
