# VHDL types (records)

**Difficulty:** ⭐⭐⭐ · **Topics:** `record` type, concatenation

## Background
A VHDL **record** groups named fields — the counterpart of a struct. Unlike a
SystemVerilog `struct packed`, a record is **not** automatically a bit-vector, so
to produce a packed bus you flatten it explicitly with `&`. Records are still very
useful for passing bundles of related signals around a design.

## The task
Pack a 16-bit control word (MSB-first): `opcode`(4) · `src`(3) · `dst`(3) · `imm`(6).

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `opcode` | in  | std_logic_vector(3 downto 0) | operation |
| `src`    | in  | std_logic_vector(2 downto 0) | source reg |
| `dst`    | in  | std_logic_vector(2 downto 0) | dest reg |
| `imm`    | in  | std_logic_vector(5 downto 0) | immediate |
| `word`   | out | std_logic_vector(15 downto 0) | packed word |

## How to approach it
```vhdl
type ctrl_t is record
    opcode : std_logic_vector(3 downto 0);
    src    : std_logic_vector(2 downto 0);
    dst    : std_logic_vector(2 downto 0);
    imm    : std_logic_vector(5 downto 0);
end record;
...
c.opcode := opcode; c.src := src; c.dst := dst; c.imm := imm;
word <= c.opcode & c.src & c.dst & c.imm;
```

## Common mistakes
- Expecting `word <= c;` to work — a record is not a vector; concatenate its
  fields.
- Field/bit-order: concatenate MSB field first.

## VHDL notes
For bit-exact packing you can also use a record with a to/from-`std_logic_vector`
conversion function, but explicit `&` is the clearest for a fixed layout.
