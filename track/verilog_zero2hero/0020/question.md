# Gray / binary codec (functions)

**Difficulty:** ⭐⭐⭐ · **Topics:** `function automatic`, reuse

## Background
When repeated combinational math shows up, wrap it in a **`function`**. Functions
have no time (`#`) and return a value, so they synthesize to pure logic and keep
your code DRY. Here we convert between binary and **Gray code**, where consecutive
values differ in exactly one bit — useful for pointers crossing clock domains
(you will see this in real async FIFOs).

- binary → Gray: `g = b ^ (b >> 1)`
- Gray → binary: MSB copies through, then `b[i] = b[i+1] ^ g[i]`

## The task
Provide both conversions.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `bin`     | input  | W | binary in |
| `gray_in` | input  | W | Gray in |
| `gray`    | output | W | Gray of `bin` |
| `bin_out` | output | W | binary of `gray_in` |

**Parameter:** `W` (default 4)

## How to approach it
```systemverilog
function automatic logic [W-1:0] bin2gray(input logic [W-1:0] b);
    return b ^ (b >> 1);
endfunction
function automatic logic [W-1:0] gray2bin(input logic [W-1:0] g);
    logic [W-1:0] b;
    b[W-1] = g[W-1];
    for (int i = W-2; i >= 0; i--) b[i] = b[i+1] ^ g[i];
    return b;
endfunction
assign gray = bin2gray(bin);
assign bin_out = gray2bin(gray_in);
```

## Common mistakes
- gray2bin is a *running* XOR from the MSB down — a single `g ^ (g>>1)` does not
  invert Gray coding.

## SystemVerilog notes
`function automatic` gives each call its own storage (safe for reuse/recursion).
Functions may contain loops and locals but no timing controls.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0020/tb.sv 0020/solution.sv && vvp sim
```
