# Gray / binary codec (functions)

**Difficulty:** ⭐⭐⭐ · **Topics:** `function`, reuse

## Background
Wrap repeated combinational math in a **`function`** declared in the architecture.
Here we convert between binary and **Gray code** (consecutive values differ in one
bit — handy for clock-domain-crossing pointers).
- binary → Gray: `g = b xor (b srl 1)`, i.e. `b xor ('0' & b(high downto 1))`.
- Gray → binary: MSB copies through, then `b(i) = b(i+1) xor g(i)`.

## The task
Provide both conversions.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `bin`     | in  | std_logic_vector(W-1 downto 0) | binary in |
| `gray_in` | in  | std_logic_vector(W-1 downto 0) | Gray in |
| `gray`    | out | std_logic_vector(W-1 downto 0) | Gray of `bin` |
| `bin_out` | out | std_logic_vector(W-1 downto 0) | binary of `gray_in` |

**Generic:** `W` (default 4)

## How to approach it
```vhdl
function bin2gray(b : std_logic_vector) return std_logic_vector is
begin
    return b xor ('0' & b(b'high downto 1));
end function;

function gray2bin(g : std_logic_vector) return std_logic_vector is
    variable b : std_logic_vector(g'range);
begin
    b(b'high) := g(g'high);
    for i in g'high-1 downto 0 loop b(i) := b(i+1) xor g(i); end loop;
    return b;
end function;
...
gray <= bin2gray(bin);
bin_out <= gray2bin(gray_in);
```

## Common mistakes
- gray2bin is a running XOR from the MSB — a single `g xor (g srl 1)` does not
  invert it.

## VHDL notes
Functions take *unconstrained* vector parameters and use attributes (`'high`,
`'range`) to work at any width — that is what makes them reusable.

## Run it (GHDL)
```bash
ghdl -a --std=08 0020/solution.vhdl 0020/tb.vhdl && ghdl -e --std=08 tb && ghdl -r --std=08 tb
```
