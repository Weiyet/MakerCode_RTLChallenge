# 2-to-1 Multiplexer

**Difficulty:** ⭐⭐ · **Topics:** conditional operator, selection

## Learning objective
Select one of two inputs with a control bit — the fundamental building block of
almost every datapath.

## Problem
Build `mux2to1`: when `sel = 0` the output is `a`; when `sel = 1` it is `b`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `a`   | input  | 1 | data 0 |
| `b`   | input  | 1 | data 1 |
| `sel` | input  | 1 | select |
| `y`   | output | 1 | selected data |

```mermaid
graph LR
    a([a]) --> M{{"MUX"}}
    b([b]) --> M
    sel([sel]) --> M
    M --> y([y])
```

## Truth table
| sel | y |
|-----|---|
| 0   | a |
| 1   | b |

## Hints
- The ternary operator reads naturally: `y = sel ? b : a;`
