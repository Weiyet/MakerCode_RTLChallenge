# Module instantiation (by name)

**Difficulty:** ⭐⭐ · **Topics:** named port connections

## Background
Connecting ports **by name** — `.port_name(signal)` — is the robust way to
instantiate. The order no longer matters, each connection is explicit, and adding
or reordering a port on the sub-module will not silently mis-wire your instance.
Real RTL uses named connection almost exclusively.

## The task
Instantiate the same provided `mod_a` (defined in `tb.sv`), but this time connect
every port **by name**.

### Sub-module you must instantiate
```systemverilog
module mod_a (output out1, output out2,
              input a, input b, input c, input d);
```

## Interface (your module)
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b`, `c`, `d` | input  | 1 | data |
| `out1`, `out2`     | output | 1 | from `mod_a` |

## How to approach it
```systemverilog
module inst_by_name (input logic a, b, c, d, output logic out1, out2);
    mod_a u_a (.out1(out1), .out2(out2), .a(a), .b(b), .c(c), .d(d));
endmodule
```
Because it is by name, you may list the connections in any order.

## Common mistakes
- Typos in a port name — the tool flags an unknown port, which is exactly the
  safety named connection buys you.
- Leaving a port unconnected (`.a()`) by accident.

## SystemVerilog notes
`.*` (implicit port connection) auto-connects ports whose names match local
signals — handy, but explicit `.name(sig)` is clearest while learning.
