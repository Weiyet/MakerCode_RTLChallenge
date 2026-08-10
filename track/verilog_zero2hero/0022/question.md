# Reset styles: synchronous vs asynchronous

**Difficulty:** ⭐⭐⭐ · **Topics:** reset, sensitivity lists

## Learning objective
See the two common reset styles side by side and how their sensitivity lists
differ.

## Problem
`rst_n` is an active-low reset. Produce two registered copies of `d`:
- `q_sync`  : **synchronous** reset — only reacts to reset at a clock edge.
- `q_async` : **asynchronous** reset — clears immediately when `rst_n` falls.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`     | input  | 1 | clock |
| `rst_n`   | input  | 1 | active-low reset |
| `d`       | input  | 1 | data |
| `q_sync`  | output | 1 | sync-reset register |
| `q_async` | output | 1 | async-reset register |

## Hints
- Sync:  `always_ff @(posedge clk)` then `if (!rst_n) ... else ...`
- Async: `always_ff @(posedge clk or negedge rst_n)` then `if (!rst_n) ... else ...`

## SystemVerilog notes
The reset appears in the sensitivity list *only* for asynchronous reset. Pick one
style per project and stay consistent.
