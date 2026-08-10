# Reduction operators

**Difficulty:** ⭐⭐ · **Topics:** reduction `&` `|` `^`

## Background
A **reduction operator** is a single `&`, `|`, or `^` placed *in front of one
vector*. It folds the whole vector down to one bit by applying that operator
between all the bits:
- `&d`  → AND of every bit  (1 only if **all** bits are 1)
- `|d`  → OR of every bit   (1 if **any** bit is 1)
- `^d`  → XOR of every bit  (this is the **parity** of the word)

This is different from the *bitwise* operators you saw in problem 0003: `a & b`
combines two vectors lane-by-lane and returns a vector; `&a` combines the bits
*within* one vector and returns a single bit.

## The task
For an 8-bit input compute `all_ones = &in`, `any_one = |in`, `parity = ^in`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`       | input  | 8 | data |
| `all_ones` | output | 1 | `&in` |
| `any_one`  | output | 1 | `|in` |
| `parity`   | output | 1 | `^in` |

## How to approach it
```systemverilog
assign all_ones = &in;
assign any_one  = |in;
assign parity   = ^in;
```

## Worked example
`in = 8'b1011_0010`: `all_ones=0` (not all bits 1), `any_one=1`, `parity = 1^0^1^1^0^0^1^0 = 0`.

## Common mistakes
- Writing `in & in` (bitwise, returns 8 bits) when you meant `&in` (reduction,
  returns 1 bit).
- Expecting `parity` to mean "even/odd count" directly — `^in` is 1 when the
  number of set bits is **odd**.

## SystemVerilog notes
Reduction has cousins `~&` (NAND-reduce), `~|` (NOR-reduce), `~^` (XNOR-reduce).
`^in` is the classic one-liner for a parity bit.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0006/tb.sv 0006/solution.sv && vvp sim
```
