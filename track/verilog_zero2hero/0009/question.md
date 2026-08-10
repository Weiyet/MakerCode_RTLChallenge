# Combinational logic (4-to-1 multiplexer, case)

**Difficulty:** ⭐⭐ · **Topics:** `always_comb`, `case`, parameterized width

## Background
Beyond two inputs, chained ternaries get hard to read. A **`case` statement**
inside `always_comb` is the clear way to describe a mux (and, later, any decoder
or FSM output logic). List every value of the select and, crucially, add a
`default` so every case is covered — otherwise the tool may infer an unwanted
latch.

## The task
Route one of `d0..d3` to `y` based on `sel`, for a parameterized data width `W`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `d0`..`d3` | input  | W | data inputs |
| `sel`      | input  | 2 | select |
| `y`        | output | W | selected data |

**Parameter:** `W` (default 8)

## How to approach it
```systemverilog
always_comb begin
    case (sel)
        2'd0:    y = d0;
        2'd1:    y = d1;
        2'd2:    y = d2;
        default: y = d3;
    endcase
end
```

## Common mistakes
- Omitting `default` (or a case) so some `sel` value leaves `y` unassigned →
  inferred latch. `always_comb` will warn about this.
- Using `<=` inside combinational logic — use blocking `=`.

## SystemVerilog notes
`unique case`/`priority case` add tool checks about overlap/coverage. A plain
`case` with a `default` is the safe everyday choice.
