# Component instantiation (generic map)

**Difficulty:** ⭐⭐⭐ · **Topics:** `generic map`, parameterized reuse

## Background
A **generic** makes an entity a template: one description, many widths. When you
instantiate it you supply the value with a **`generic map`** so each copy is sized
for its job — the VHDL equivalent of Verilog's `#(.WIDTH(...))`.

## The task
A parameterized register `wide_reg` (generic `WIDTH`) is **provided in `tb.vhdl`**.
Instantiate it **twice** inside `param_inst`: once at **WIDTH=4** for the `d4→q4`
path, once at **WIDTH=12** for the `d12→q12` path.

### Sub-entity you must instantiate
```vhdl
entity wide_reg generic(WIDTH : integer := 8)
  port(clk : in std_logic;
       d   : in  std_logic_vector(WIDTH-1 downto 0);
       q   : out std_logic_vector(WIDTH-1 downto 0));
```

## Interface (your entity)
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk` | in  | std_logic | clock |
| `d4`  | in  | std_logic_vector(3:0)  | 4-bit in |
| `q4`  | out | std_logic_vector(3:0)  | 4-bit out (1-cycle delay) |
| `d12` | in  | std_logic_vector(11:0) | 12-bit in |
| `q12` | out | std_logic_vector(11:0) | 12-bit out (1-cycle delay) |

## How to approach it
```vhdl
u4  : wide_reg generic map (WIDTH => 4)  port map (clk => clk, d => d4,  q => q4);
u12 : wide_reg generic map (WIDTH => 12) port map (clk => clk, d => d12, q => q12);
```

## Common mistakes
- Omitting the `generic map` — the instance defaults to WIDTH=8 and the port
  widths mismatch `d4`/`d12`.
