# VHDL — Zero → Hero

A guided, self-checking practice track that takes you from a single wire to a
working UART transmitter — the VHDL sibling of [`verilog_zero2hero`](../verilog_zero2hero/).
It emphasises idiomatic **VHDL-2008**: `std_logic`/`std_logic_vector`,
`process`, `generic`, `record`, enumerated `type`s, `function`s, `for ... generate`
and finite state machines. Every problem ships a self-checking VHDL testbench.

> **Reserved words:** `in` and `out` are VHDL keywords, so data ports use names
> like `d`/`y`/`a`/`code` instead. Each `question.md` states its exact ports.

## How each problem is organised
Every folder `NNNN/` contains:

| file | purpose |
|------|---------|
| `question.md`   | the task, interface table, a diagram, and a "VHDL notes" tip |
| `interface.vhdl`| the empty entity/architecture skeleton — **write your answer here** |
| `solution.vhdl` | a reference solution |
| `tb.vhdl`       | a self-checking testbench that reports `Test PASS` or errors |

## How to run (GHDL)
```bash
# check the reference solution (or swap in interface.vhdl once you fill it in)
ghdl -a --std=08 NNNN/solution.vhdl NNNN/tb.vhdl
ghdl -e --std=08 tb
ghdl -r --std=08 tb
```
A correct run prints `Test PASS`; a mismatch prints a `report ... severity error`
line. (`--std=08` is required — several problems use VHDL-2008 features such as
unary reduction operators and `process(all)`.)

## Curriculum

### Module 1 — Gates & wires
| # | Problem | Focus |
|---|---------|-------|
| [0000](0000/) | Wire | entity/architecture, concurrent assign |
| [0001](0001/) | Constants | `'0'`/`'1'` literals |
| [0002](0002/) | Inverter (NOT) | `not` |
| [0003](0003/) | Basic logic gates | `and`/`or`/`xor`/`nand`/`nor`/`xnor` |
| [0004](0004/) | 2-to-1 mux | `when ... else` |

### Module 2 — Vectors & types
| # | Problem | Focus |
|---|---------|-------|
| [0005](0005/) | Vector split | slicing with `downto` |
| [0006](0006/) | Reduction operators | VHDL-2008 unary `and`/`or`/`xor` |
| [0007](0007/) | Concatenation & replication | `&` |
| [0008](0008/) | Vector reverse | `process` + `for` loop |
| [0009](0009/) | Byte reverse | array `type` |

### Module 3 — Combinational building blocks
| # | Problem | Focus |
|---|---------|-------|
| [0010](0010/) | Half adder | xor/and |
| [0011](0011/) | Full adder | carry logic |
| [0012](0012/) | Ripple-carry adder | `for ... generate`, `generic` |
| [0013](0013/) | 4-to-1 mux | `process(all)` + `case` |
| [0014](0014/) | 2-to-4 decoder | `to_integer`, one-hot |
| [0015](0015/) | Priority encoder | priority via `if/elsif` |
| [0016](0016/) | BCD to 7-segment | `case` look-up |

### Module 4 — Types, records, generics, functions
| # | Problem | Focus |
|---|---------|-------|
| [0017](0017/) | ALU with enum opcode | enumerated `type`, `'val` |
| [0018](0018/) | Records | `record`, flatten with `&` |
| [0019](0019/) | Population count | `generic`, `math_real` sizing |
| [0020](0020/) | Gray / binary codec | `function` |

### Module 5 — Sequential logic (clocked processes)
| # | Problem | Focus |
|---|---------|-------|
| [0021](0021/) | D flip-flop | `rising_edge` |
| [0022](0022/) | Reset styles | sync vs async reset |
| [0023](0023/) | Enabled register | clock enable / hold |
| [0024](0024/) | Shift register (SIPO) | shift with `&` |
| [0025](0025/) | Up/down counter | `unsigned`, load/enable priority |
| [0026](0026/) | LFSR | feedback taps |

### Module 6 — FSMs & the hero
| # | Problem | Focus |
|---|---------|-------|
| [0027](0027/) | Edge detector | one-cycle pulse |
| [0028](0028/) | Sequence detector "1011" | Moore FSM, enumerated states |
| [0029](0029/) | Mealy detector "11" | Mealy vs Moore |
| [0030](0030/) | Switch debouncer | counter + condition |
| [0031](0031/) | **UART transmitter** | FSM + datapath (hero) |

---
*Difficulty is marked with ⭐ (getting started) up to ⭐⭐⭐⭐⭐ (hero) inside each
`question.md`.*
