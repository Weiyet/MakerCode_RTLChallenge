# Records (grouping fields)

**Difficulty:** ⭐⭐⭐ · **Topics:** `record` type, concatenation

## Learning objective
Group related fields into a `record` (VHDL's struct), then flatten them onto a
bus with `&`.

## Problem
Pack a 16-bit control word from four fields, MSB-first:

| bits    | field  |
|---------|--------|
| [15:12] | opcode |
| [11:9]  | src    |
| [8:6]   | dst    |
| [5:0]   | imm    |

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `opcode` | in  | std_logic_vector(3 downto 0) | operation |
| `src`    | in  | std_logic_vector(2 downto 0) | source reg |
| `dst`    | in  | std_logic_vector(2 downto 0) | dest reg |
| `imm`    | in  | std_logic_vector(5 downto 0) | immediate |
| `word`   | out | std_logic_vector(15 downto 0) | packed word |

## VHDL notes
Unlike a SystemVerilog `struct packed`, a VHDL `record` is **not** automatically
a bit-vector — you flatten it explicitly with `&`. Records are still great for
passing grouped signals around a design.
