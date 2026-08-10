# Vector reverse

**Difficulty:** ⭐⭐ · **Topics:** `always_comb`, `for` loop, indexing

## Background
Some wiring patterns are tedious to write bit-by-bit. A synthesizable **`for`
loop** inside an `always_comb` block lets you describe them compactly. The key
idea: this loop is **unrolled at build time** — it is *not* a runtime loop. The
synthesizer expands it into plain parallel wiring, one statement per iteration.

Reversing a vector (`out[i] = in[7-i]`) is a perfect example: 8 simple
connections written as one loop.

## The task
Reverse the bit order of an 8-bit vector.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`  | input  | 8 | data |
| `out` | output | 8 | bit-reversed data |

## How to approach it
```systemverilog
always_comb begin
    for (int i = 0; i < 8; i++)
        out[i] = in[7-i];
end
```
Inside a combinational `always_comb`, use blocking `=` (not `<=`).

## Worked example
`in = 8'b1100_0001` → `out = 8'b1000_0011`.

## Common mistakes
- Using non-blocking `<=` in combinational logic — use `=` in `always_comb`.
- Off-by-one in the index (`in[8-i]` reads out of range).
- Forgetting that every output bit must be assigned, or a latch may be inferred
  (here the loop covers all 8, so we are safe).

## SystemVerilog notes
`always_comb` builds the sensitivity list for you and the tool will *warn* if the
block accidentally infers a latch — a big reason to prefer it over the old
`always @(*)`.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0008/tb.sv 0008/solution.sv && vvp sim
```
