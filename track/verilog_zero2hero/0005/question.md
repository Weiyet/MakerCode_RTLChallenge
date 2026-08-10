# Vectors (concatenation & replication)

**Difficulty:** ⭐⭐ · **Topics:** `{a,b}` concat, `{N{x}}` replication

## Background
The braces `{ }` join signals together. **Concatenation** `{a, b}` places `a` in
the more-significant bits and `b` below it, forming a wider vector. **Replication**
`{N{x}}` repeats `x` N times. Together they let you rearrange and pad buses
without any gates — it is pure wiring.

## The task
Given bytes `a` and `b`, build:
- `cat`      = `{a, b}` (16 bits, `a` in the MSBs)
- `rep4`     = four copies of `a` (32 bits)
- `nib_swap` = `a` with its two nibbles swapped

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b`   | input  | 8  | operands |
| `cat`      | output | 16 | `{a,b}` |
| `rep4`     | output | 32 | `{4{a}}` |
| `nib_swap` | output | 8  | `{a[3:0], a[7:4]}` |

## How to approach it
```systemverilog
assign cat      = {a, b};
assign rep4     = {4{a}};
assign nib_swap = {a[3:0], a[7:4]};
```
`nib_swap` reads: "put the low nibble on top, the high nibble on the bottom".

## Worked example
`a = 8'hA5` → `nib_swap = 8'h5A`; `rep4 = 32'hA5A5A5A5`.

## Common mistakes
- Getting the order backwards — the **leftmost** item in `{ }` lands in the MSBs.
- Total width must match the target: `{a,b}` is 16 bits for a 16-bit `cat`.
- Nested braces for replication: it is `{4{a}}`, not `{4 a}` or `{4,a}`.

## SystemVerilog notes
Concatenation and replication compose: `{2{a}, b}` is `{a, a, b}`. This is how you
sign-extend or pad: `{ {8{v[7]}}, v }` sign-extends an 8-bit `v` to 16 bits.
