# Vector reverse

**Difficulty:** ⭐⭐ · **Topics:** `always_comb`, `for` loop, indexing

## Learning objective
Use a synthesizable `for` loop inside `always_comb` to build combinational logic
element-by-element.

## Problem
Reverse the bit order of an 8-bit vector: `out[i] = in[7-i]`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`  | input  | 8 | data |
| `out` | output | 8 | bit-reversed data |

## Hints
- A `for` loop in `always_comb` is unrolled by the synthesizer — it is not a
  runtime loop, just a compact way to write repetitive wiring.

## SystemVerilog notes
`always_comb` auto-builds the sensitivity list and warns if the block
accidentally infers a latch — prefer it over `always @(*)`.
