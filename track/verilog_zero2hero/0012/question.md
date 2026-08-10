# Combinational logic (avoiding inferred latches)

**Difficulty:** ⭐⭐⭐ · **Topics:** `always_comb`, complete assignment, latch inference

## Background
In an `always_comb` block, **every output must be assigned on every path**. If a
`case`/`if` leaves an output unassigned for some inputs, the tool infers a
**latch** to "remember" the old value — almost always a bug. The fix is a
**default assignment** at the top of the block (or a full `else`/`default`).

Here the checker actually *detects the latch*: with an incomplete `case`, an
unselected input leaves the output holding its previous value, which the
testbench catches.

## The task
Build `sel_mux`: output `y = a` when `sel==0`, `b` when `1`, `c` when `2`, and a
defined **`0`** when `sel==3`. Use `always_comb` with a **default assignment** so
no latch is inferred.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `sel`     | input  | 2 | selector |
| `a`,`b`,`c` | input | 8 | data |
| `y`       | output | 8 | selected value, `0` when sel==3 |

## How to approach it
```systemverilog
always_comb begin
    y = '0;                 // default => no latch, defines the sel==3 case
    case (sel)
        2'd0: y = a;
        2'd1: y = b;
        2'd2: y = c;
    endcase
end
```

## Common mistakes
- Omitting the default and only covering `sel` 0..2 — `sel==3` then latches the
  old `y`, and the test fails.
- Using `always @(*)` with blocking `=` is fine, but `always_comb` also *checks*
  for accidental latches at compile time.
