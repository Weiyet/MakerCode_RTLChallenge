# SystemVerilog types (packed struct & typedef)

**Difficulty:** ⭐⭐⭐ · **Topics:** `struct packed`, `typedef`, bit layout

## Background
A **`struct packed`** groups named fields but is still, underneath, one
bit-vector — so you can assign it to a plain `logic` bus and the fields land in
declaration order, MSB first. This is perfect for instruction words, packet
headers, or any format where named fields beat magic bit-ranges.

## The task
Pack a 16-bit control word from four fields:

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

## How to approach it
```systemverilog
typedef struct packed {
    logic [3:0] opcode;
    logic [2:0] src;
    logic [2:0] dst;
    logic [5:0] imm;
} ctrl_t;
ctrl_t c;
always_comb begin
    c.opcode = opcode; c.src = src; c.dst = dst; c.imm = imm;
    word = c;            // flatten to 16 bits
end
```

## Common mistakes
- Field order: the *first* field declared occupies the *most-significant* bits.
- Widths must sum to the bus width (4+3+3+6 = 16).

## SystemVerilog notes
Because a packed struct *is* a vector, you can also slice or index it, and pass it
through ports. `struct packed` is the readable alternative to hand-managing bit
ranges.
