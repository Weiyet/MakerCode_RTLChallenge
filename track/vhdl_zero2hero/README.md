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
This track reuses the repo-root `Makefile` via `include` (it just selects the
native-GHDL path):
```bash
make sim  QUESTION=5                    # test your interface.vhdl
make sim  QUESTION=5 DUT=solution.vhdl  # test the reference solution
make wave QUESTION=5                     # dump a VCD and open gtkwave
```
A correct run prints `test 1: PASS`; a mismatch prints a `report ... severity
error` line. (GHDL `--std=08` is used — several problems rely on VHDL-2008
features such as unary reduction operators and `process(all)`.) You can also drive
GHDL by hand: `ghdl -a --std=08 NNNN/solution.vhdl NNNN/tb.vhdl && ghdl
--elab-run --std=08 tb`.

A machine-readable index of every problem (id, title, difficulty, topics)
is in [`rtl_challenge_db.csv`](rtl_challenge_db.csv).

## Curriculum

### Module 1 — Combinational basics
| # | Problem | Focus |
|---|---------|-------|
| [0000](0000/) | Wires, assign & constants | entity/architecture, `'0'`/`'1'` |
| [0001](0001/) | Basic gates (incl. NOT) | `not`/`and`/`or`/`xor`/`nand`/`nor`/`xnor` |
| [0002](0002/) | 2-to-1 multiplexer | `when ... else` |

### Module 2 — Vectors
| # | Problem | Focus |
|---|---------|-------|
| [0003](0003/) | Slicing with `downto` | part-select |
| [0004](0004/) | Reduction operators | VHDL-2008 unary `and`/`or`/`xor` |
| [0005](0005/) | Concatenation & replication | `&` |
| [0006](0006/) | Arrays & bit/byte reverse | `for` loop, byte lanes / endianness |

### Module 3 — Combinational building blocks
| # | Problem | Focus |
|---|---------|-------|
| [0007](0007/) | Half & full adder | xor/and, carry-in |
| [0008](0008/) | Ripple-carry adder | `for ... generate`, `generic` |
| [0009](0009/) | 4-to-1 multiplexer | `process(all)` + `case` |
| [0010](0010/) | 2-to-4 decoder | `to_integer`, one-hot |
| [0011](0011/) | Priority encoder | priority via `if/elsif` |
| [0012](0012/) | Avoiding inferred latches | process completeness, default assignment |
| [0013](0013/) | Tri-state / output-enable | high-impedance `'Z'`, buses |

### Module 4 — Types, generics, functions
| # | Problem | Focus |
|---|---------|-------|
| [0014](0014/) | ALU with enum opcode | enumerated `type`, `'val` |
| [0015](0015/) | Records | `record`, flatten with `&` |
| [0016](0016/) | Population count | `generic`, `math_real` sizing |
| [0017](0017/) | Gray / binary codec | `function` |

### Module 5 — Sequential logic (clocked processes)
| # | Problem | Focus |
|---|---------|-------|
| [0018](0018/) | D flip-flop | `rising_edge` |
| [0019](0019/) | Reset styles | sync vs async reset |
| [0020](0020/) | Enable & load | clock enable / hold |
| [0021](0021/) | Signal vs variable | `<=` vs `:=` scheduling |
| [0022](0022/) | Shift register (SIPO) | shift with `&` |
| [0023](0023/) | Up/down counter | `unsigned`, load/enable priority |
| [0024](0024/) | LFSR | feedback taps |
| [0025](0025/) | Memory / register file | array `type`, registered read |

### Module 6 — FSMs & the hero
| # | Problem | Focus |
|---|---------|-------|
| [0026](0026/) | Edge detector | one-cycle pulse |
| [0027](0027/) | Sequence detector "1011" | Moore FSM, enumerated states |
| [0028](0028/) | Mealy detector "11" | Mealy vs Moore |
| [0029](0029/) | Switch debouncer | counter + condition |
| [0030](0030/) | Valid/ready handshake | ready/valid, backpressure |
| [0031](0031/) | **UART transmitter** | FSM + datapath (hero) |

### Module 7 — Hierarchy & component instantiation
The provided sub-entity lives in each `tb.vhdl`; your job is to **instantiate** it
in `interface.vhdl` with a `component` declaration + `port map`. Each `question.md`
lists the sub-entity's name and ports.

| # | Problem | Focus |
|---|---------|-------|
| [0032](0032/) | Instantiate by position | positional `port map` |
| [0033](0033/) | Instantiate by name | named `formal => actual` association |
| [0034](0034/) | Generic map | `generic map`, parameterized reuse |
| [0035](0035/) | Connecting instances & vectors | wiring instances, vector ports, `with ... select` tap |
| [0036](0036/) | Hierarchical adder | build adder32 from two add16, carry chain, `open` |
| [0037](0037/) | Adder-subtractor | two's-complement XOR trick + hierarchy |

### Module 8 — Subprograms & concurrency
VHDL has **no `fork`/`join`** — concurrency is native (many processes run in
parallel). These problems teach the VHDL equivalents of the Verilog track's M8.

| # | Problem | Focus |
|---|---------|-------|
| [0038](0038/) | Functions and procedures | `function` return vs `procedure` `out` params |
| [0039](0039/) | Concurrent processes | native parallelism (VHDL's answer to `fork`) |

---
*Difficulty is marked with ⭐ (getting started) up to ⭐⭐⭐⭐⭐ (hero) inside each
`question.md`.*
