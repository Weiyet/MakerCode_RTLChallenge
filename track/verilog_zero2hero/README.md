# Verilog / SystemVerilog — Zero → Hero

A guided, self-checking practice track that takes you from a single wire to a
working UART transmitter. It is inspired by [HDLBits](https://hdlbits.01xz.net/)
but goes further on **SystemVerilog** style (`logic`, `always_comb`/`always_ff`,
`enum`, `struct`, `typedef`, `generate`, parameters, FSMs) and ships a
self-checking testbench with every problem.

## How each problem is organised
Every folder `NNNN/` contains:

| file | purpose |
|------|---------|
| `question.md`  | the task, interface table, a diagram, hints, and a short "SystemVerilog notes" tip |
| `interface.sv` | the empty module skeleton — **write your answer here** |
| `solution.sv`  | a reference solution |
| `tb.sv`        | a self-checking testbench that prints `Test PASS` or `$error`s |

## How to run (Icarus Verilog)
```bash
# check your own answer
iverilog -g2012 -s tb -o sim NNNN/tb.sv NNNN/interface.sv && vvp sim
# or check the reference solution
iverilog -g2012 -s tb -o sim NNNN/tb.sv NNNN/solution.sv && vvp sim
```
A run ends with `Test PASS` when correct; any mismatch prints an `ERROR: ...tb.sv`
line (same convention as the main `questions/` bank).

## Curriculum

### Module 1 — Gates & wires
| # | Problem | Focus |
|---|---------|-------|
| [0000](0000/) | Wire | modules, ports, `assign`, `logic` |
| [0001](0001/) | Constants | literals, constant drivers |
| [0002](0002/) | Inverter (NOT) | bitwise `~` |
| [0003](0003/) | Basic logic gates | `&` `|` `^` and negations |
| [0004](0004/) | 2-to-1 mux | ternary select |

### Module 2 — Vectors & SystemVerilog data types
| # | Problem | Focus |
|---|---------|-------|
| [0005](0005/) | Vector split | part-select `[hi:lo]` |
| [0006](0006/) | Reduction operators | `&` `|` `^` reductions |
| [0007](0007/) | Concatenation & replication | `{a,b}`, `{N{x}}` |
| [0008](0008/) | Vector reverse | `for` loop in `always_comb` |
| [0009](0009/) | Byte reverse | packed vs unpacked arrays |

### Module 3 — Combinational building blocks
| # | Problem | Focus |
|---|---------|-------|
| [0010](0010/) | Half adder | sum/carry from gates |
| [0011](0011/) | Full adder | carry logic |
| [0012](0012/) | Ripple-carry adder | `generate` / `genvar`, `parameter` |
| [0013](0013/) | 4-to-1 mux | `always_comb` + `case` |
| [0014](0014/) | 2-to-4 decoder | one-hot, enable |
| [0015](0015/) | Priority encoder | `casez`, don't-cares |
| [0016](0016/) | BCD to 7-segment | look-up `case` |

### Module 4 — SystemVerilog features
| # | Problem | Focus |
|---|---------|-------|
| [0017](0017/) | ALU with enum opcodes | `enum`, status flag |
| [0018](0018/) | Packed struct | `struct packed`, `typedef` |
| [0019](0019/) | Population count | `parameter`, `$clog2` |
| [0020](0020/) | Gray / binary codec | `function automatic` |

### Module 5 — Sequential logic (`always_ff`)
| # | Problem | Focus |
|---|---------|-------|
| [0021](0021/) | D flip-flop | `always_ff`, non-blocking `<=` |
| [0022](0022/) | Reset styles | sync vs async reset |
| [0023](0023/) | Enabled register | clock enable / hold |
| [0024](0024/) | Shift register (SIPO) | shifting |
| [0025](0025/) | Up/down counter | load / enable priority |
| [0026](0026/) | LFSR | feedback taps, pseudo-random |

### Module 6 — FSMs & the hero
| # | Problem | Focus |
|---|---------|-------|
| [0027](0027/) | Edge detector | one-cycle pulse |
| [0028](0028/) | Sequence detector "1011" | Moore FSM, `enum` states |
| [0029](0029/) | Mealy detector "11" | Mealy vs Moore |
| [0030](0030/) | Switch debouncer | counter + FSM |
| [0031](0031/) | **UART transmitter** | FSM + datapath (hero) |

---
*Difficulty is marked with ⭐ (getting started) up to ⭐⭐⭐⭐⭐ (hero) inside each
`question.md`.*
