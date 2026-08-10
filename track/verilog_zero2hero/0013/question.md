# Combinational logic (tri-state / output-enable)

**Difficulty:** ⭐⭐⭐ · **Topics:** high-impedance `z`, output enable, buses

## Background
A **tri-state** output can be driven high, low, or released to **high-impedance**
(`z`). This is how several drivers share one bus: only the driver whose
**output-enable** is asserted drives, the others go `z`. Model it with a
conditional: `dout = oe ? din : 'z`.

## The task
Build `tristate_buf`: when `oe` is 1, drive `dout = din`; when `oe` is 0, release
`dout` to high-impedance (`8'bz`).

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `oe`   | input  | 1 | output enable |
| `din`  | input  | 8 | data |
| `dout` | output | 8 | `din` when `oe`, else `z` |

## How to approach it
```systemverilog
assign dout = oe ? din : 8'bz;
```

## Common mistakes
- Driving `0` instead of `z` when disabled — that would fight other bus drivers.
- Comparing to `z` with `==` in a testbench (use `===`, which matches `x`/`z`).
