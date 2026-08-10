# Constants

**Difficulty:** ⭐ · **Topics:** literals, concurrent assignment

## Learning objective
Drive fixed logic values onto outputs.

## Problem
`zero` is always `'0'`; `one` is always `'1'`.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `zero` | out | std_logic | constant 0 |
| `one`  | out | std_logic | constant 1 |

## VHDL notes
A single-bit literal is written with single quotes: `'0'`, `'1'`. Multi-bit
literals use double quotes: `"1010"`.
