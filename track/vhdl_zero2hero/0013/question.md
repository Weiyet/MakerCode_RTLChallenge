# Combinational logic (tri-state / output-enable)

**Difficulty:** ⭐⭐⭐ · **Topics:** high-impedance `'Z'`, output enable, buses

## Background
`std_logic` includes the value **`'Z'`** (high-impedance). A tri-state output is
driven with data when its **output-enable** is asserted, and released to all-`'Z'`
otherwise — that is how several drivers share a bus.

## The task
Build `tristate_buf`: when `oe='1'`, drive `dout = din`; when `oe='0'`, drive
`dout` to all-`'Z'`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `oe`   | in  | std_logic | output enable |
| `din`  | in  | std_logic_vector(7:0) | data |
| `dout` | out | std_logic_vector(7:0) | `din` when `oe`, else `'Z'` |

## How to approach it
```vhdl
dout <= din when oe = '1' else (others => 'Z');
```

## VHDL notes
`(others => 'Z')` builds an all-`Z` vector of the target width.
