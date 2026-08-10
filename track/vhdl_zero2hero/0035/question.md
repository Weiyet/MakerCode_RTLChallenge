# Component instantiation (connecting instances & vectors)

**Difficulty:** ⭐⭐⭐ · **Topics:** vector ports on instances, tapping internal nodes

## Background
Sub-entities often carry **vector** ports. Here you chain three 8-bit registers and
add a mux that taps different points along the chain, so `sel` chooses how many
cycles of delay to apply. This mixes instantiation (the three registers) with a
little combinational logic (the tap mux) — a very common RTL pattern.

## The task
`my_dff8` (an 8-bit register) is **provided in `tb.vhdl`**. Build `shift8_mux`:
chain three of them, then select the output with `sel`:
`0` = input `d`, `1` = after 1 stage, `2` = after 2 stages, `3` = after 3.

### Sub-entity you must instantiate
```vhdl
entity my_dff8 port (clk : in std_logic;
                     d   : in  std_logic_vector(7 downto 0);
                     q   : out std_logic_vector(7 downto 0));
```

## Interface (your entity)
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk` | in  | std_logic | clock |
| `d`   | in  | std_logic_vector(7:0) | data in |
| `sel` | in  | std_logic_vector(1:0) | tap select (0..3) |
| `q`   | out | std_logic_vector(7:0) | selected tap |

## How to approach it
```vhdl
signal o1, o2, o3 : std_logic_vector(7 downto 0);
...
a : my_dff8 port map (clk => clk, d => d,  q => o1);
b : my_dff8 port map (clk => clk, d => o1, q => o2);
c : my_dff8 port map (clk => clk, d => o2, q => o3);

with sel select q <=
  d  when "00",
  o1 when "01",
  o2 when "10",
  o3 when others;
```

## Common mistakes
- Feeding each register the same input instead of chaining `o1 -> o2 -> o3`.
- Forgetting `sel="00"` taps the *combinational* input `d` (zero delay).
