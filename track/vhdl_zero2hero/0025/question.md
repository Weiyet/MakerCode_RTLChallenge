# Sequential logic (memory / register file)

**Difficulty:** ⭐⭐⭐ · **Topics:** array types, synchronous write, registered read

## Background
On-chip memory is an **array** of vectors with a **write port** (write `wdata` to
`mem(addr)` when `we`) and a **read port**. A *synchronous* RAM registers the read,
so `rdata` appears **one cycle after** the address — a classic off-by-one trap.

## The task
Build `ram` (generics `AW`, `DW`): each clock, if `we` write `wdata` to
`mem(addr)`; and always register `mem(addr)` into `rdata` (1-cycle read latency).

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`   | in  | std_logic | clock |
| `we`    | in  | std_logic | write enable |
| `addr`  | in  | std_logic_vector(AW-1:0) | address |
| `wdata` | in  | std_logic_vector(DW-1:0) | write data |
| `rdata` | out | std_logic_vector(DW-1:0) | `mem(addr)`, registered |

## How to approach it
```vhdl
type mem_t is array (0 to 2**AW - 1) of std_logic_vector(DW-1 downto 0);
signal mem : mem_t;
...
process(clk) begin
  if rising_edge(clk) then
    if we = '1' then mem(to_integer(unsigned(addr))) <= wdata; end if;
    rdata <= mem(to_integer(unsigned(addr)));    -- registered read
  end if;
end process;
```

## Common mistakes
- Driving `rdata` with a concurrent assignment (asynchronous read) — that is a
  different memory; here the read is registered.
- Forgetting `use ieee.numeric_std.all;` for `unsigned`/`to_integer`.
