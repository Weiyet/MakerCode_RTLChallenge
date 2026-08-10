# Sequential logic (memory / register file)

**Difficulty:** ⭐⭐⭐ · **Topics:** 2-D arrays, synchronous write, registered read

## Background
On-chip memory (a RAM or register file) is a **2-D array** of registers with a
**write port** (write `wdata` to `mem[addr]` when `we`) and a **read port**. A
*synchronous* RAM registers the read too, so `rdata` appears **one cycle after**
the address — a common source of off-by-one bugs.

## The task
Build `ram` (parameterized `AW`, `DW`): on each clock, if `we` write
`wdata` to `mem[addr]`; and always register `mem[addr]` into `rdata` (so reads
have one cycle of latency).

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`   | input  | 1 | clock |
| `we`    | input  | 1 | write enable |
| `addr`  | input  | AW | address |
| `wdata` | input  | DW | write data |
| `rdata` | output | DW | `mem[addr]`, registered (1-cycle latency) |

## How to approach it
```systemverilog
logic [DW-1:0] mem [0:(1<<AW)-1];
always_ff @(posedge clk) begin
    if (we) mem[addr] <= wdata;
    rdata <= mem[addr];        // registered read
end
```

## Common mistakes
- Driving `rdata` combinationally (`assign rdata = mem[addr]`) — that is a
  *different* memory (asynchronous read); this problem wants the registered read.
- Read-during-write to the same address returns the **old** data here (write and
  read both sample at the edge).
