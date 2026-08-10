# Module instantiation (parameter override)

**Difficulty:** ⭐⭐⭐ · **Topics:** `#(.PARAM(value))`, parameterized reuse

## Background
A **parameterized** module is a template: one description, many widths. When you
instantiate it you **override** the parameter with `#(.NAME(value))` so each copy
is sized for its job. This is how one proven block (a register, a FIFO, an adder)
is reused at different widths across a chip.

## The task
A parameterized register `wide_reg #(WIDTH)` is **provided in `tb.sv`**.
Instantiate it **twice** inside `param_inst`: once at **WIDTH=4** for the `d4→q4`
path, once at **WIDTH=12** for the `d12→q12` path.

### Sub-module you must instantiate
```systemverilog
module wide_reg #(parameter int WIDTH = 8)
    (input clk, input [WIDTH-1:0] d, output [WIDTH-1:0] q);
```

## Interface (your module)
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk` | input  | 1  | clock |
| `d4`  | input  | 4  | 4-bit data in |
| `q4`  | output | 4  | 4-bit data out (1-cycle delay) |
| `d12` | input  | 12 | 12-bit data in |
| `q12` | output | 12 | 12-bit data out (1-cycle delay) |

## How to approach it
```systemverilog
wide_reg #(.WIDTH(4))  u4  (.clk(clk), .d(d4),  .q(q4));
wide_reg #(.WIDTH(12)) u12 (.clk(clk), .d(d12), .q(q12));
```

## Common mistakes
- Leaving the parameter at its default (`wide_reg u4 (...)`) — the port widths
  then mismatch `d4`/`q4` and it will not size correctly.
- Overriding by order `#(4)` is legal but named `#(.WIDTH(4))` is clearer.
