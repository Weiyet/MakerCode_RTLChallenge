# Module instantiation (by position)

**Difficulty:** ⭐⭐ · **Topics:** hierarchy, instantiating a sub-module, positional ports

## Background
Real designs are **hierarchical**: you build small modules and wire them together
inside bigger ones. Placing a copy of a module inside another is called
**instantiation**. This is arguably *the* core RTL skill — a chip is thousands of
instances connected up.

The syntax is `module_name instance_label ( connections );`. With **positional**
connections you list the signals in the *same order* as the sub-module's port
declaration — so the order matters and must match exactly.

## The task
A sub-module `mod_a` is **provided by the testbench** (it is defined in `tb.sv`;
do not redefine it). Write `inst_by_position` so it computes `out1`/`out2` by
**instantiating `mod_a`** and connecting its ports **by position**.

### Sub-module you must instantiate
```systemverilog
module mod_a (output out1, output out2,
              input a, input b, input c, input d);
```
(port order: `out1, out2, a, b, c, d`)

## Interface (your module)
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b`, `c`, `d` | input  | 1 | data |
| `out1`, `out2`     | output | 1 | from `mod_a` |

## How to approach it
```systemverilog
module inst_by_position (input logic a, b, c, d, output logic out1, out2);
    mod_a u_a (out1, out2, a, b, c, d);   // order matches mod_a's port list
endmodule
```

## Common mistakes
- Wrong order — positional connection silently mis-wires if the order is off.
- Re-declaring `mod_a` in your file. It already exists in `tb.sv`; just
  instantiate it.

## SystemVerilog notes
Positional connection is compact but fragile; for anything non-trivial prefer
**named** connection (next problem), which is order-independent and
self-documenting.
