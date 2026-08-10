# Combinational logic (4-to-1 multiplexer, case)

**Difficulty:** ⭐⭐ · **Topics:** `process`, `case`, generic width

## Background
Past two inputs, a **`case`** inside a process is the clear way to write a mux (and
later any decoder or FSM output). Cover every choice and end with `when others`,
so no input value is left undefined.

## The task
Route one of `d0..d3` to `y` based on `sel`, width `W`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `d0`..`d3` | in  | std_logic_vector(W-1 downto 0) | data |
| `sel`      | in  | std_logic_vector(1 downto 0) | select |
| `y`        | out | std_logic_vector(W-1 downto 0) | selected |

**Generic:** `W` (default 8)

## How to approach it
```vhdl
process(all)
begin
    case sel is
        when "00"   => y <= d0;
        when "01"   => y <= d1;
        when "10"   => y <= d2;
        when others => y <= d3;
    end case;
end process;
```

## Common mistakes
- Omitting `when others` — a VHDL `case` on `std_logic_vector` must cover all
  patterns; `when others` handles the metavalue combinations too.
- Forgetting `process(all)` / a complete sensitivity list.

## VHDL notes
`process(all)` (VHDL-2008) auto-derives the sensitivity list — ideal for
combinational logic.
