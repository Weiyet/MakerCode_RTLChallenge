# Vectors (arrays & bit/byte reverse)

**Difficulty:** ⭐⭐ · **Topics:** `for` loop in `always_comb`, byte lanes

## Background
Two everyday vector manipulations: **bit reverse** (flip bit order, done with a
`for` loop) and **byte reverse** (swap byte lanes, i.e. endianness). Both are
combinational and both are cleanly expressed by indexing.

## The task
Build `reverser` for a 32-bit input `d`:
- `bitrev` = `d` with its 32 bits reversed (bit 0 ↔ bit 31, …).
- `byterev` = `d` with its 4 bytes reversed (byte 0 ↔ byte 3, byte 1 ↔ byte 2).

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `d`       | input  | 32 | data in |
| `bitrev`  | output | 32 | bit-reversed |
| `byterev` | output | 32 | byte-lane reversed |

## How to approach it
```systemverilog
always_comb
    for (int i = 0; i < 32; i++)
        bitrev[i] = d[31 - i];

assign byterev = {d[7:0], d[15:8], d[23:16], d[31:24]};
```

## Common mistakes
- Off-by-one in the bit-reverse index (`31 - i`).
- Swapping bytes with the wrong slice boundaries.
