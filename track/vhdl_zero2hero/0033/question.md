# Component instantiation (by name)

**Difficulty:** ⭐⭐ · **Topics:** named `port map` association

## Background
A **named** `port map` — `formal => actual` — is the robust way to instantiate.
Order no longer matters, every connection is explicit, and reordering the
sub-entity's ports cannot silently mis-wire your instance. Real VHDL uses named
association almost exclusively.

## The task
Instantiate the same provided `mod_a` (defined in `tb.vhdl`), but connect every
port **by name**.

### Sub-entity you must instantiate
```vhdl
entity mod_a port (out1, out2 : out std_logic;
                   a, b, c, d : in  std_logic);
```

## Interface (your entity)
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b`, `c`, `d` | in  | std_logic | data |
| `out1`, `out2`     | out | std_logic | from `mod_a` |

## How to approach it
```vhdl
u_a : mod_a port map (a => a, b => b, c => c, d => d,
                      out1 => out1, out2 => out2);
```
Because it is named, the associations may appear in any order.

## Common mistakes
- Typo in a formal name — the analyzer flags an unknown port (the safety named
  association buys you).
- Leaving a port unassociated by accident (use `open` deliberately if intended).

## VHDL notes
`formal => actual`: the *formal* (left) is the component's port; the *actual*
(right) is your local signal.
