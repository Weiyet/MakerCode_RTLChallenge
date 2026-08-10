# Parameters (parameterized population count)

**Difficulty:** ⭐⭐⭐ · **Topics:** `parameter`, `$clog2`, accumulate in `always_comb`

## Background
"Popcount" = how many bits are set. The interesting part is **sizing the output**:
counting `WIDTH` bits gives a value 0..WIDTH, which needs `$clog2(WIDTH+1)` bits.
`$clog2(n)` is the number of bits to represent values `0..n-1`, so using it keeps
the port correct as `WIDTH` changes.

## The task
Return the number of 1s in a `WIDTH`-bit input.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `in`    | input  | WIDTH | data |
| `count` | output | $clog2(WIDTH+1) | number of set bits |

**Parameter:** `WIDTH` (default 8)

## How to approach it
```systemverilog
always_comb begin
    count = '0;
    for (int i = 0; i < WIDTH; i++)
        count += in[i];       // add each bit (0 or 1)
end
```

## Worked example
`WIDTH=8`, `in=8'b1011_0010` → count = 4.

## Common mistakes
- Under-sizing `count` (e.g. `$clog2(WIDTH)` misses the all-ones case = WIDTH).
- Forgetting to clear `count` before accumulating.

## SystemVerilog notes
Adding a 1-bit value to `count` promotes it correctly. `$countones(in)` is a
built-in that does the same in a testbench, but here we build it explicitly.
