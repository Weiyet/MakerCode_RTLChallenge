# Vectors (arrays & bit/byte reverse)

**Difficulty:** ⭐⭐ · **Topics:** `for` loop in a process, byte lanes

## Background
Two everyday manipulations: **bit reverse** (flip bit order via a `for` loop) and
**byte reverse** (swap byte lanes, i.e. endianness), both combinational.

## The task
For a 32-bit input `d`: `bitrev` = bits of `d` reversed; `byterev` = the 4 bytes
of `d` reversed.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d`       | in  | std_logic_vector(31:0) | data in |
| `bitrev`  | out | std_logic_vector(31:0) | bit-reversed |
| `byterev` | out | std_logic_vector(31:0) | byte-lane reversed |

## How to approach it
```vhdl
process(all) begin
  for i in 0 to 31 loop
    bitrev(i) <= d(31 - i);
  end loop;
end process;

byterev <= d(7 downto 0) & d(15 downto 8) & d(23 downto 16) & d(31 downto 24);
```

## VHDL notes
`&` concatenates; slices use `downto`. The loop variable `i` is implicitly declared.
