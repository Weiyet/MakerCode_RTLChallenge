# 2-to-4 Decoder (with enable)

**Difficulty:** ⭐⭐ · **Topics:** decoders, one-hot, enable

## Background
A **decoder** is the opposite of an encoder: it turns an N-bit binary code into a
**one-hot** output where exactly one of `2^N` lines is high. Decoders select rows
in memories, enable one of several blocks, etc. An **enable** input gates the
whole thing — when it is low, no output is asserted.

## The task
When `en=1`, assert the single `out` bit chosen by `in`; when `en=0`, all outputs
are 0.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`  | input  | 2 | binary code |
| `en`  | input  | 1 | enable |
| `out` | output | 4 | one-hot (or all-zero) |

## Truth table (en=1)
| in | out |
|----|-----|
| 00 | 0001 |
| 01 | 0010 |
| 10 | 0100 |
| 11 | 1000 |

## How to approach it
Clear all outputs, then set the selected bit only when enabled:
```systemverilog
always_comb begin
    out = 4'b0000;
    if (en) out[in] = 1'b1;
end
```
Indexing `out[in]` with a signal is a neat way to write the shift `1 << in`.

## Common mistakes
- Not clearing `out` first — every path must define `out` or you get a latch.
- Forgetting to gate on `en`.

## SystemVerilog notes
`out[in] = 1'b1` uses a variable index — synthesizable and equivalent to
`out = en ? (4'b1 << in) : '0;`. Both are fine; pick whichever reads clearer.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0014/tb.sv 0014/solution.sv && vvp sim
```
