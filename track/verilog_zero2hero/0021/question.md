# D flip-flop

**Difficulty:** ⭐⭐ · **Topics:** `always_ff`, non-blocking `<=`, clock edge

## Background
Everything so far was **combinational** — outputs follow inputs instantly. A
**flip-flop** adds *memory*: it samples its input on the rising clock edge and
holds that value until the next edge. This is the atom of all sequential logic.
Describe it with `always_ff @(posedge clk)` and the **non-blocking** assignment
`<=`, which models "all flops sample together, then update together".

## The task
On each rising edge of `clk`, `q` takes `d`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk` | input  | 1 | clock |
| `d`   | input  | 1 | data |
| `q`   | output | 1 | registered data |

```wavedrom
{ "signal": [
  {"name": "clk", "wave": "p......"},
  {"name": "d",   "wave": "0.1..0."},
  {"name": "q",   "wave": "0..1..0"}
]}
```
Notice `q` follows `d` but shifted to the next clock edge.

## How to approach it
```systemverilog
always_ff @(posedge clk)
    q <= d;
```

## Common mistakes
- Using blocking `=` for state — always use `<=` in `always_ff`. Mixing them
  causes simulation/synthesis mismatches and race-like bugs.
- Reading `q` combinationally elsewhere and expecting the *new* value in the same
  cycle — it updates only at the edge.

## SystemVerilog notes
`always_ff` tells the tool "this is a register"; it will error if the body cannot
be synthesized as flops. Combinational logic uses `always_comb` with `=`;
sequential uses `always_ff` with `<=`.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0021/tb.sv 0021/solution.sv && vvp sim
```
