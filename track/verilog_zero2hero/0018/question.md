# Packed struct

**Difficulty:** ⭐⭐⭐ · **Topics:** `struct packed`, `typedef`, bit layout

## Learning objective
Group related fields into a named `struct packed` and let the tool lay them out
in a bit-vector for you.

## Problem
Pack a control word from four fields. A packed struct lays fields out MSB-first
in declaration order, so the resulting 16-bit `word` is:

| bits    | field  |
|---------|--------|
| [15:12] | opcode |
| [11:9]  | src    |
| [8:6]   | dst    |
| [5:0]   | imm    |

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `opcode` | input  | 4 | operation |
| `src`    | input  | 3 | source reg |
| `dst`    | input  | 3 | dest reg |
| `imm`    | input  | 6 | immediate |
| `word`   | output | 16 | packed control word |

## Hints
- Declare `typedef struct packed { logic [3:0] opcode; ... } ctrl_t;`
- Assigning `word = c;` where `c` is a `ctrl_t` flattens it to bits.

## SystemVerilog notes
A `struct packed` *is* a vector — you can index/slice it and assign it to a plain
`logic` bus. Field order top-to-bottom maps MSB-to-LSB.
