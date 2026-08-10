# Sequential logic (blocking vs non-blocking)

**Difficulty:** ⭐⭐⭐ · **Topics:** `<=` vs `=`, scheduling, shift register

## Background
Inside a clocked `always_ff`, **use non-blocking `<=`**. Non-blocking assignments
all sample their right-hand sides first, then update together at the clock edge —
so every flop sees the *old* value of its neighbour. That is exactly what a shift
register needs.

If you use **blocking `=`** in a chain, each statement updates immediately, so a
later line sees the *new* value — and a 3-stage shift register collapses into a
single stage (all bits equal the input). Same code shape, very different hardware.

## The task
Build `shift3` (a 3-stage shift register): each clock, `q[0]` takes `din`,
`q[1]` takes the old `q[0]`, `q[2]` takes the old `q[1]`. Use **non-blocking**
assignments so the stages actually delay.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk` | input  | 1 | clock |
| `din` | input  | 1 | serial in |
| `q`   | output | 3 | `q[k]` = din delayed k+1 cycles |

## How to approach it
```systemverilog
always_ff @(posedge clk) begin
    q[0] <= din;
    q[1] <= q[0];   // sees OLD q[0] because of non-blocking
    q[2] <= q[1];
end
```

## Common mistakes
- Using `=` (blocking): `q[1]=q[0]` then sees the just-written `q[0]`, so all
  three stages become `din` — the test's staggered delays then fail.
