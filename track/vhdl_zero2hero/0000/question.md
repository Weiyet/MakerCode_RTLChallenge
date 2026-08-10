# Wire

**Difficulty:** ⭐ (Getting started) · **Topics:** entity/architecture, `signal`, concurrent assignment

## Background
VHDL describes hardware, not a sequential program. A design unit has two parts:
an **entity** (its name and its **ports** — the inputs and outputs) and an
**architecture** (the body describing behaviour). The simplest circuit is a
**wire**, a permanent connection, written as a **concurrent signal assignment**
in the architecture body. "Concurrent" means it is always active: whenever the
input changes, the output follows.

> `in` and `out` are VHDL **reserved words** (port directions), so the data ports
> are named `a` and `y`.

## The task
Build `wire_passthrough` where `y` always equals `a`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a` | in  | std_logic | source |
| `y` | out | std_logic | copy of `a` |

```mermaid
graph LR
    a([a]) --- y([y])
```

## How to approach it
The entity/architecture skeleton is given; add one concurrent assignment:
```vhdl
y <= a;
```

## Common mistakes
- Using `:=` (variable assignment) where `<=` (signal assignment) is required for
  a signal/port.
- Putting the assignment outside the `architecture ... begin ... end` region.

## VHDL notes
`std_logic` (from `ieee.std_logic_1164`) is the 9-value logic type used for
synthesis. Remember the two assignment operators: `<=` for **signals**, `:=` for
**variables** (seen later inside processes).

## Run it (GHDL)
```bash
# from track/vhdl_zero2hero/
ghdl -a --std=08 0000/solution.vhdl 0000/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
A correct run prints `Test PASS`. Swap `solution.vhdl` for `interface.vhdl` to test
your own answer.
