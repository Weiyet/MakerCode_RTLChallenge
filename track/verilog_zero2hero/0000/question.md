# Wire

**Difficulty:** ⭐ (Getting started) · **Topics:** modules, ports, `assign`, the `logic` type

## Learning objective
Create a module with one input and one output and connect them with a
continuous assignment. This is the "hello world" of hardware description.

## Problem
Build a module `wire_passthrough` that behaves like a plain wire: the output
`out` always equals the input `in`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`  | input  | 1 | source signal |
| `out` | output | 1 | copy of `in` |

```mermaid
graph LR
    in([in]) --- out([out])
```

## Hints
- A wire connection is *continuous* — use `assign`, not an `always` block.
- In SystemVerilog prefer `logic` over `wire`/`reg`; a single-bit port is just `logic`.

## SystemVerilog notes
`logic` is a 4-state type (0/1/x/z) that can be driven by either `assign` or
procedural blocks, so you rarely need `wire`/`reg` anymore.
