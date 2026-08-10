# Subprograms (functions & procedures)

**Difficulty:** ⭐⭐⭐ · **Topics:** `function`, `procedure`, `out` parameters

## Background
VHDL gives you two subprograms to name and reuse computation:

- **`function`** — takes inputs and **returns a single value**. It is *pure*: no
  signal assignments, and (in a function used like this) no waiting. Perfect for
  combinational helpers. This is the VHDL cousin of a Verilog `function`.
- **`procedure`** — a subprogram that can have **`in` / `out` / `inout`
  parameters** (so it can produce *several* results) and may even contain `wait`.
  It is the VHDL cousin of a Verilog `task`.

> **VHDL note:** VHDL has **no `fork`/`join`** — concurrency is expressed with
> multiple concurrent processes instead (see the next problem). Functions and
> simple procedures like these are fully synthesizable.

## The task
Build `stats`. Use a **`function`** to compute `mx = max(a, b)`, and a
**`procedure`** with two `out` parameters to compute `sum = a + b` (9-bit) and
`absdiff = |a - b|`. Call both inside a single `process(all)`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `a`, `b` | in  | std_logic_vector(7:0) | operands |
| `mx`      | out | std_logic_vector(7:0) | max(a,b), via a `function` |
| `sum`     | out | std_logic_vector(8:0) | a+b, via a `procedure` out |
| `absdiff` | out | std_logic_vector(7:0) | \|a-b\|, via a `procedure` out |

## How to approach it
```vhdl
function get_max(x, y : unsigned(7 downto 0)) return unsigned is
begin
  if x > y then return x; else return y; end if;
end function;

procedure sum_absdiff(x, y : in  unsigned(7 downto 0);
                      s     : out unsigned(8 downto 0);
                      ad    : out unsigned(7 downto 0)) is
begin
  s := resize(x, 9) + resize(y, 9);
  if x > y then ad := x - y; else ad := y - x; end if;
end procedure;
...
process(all)
  variable vs : unsigned(8 downto 0);
  variable vad : unsigned(7 downto 0);
begin
  mx <= std_logic_vector(get_max(unsigned(a), unsigned(b)));
  sum_absdiff(unsigned(a), unsigned(b), vs, vad);   -- out params fill variables
  sum <= std_logic_vector(vs);
  absdiff <= std_logic_vector(vad);
end process;
```

## Common mistakes
- Trying to return two results from a `function` — use a `procedure` with `out`s.
- Assigning to a signal directly inside a `function` (not allowed) — a function
  only *returns*.
- Forgetting to `resize` before the 9-bit `sum` add.
