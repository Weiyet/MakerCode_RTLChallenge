# Inverter (NOT)

**Difficulty:** ⭐ · **Topics:** bitwise NOT

## Background
The inverter is the most basic logic gate: it flips a bit. `0` becomes `1` and
`1` becomes `0`. In SystemVerilog the bitwise-NOT operator is the tilde `~`.
(There is also a *logical* NOT `!` used on true/false conditions — for a single
data bit they behave the same, but `~` is the right choice for data.)

## The task
Build `not_gate` where `out = NOT in`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`  | input  | 1 | source |
| `out` | output | 1 | inverted source |

```mermaid
graph LR
    in([in]) --> N["NOT"] --> out([out])
```

## Truth table
| in | out |
|----|-----|
| 0  | 1   |
| 1  | 0   |

## How to approach it
```systemverilog
assign out = ~in;
```

## Common mistakes
- Using `!in` out of habit — fine here, but on multi-bit buses `!bus` gives a
  single true/false bit while `~bus` inverts every bit. Use `~` for data.

## SystemVerilog notes
`~` applies bit-by-bit, so `~8'b1010_0000` is `8'b0101_1111`. Keep "bitwise" (`~`,
`&`, `|`, `^`) separate from "logical" (`!`, `&&`, `||`) in your mind.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0002/tb.sv 0002/solution.sv && vvp sim
```
