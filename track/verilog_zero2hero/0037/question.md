# Module instantiation (adder-subtractor)

**Difficulty:** ⭐⭐⭐⭐ · **Topics:** two's complement, XOR trick, hierarchical reuse

## Background
Subtraction reuses the adder: `a - b = a + (~b) + 1`. So a control bit `sub` can
turn an adder into a subtractor by (1) XOR-ing every bit of `b` with `sub` (which
inverts `b` when `sub=1`, leaves it alone when `sub=0`) and (2) feeding `sub` in
as the carry-in. This "adder-subtractor" is a classic building block — and a nice
capstone for instantiation because it wires two adders *plus* a little logic.

## The task
`add16` is **provided in `tb.sv`**. Build `addsub32`: when `sub=0` compute
`a + b`, when `sub=1` compute `a - b`, all 32-bit.

### Sub-module you must instantiate
```systemverilog
module add16 (input [15:0] a, input [15:0] b, input cin,
              output [15:0] sum, output cout);
```

## Interface (your module)
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b` | input  | 32 | operands |
| `sub`    | input  | 1  | 0=add, 1=subtract |
| `sum`    | output | 32 | a+b or a-b |

## How to approach it
```systemverilog
logic [31:0] b_x;
logic carry;
assign b_x = b ^ {32{sub}};                 // invert b when sub=1
add16 u_lo (.a(a[15:0]),  .b(b_x[15:0]),  .cin(sub),   .sum(sum[15:0]),  .cout(carry));
add16 u_hi (.a(a[31:16]), .b(b_x[31:16]), .cin(carry), .sum(sum[31:16]), .cout());
```

## Common mistakes
- Forgetting the `+1` — it comes from `cin = sub`, not a separate adder.
- XOR-ing `b` with just `sub` (1 bit) instead of replicating it to 32 bits
  (`{32{sub}}`).
