# Reset styles: synchronous vs asynchronous

**Difficulty:** ⭐⭐⭐ · **Topics:** reset, sensitivity lists

## Learning objective
Compare the two reset styles and their process sensitivity lists.

## Problem
`rst_n` is active-low. Produce two registered copies of `d`:
- `q_sync`  : reset only takes effect **at a clock edge**.
- `q_async` : reset clears **immediately** when `rst_n` falls.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock / active-low reset |
| `d`       | in  | std_logic | data |
| `q_sync`  | out | std_logic | sync-reset register |
| `q_async` | out | std_logic | async-reset register |

## VHDL notes
Async reset lists the reset in the sensitivity list and tests it *before*
`rising_edge`:
`process(clk, rst_n) ... if rst_n='0' then ... elsif rising_edge(clk) then ...`.
Sync reset only lists `clk`.
