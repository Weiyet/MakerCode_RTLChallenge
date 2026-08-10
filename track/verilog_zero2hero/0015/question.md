# Priority encoder (casez)

**Difficulty:** ⭐⭐⭐ · **Topics:** `casez`, don't-cares, priority

## Background
An **encoder** reports *which* input is active. A **priority** encoder handles the
case where several inputs are active at once by picking the highest-priority one
(here, the highest-numbered set bit). It also needs a `valid` flag for "nothing
set". `casez` makes this elegant: `?` (or `z`) bits in a case *item* are
wildcards, so `4'b1???` matches any input whose MSB is 1 — the higher branches
naturally win because `case` checks items top to bottom.

## The task
Report the index of the highest set bit of a 4-bit input; `valid=0` when no bit
is set.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`    | input  | 4 | request bits |
| `pos`   | output | 2 | index of highest set bit |
| `valid` | output | 1 | 1 if any bit set |

## Behaviour
| in    | valid | pos |
|-------|-------|-----|
| 1xxx  | 1 | 3 |
| 01xx  | 1 | 2 |
| 001x  | 1 | 1 |
| 0001  | 1 | 0 |
| 0000  | 0 | 0 |

## How to approach it
```systemverilog
always_comb begin
    valid = 1'b1;
    casez (in)
        4'b1???: pos = 2'd3;
        4'b01??: pos = 2'd2;
        4'b001?: pos = 2'd1;
        4'b0001: pos = 2'd0;
        default: begin pos = 2'd0; valid = 1'b0; end
    endcase
end
```

## Common mistakes
- Using `casex` instead of `casez`: `casex` also wild-cards `x`/`z` on the *input*
  side, which can mask real bugs. Prefer `casez`.
- Forgetting the `default` (the all-zero case) so `valid` is undefined.

## SystemVerilog notes
Order matters in `casez` when items overlap — the first match wins, which is
exactly how priority is expressed here.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0015/tb.sv 0015/solution.sv && vvp sim
```
