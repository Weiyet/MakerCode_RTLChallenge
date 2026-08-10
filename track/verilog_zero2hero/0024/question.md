# Sequential logic (LFSR)

**Difficulty:** ⭐⭐⭐ · **Topics:** feedback shift register, XOR taps

## Background
A **Linear-Feedback Shift Register** is a shift register whose serial input is the
XOR of selected bits (**taps**). With the right taps it cycles through all `2^N-1`
non-zero states before repeating — a cheap pseudo-random generator used for test
patterns, scramblers, and CRCs. This 8-bit LFSR uses taps 8,6,5,4
(polynomial `x^8 + x^6 + x^5 + x^4 + 1`).

## The task
`feedback = q[7]^q[5]^q[4]^q[3]`, then shift left inserting `feedback`. Seed to
`8'hFF` on reset; advance only when `en=1`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`, `rst_n` | input | 1 | clock / async reset (seed = FF) |
| `en`  | input  | 1 | advance enable |
| `q`   | output | 8 | LFSR state |

## How to approach it
```systemverilog
logic fb;
assign fb = q[7] ^ q[5] ^ q[4] ^ q[3];
always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)  q <= 8'hFF;
    else if (en) q <= {q[6:0], fb};
```

## Common mistakes
- Seeding to 0 — an all-zero LFSR is a lock-up state and never moves. Seed to any
  non-zero value.
- Wrong tap set — only specific taps give the maximal-length sequence.

## SystemVerilog notes
`fb = ^(q & 8'b1011_1000)` is an equivalent way to express the same tap XOR using
a reduction over a masked value.
