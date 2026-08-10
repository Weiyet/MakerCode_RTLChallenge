# Component instantiation (by position)

**Difficulty:** ⭐⭐ · **Topics:** hierarchy, `component`, positional `port map`

## Background
Real designs are **hierarchical**: small entities are wired together inside bigger
ones. Placing a copy of an entity inside another is **instantiation** — the core
RTL skill. In VHDL you declare a `component` matching the sub-entity, then create
an instance with a labelled `port map`.

With a **positional** `port map` you list the signals in the *same order* as the
component's port declaration, so the order must match exactly.

## The task
The sub-entity `mod_a` is **provided in `tb.vhdl`** (do not redefine it). Write the
architecture of `inst_by_position` so it computes `out1`/`out2` by instantiating
`mod_a` with a **positional** `port map`.

### Sub-entity you must instantiate
```vhdl
entity mod_a port (out1, out2 : out std_logic;
                   a, b, c, d : in  std_logic);
```
(port order: `out1, out2, a, b, c, d`)

## Interface (your entity)
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b`, `c`, `d` | in  | std_logic | data |
| `out1`, `out2`     | out | std_logic | from `mod_a` |

## How to approach it
```vhdl
architecture rtl of inst_by_position is
  component mod_a
    port (out1, out2 : out std_logic; a, b, c, d : in std_logic);
  end component;
begin
  u_a : mod_a port map (out1, out2, a, b, c, d);  -- positional
end architecture rtl;
```

## Common mistakes
- Wrong order in a positional `port map` — it silently mis-wires.
- Forgetting the `component` declaration before `begin`.

## VHDL notes
Default binding connects the `component` to the entity `work.mod_a` of the same
name at elaboration — no explicit `configuration` needed here.
