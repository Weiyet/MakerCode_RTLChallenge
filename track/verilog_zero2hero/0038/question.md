# Subprograms (functions & tasks)

**Difficulty:** ⭐⭐⭐ · **Topics:** `function`, `task`, `automatic`, output arguments

## Background
As designs grow you want to name and reuse a piece of computation. SystemVerilog
gives you two tools:

- **`function`** — computes and **returns a single value**, may **not consume
  simulation time** (no `#`, no `@`). Great for pure combinational helpers.
- **`task`** — a procedure that can have **many `output`/`inout` arguments** and
  (unlike a function) **may consume time**. Used for multi-result helpers and, in
  testbenches, for timed stimulus sequences.

Mark them `automatic` so each call gets its own local storage (the safe default;
required for reentrant/recursive use).

> **Synthesizable?** The *pure* forms used here — a function, and a task with no
> `#`/`@` — **are** synthesizable. A task that consumes time (later problems, and
> `fork`) is **simulation-only**.

## The task
Build `stats`. Using a **`function`** compute `mx = max(a, b)`, and using a
**`task` with two outputs** compute `sum = a + b` (9-bit) and
`absdiff = |a - b|`. Call both from a single `always_comb`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`, `b` | input  | 8 | operands |
| `mx`      | output | 8 | max(a,b), via a `function` |
| `sum`     | output | 9 | a+b, via a `task` output |
| `absdiff` | output | 8 | \|a-b\|, via a `task` output |

## How to approach it
```systemverilog
function automatic logic [7:0] get_max(input logic [7:0] x, y);
    get_max = (x > y) ? x : y;         // return value = function name
endfunction

task automatic sum_absdiff(input logic [7:0] x, y,
                           output logic [8:0] s, output logic [7:0] ad);
    s  = x + y;
    ad = (x > y) ? (x - y) : (y - x);
endtask

always_comb begin
    mx = get_max(a, b);
    sum_absdiff(a, b, sum, absdiff);   // a task call is a statement, not an expr
endmodule
```

## Common mistakes
- Trying to `return` two values from a function — use a **task** with `output`s.
- Calling a task where an expression is expected (`x = my_task(...)`). A task call
  is a *statement*.
- Forgetting `automatic`, which can cause shared-state bugs on reentrant calls.
