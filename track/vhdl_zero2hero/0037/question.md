# Component instantiation (adder-subtractor)

**Difficulty:** ⭐⭐⭐⭐ · **Topics:** two's complement, XOR trick, hierarchical reuse

## Background
Subtraction reuses the adder: `a - b = a + (not b) + 1`. So a control bit `sub`
turns an adder into a subtractor by (1) XOR-ing every bit of `b` with `sub` (which
inverts `b` when `sub='1'`, leaves it unchanged when `sub='0'`) and (2) feeding
`sub` in as the carry-in. This "adder-subtractor" is a classic building block, and
a nice capstone for instantiation because it wires two adders *plus* a little
logic.

## The task
`add16` is **provided in `tb.vhdl`**. Build `addsub32`: when `sub='0'` compute
`a + b`, when `sub='1'` compute `a - b`, all 32-bit.

### Sub-entity you must instantiate
```vhdl
entity add16 port (a, b : in  std_logic_vector(15 downto 0);
                   cin  : in  std_logic;
                   sum  : out std_logic_vector(15 downto 0);
                   cout : out std_logic);
```

## Interface (your entity)
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b` | in  | std_logic_vector(31:0) | operands |
| `sub`    | in  | std_logic | '0'=add, '1'=subtract |
| `sum`    | out | std_logic_vector(31:0) | a+b or a-b |

## How to approach it
```vhdl
signal b_x  : std_logic_vector(31 downto 0);
signal carry : std_logic;
...
b_x <= b xor (b'range => sub);         -- invert b when sub='1'
u_lo : add16 port map (a => a(15 downto 0),  b => b_x(15 downto 0),
                       cin => sub,   sum => sum(15 downto 0),  cout => carry);
u_hi : add16 port map (a => a(31 downto 16), b => b_x(31 downto 16),
                       cin => carry, sum => sum(31 downto 16), cout => open);
```

## Common mistakes
- Forgetting the `+1` — it comes from `cin => sub`, not a separate adder.
- XOR-ing `b` with a single bit instead of replicating `sub` across all 32 bits
  (`(b'range => sub)`).
