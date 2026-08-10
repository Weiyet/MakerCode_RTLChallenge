# Module instantiation (connecting instances & vectors)

**Difficulty:** ⭐⭐⭐ · **Topics:** vector ports on instances, tapping internal nodes

## Background
Sub-modules often carry **vector** ports. Here you chain three 8-bit registers and
add a mux that taps different points along the chain, so `sel` chooses how many
cycles of delay to apply. This mixes instantiation (the three registers) with a
little combinational logic (the tap mux) — a very common RTL pattern.

## The task
`my_dff8` (an 8-bit register) is **provided in `tb.sv`**. Build `shift8_mux`:
chain three of them, then select the output with `sel`:
`0` = the input `d`, `1` = after 1 stage, `2` = after 2 stages, `3` = after 3.

### Sub-module you must instantiate
```systemverilog
module my_dff8 (input clk, input [7:0] d, output [7:0] q);
```

## Interface (your module)
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk` | input  | 1 | clock |
| `d`   | input  | 8 | data in |
| `sel` | input  | 2 | tap select (0..3) |
| `q`   | output | 8 | selected tap |

## How to approach it
```systemverilog
logic [7:0] o1, o2, o3;
my_dff8 a (.clk(clk), .d(d),  .q(o1));
my_dff8 b (.clk(clk), .d(o1), .q(o2));
my_dff8 c (.clk(clk), .d(o2), .q(o3));
always_comb
    case (sel)
        2'd0: q = d;   2'd1: q = o1;
        2'd2: q = o2;  default: q = o3;
    endcase
```

## Common mistakes
- Feeding each register the same input instead of chaining `o1 -> o2 -> o3`.
- Forgetting `sel=0` taps the *combinational* input `d` (zero delay).
