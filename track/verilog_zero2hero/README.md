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
This track reuses the repo-root `Makefile` via `include`:
```bash
make sim  QUESTION=5                  # test your interface.sv
make sim  QUESTION=5 DUT=solution.sv  # test the reference solution
make wave QUESTION=5                   # open the waveform in gtkwave
```
A run ends with `test 1: PASS` when correct; any mismatch prints an `ERROR:
...tb.sv` line (same convention as the main `questions/` bank). You can also drive
the tools by hand: `iverilog -g2012 -s tb -o sim NNNN/tb.sv NNNN/solution.sv && vvp sim`.

A machine-readable index of every problem (id, title, difficulty, topics)
is in [`rtl_challenge_db.csv`](rtl_challenge_db.csv).

## Curriculum

### Module 1 — Combinational basics
| # | Problem | Focus |
|---|---------|-------|
| [0000](0000/) | Wires, assign & constants | modules, ports, `assign`, `1'b0/1'b1` |
| [0001](0001/) | Basic gates (incl. NOT) | `~` `&` `|` `^` and negations |
| [0002](0002/) | 2-to-1 multiplexer | ternary select |

### Module 2 — Vectors
| # | Problem | Focus |
|---|---------|-------|
| [0003](0003/) | Part-select & slicing | `[hi:lo]` |
| [0004](0004/) | Reduction operators | `&` `|` `^` reductions |
| [0005](0005/) | Concatenation & replication | `{a,b}`, `{N{x}}` |
| [0006](0006/) | Arrays & bit/byte reverse | `for` loop, byte lanes / endianness |

### Module 3 — Combinational building blocks
| # | Problem | Focus |
|---|---------|-------|
| [0007](0007/) | Half & full adder | sum/carry, carry-in |
| [0008](0008/) | Ripple-carry adder | `generate` / `genvar`, `parameter` |
| [0009](0009/) | 4-to-1 multiplexer | `always_comb` + `case` |
| [0010](0010/) | 2-to-4 decoder | one-hot, enable |
| [0011](0011/) | Priority encoder | `casez`, don't-cares |
| [0012](0012/) | Avoiding inferred latches | `always_comb` completeness, default assignment |
| [0013](0013/) | Tri-state / output-enable | high-impedance `z`, buses |

### Module 4 — SystemVerilog features
| # | Problem | Focus |
|---|---------|-------|
| [0014](0014/) | ALU with enum opcodes | `enum`, status flag |
| [0015](0015/) | Packed struct | `struct packed`, `typedef` |
| [0016](0016/) | Population count | `parameter`, `$clog2` |
| [0017](0017/) | Gray / binary codec | `function automatic` |

### Module 5 — Sequential logic (`always_ff`)
| # | Problem | Focus |
|---|---------|-------|
| [0018](0018/) | D flip-flop | `always_ff`, non-blocking `<=` |
| [0019](0019/) | Reset styles | sync vs async reset |
| [0020](0020/) | Enable & load | clock enable / hold |
| [0021](0021/) | Blocking vs non-blocking | `=` vs `<=` scheduling |
| [0022](0022/) | Shift register (SIPO) | shifting |
| [0023](0023/) | Up/down counter | load / enable priority |
| [0024](0024/) | LFSR | feedback taps, pseudo-random |
| [0025](0025/) | Memory / register file | 2-D arrays, registered read |

### Module 6 — FSMs & the hero
| # | Problem | Focus |
|---|---------|-------|
| [0026](0026/) | Edge detector | one-cycle pulse |
| [0027](0027/) | Sequence detector "1011" | Moore FSM, `enum` states |
| [0028](0028/) | Mealy detector "11" | Mealy vs Moore |
| [0029](0029/) | Switch debouncer | counter + FSM |
| [0030](0030/) | Valid/ready handshake | ready/valid, backpressure |
| [0031](0031/) | **UART transmitter** | FSM + datapath (hero) |

### Module 7 — Hierarchy & module instantiation
The provided sub-module lives in each `tb.sv`; your job is to **instantiate** it
in `interface.sv`. Each `question.md` lists the sub-module's name and ports.

| # | Problem | Focus |
|---|---------|-------|
| [0032](0032/) | Instantiate by position | positional port connection |
| [0033](0033/) | Instantiate by name | `.port(sig)` named connection |
| [0034](0034/) | Parameter override | `#(.WIDTH(...))` parameterized reuse |
| [0035](0035/) | Connecting instances & vectors | wiring instances, vector ports, tap mux |
| [0036](0036/) | Hierarchical adder | build adder32 from two add16, carry chain |
| [0037](0037/) | Adder-subtractor | two's-complement XOR trick + hierarchy |

### Module 8 — Subprograms & `fork` (simulation constructs)
Procedural abstraction and concurrency. `function` and no-time `task`s are
synthesizable; **`fork`/`join*` and time-consuming tasks are simulation-only** —
each `question.md` flags this. Verification knowledge every RTL engineer needs.

| # | Problem | Focus |
|---|---------|-------|
| [0038](0038/) | Functions and tasks | `function` return vs `task` outputs, `automatic` |
| [0039](0039/) | `fork` family | `join` / `join_any` / `join_none`, parallelism |

---
*Difficulty is marked with ⭐ (getting started) up to ⭐⭐⭐⭐⭐ (hero) inside each
`question.md`.*
