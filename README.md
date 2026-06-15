<p align="center">
  <img src="asset/MakerCode_RTLChallenge_logo.png" alt="MakerCode RTL Challenge">
</p>

# MakerCode RTL Challenge

A collection of **101 self-contained digital-design (RTL) challenges** you can
solve and test entirely offline. Each challenge gives you a problem description,
an empty module template, and a testbench. You write the hardware; a one-command
`make` compiles it, runs the testbench, and tells you PASS/FAIL — plus a waveform
you can inspect.

Templates are provided in **SystemVerilog/Verilog, VHDL, and TL-Verilog**, so you
can solve in whichever language you like.

You can also try the same questions set on our official website with online IDE https://makercode.jixiao-ai.com/

---

## How it works

1. Pick a challenge (e.g. `0005`) and read its `question.md`.
2. Open that challenge's template and implement your design:
   - `interface.sv`  (SystemVerilog / Verilog) — the default
   - `interface.vhdl` (VHDL)
   - `interface.tlv` (TL-Verilog)
3. Run it:
   ```bash
   make sim QUESTION=5
   ```
4. The Makefile compiles your design together with the challenge's `tb.sv` using
   **Icarus Verilog**, runs the simulation (once per parameter set in
   `input_vector.txt`), and reports each test as PASS/FAIL. Logs and waveforms
   are written **into the challenge folder** (`0005/sim_1.log`, `0005/test_1.vcd`, …).
5. Open a waveform to debug:
   ```bash
   make wave QUESTION=5          # opens 0005/test_1.vcd in GTKWave
   ```

A test FAILS if the testbench reports an error (`ERROR: ...tb.sv`); otherwise it
PASSES. `make sim` exits non-zero if any test fails, so it works in CI too.

---

## Install

**Required:** [Icarus Verilog](https://steveicarus.github.io/iverilog/) (`iverilog` + `vvp`).

| OS | Command |
|----|---------|
| Ubuntu/Debian | `sudo apt-get install iverilog` |
| macOS (Homebrew) | `brew install icarus-verilog` |
| Windows | Use **WSL** and follow the Ubuntu steps (recommended), or install from <http://bleyer.org/icarus/> |

**Optional** (only if you use that language / feature):

| Tool | Needed for | Install |
|------|-----------|---------|
| `gtkwave` | `make wave` (view waveforms) | `apt-get install gtkwave` / `brew install gtkwave` |
| `vhd2vl` | solving in **VHDL** | `git clone https://github.com/ldoolitt/vhd2vl && cd vhd2vl/src && make && sudo cp vhd2vl /usr/local/bin/` |
| `sandpiper-saas` | solving in **TL-Verilog** | `pip install sandpiper-saas` |

You only need `iverilog` for SystemVerilog/Verilog challenges.

---

## Running the Makefile

```bash
make sim  QUESTION=5                  # solve 0005 in SystemVerilog (interface.sv)
make sim  QUESTION=5 LANGUAGE=VHDL    # use interface.vhdl  (needs vhd2vl)
make sim  QUESTION=5 LANGUAGE=TLV     # use interface.tlv   (needs sandpiper-saas)
make sim  QUESTION=5 DUT=solution.sv  # run a specific file (e.g. the reference)
make wave QUESTION=5 [TEST=2]         # open 0005/test_<k>.vcd in GTKWave
make clean                           # remove all generated logs/waveforms
```

| Variable | Default | Meaning |
|----------|---------|---------|
| `QUESTION` | `0` | Challenge number; `5`, `05`, and `0005` all mean `0005` |
| `LANGUAGE` | `SV` | `SV`/`VERILOG`, `VHDL`, or `TLV` — selects which `interface.*` to use |
| `DUT` | _(template)_ | Override the design file to simulate (e.g. `DUT=solution.sv`) |
| `TEST` | `1` | Which test's waveform `make wave` opens |

### What `make sim` produces (inside the challenge folder)

| File | Description |
|------|-------------|
| `sim_N.log` | Simulation log for test N (the testbench's output) |
| `test_N.vcd` | Waveform for test N (open with `make wave`) |
| `compile_N.log` | Compiler output for test N (warnings/errors; may be empty) |
| `dut.sv` | Generated Verilog (VHDL/TL-Verilog only — what was actually simulated) |

These are throwaway outputs; `make clean` deletes them and `.gitignore` keeps
them out of version control.

---

## Repository layout

```
.
├── Makefile               # the offline test runner (make sim / wave / clean)
├── update_csv.py          # records your per-language progress into the CSV
├── rtl_challenge_db.csv   # challenge index + your progress (SV/VHDL/TLV columns)
├── README.md              # this file
└── 0000 ... 0100/         # one folder per challenge
    ├── question.md        # the problem description (read this first)
    ├── interface.sv       # SystemVerilog/Verilog template  <-- edit this
    ├── interface.vhdl     # VHDL template                   <-- or this
    ├── interface.tlv      # TL-Verilog template             <-- or this
    ├── tb.sv              # the testbench (do NOT edit)
    ├── input_vector.txt   # parameter sets the testbench is run with
    ├── solution.sv        # reference answer, SystemVerilog (try before you peek!)
    ├── solution.vhdl      # reference answer, VHDL  (placeholder / WIP)
    └── solution.tlv       # reference answer, TL-Verilog  (placeholder / WIP)
```

### File meanings

- **`interface.sv` / `interface.vhdl` / `interface.tlv`** — the module/entity you
  must implement. Ports are fixed by the testbench; fill in the body. Edit **one**
  of these (matching your `LANGUAGE`). This is the only file you change.
- **`tb.sv`** — the testbench that drives your design and checks its outputs. It
  is what decides PASS/FAIL; treat it as read-only.
- **`input_vector.txt`** — the parameter sweep. The first line lists parameter
  names; each following line is one set of values. The Makefile runs the
  testbench once per line (e.g. at `DATA_WIDTH=8`, `16`, `32`). If a challenge
  has no parameters, this file may be absent and a single run uses the defaults.
- **`solution.sv`** — a working reference implementation, so you can compare or
  unblock yourself. Run it with `make sim QUESTION=n DUT=solution.sv`.
  (`solution.vhdl` / `solution.tlv` are placeholders for now.)
- **`question.md`** — the spec: interface, behaviour, and a worked example
  (often with a WaveDrom timing diagram).
- **`update_csv.py`** — records your progress into the CSV (see below).

---

## Track your progress

When **all tests pass**, `make sim` drops a marker file in that question's folder
named `PASS_SV`, `PASS_VHDL`, or `PASS_TLV` (depending on `LANGUAGE`). Then run:

```bash
python3 update_csv.py
```

to sweep every folder and fill the **`SV` / `VHDL` / `TLV`** columns of
`rtl_challenge_db.csv` with `PASS` where you've solved it:

```
ID,Title,Difficulty,SV,VHDL,TLV
0000,Simple 2-Input Parametizable Adder,Easy,PASS,,
```

Re-run it any time to refresh. Marker files are git-ignored — they're just your
local progress.

---

## Tips

- Start from the template's port list — never change the port names/widths, only
  add the logic inside the module.
- Read `question.md` carefully for reset polarity, timing (combinational vs
  registered), and any handshake (`valid`/`ready`) protocol.
- If a test fails, open `sim_N.log` for the testbench's error message and
  `make wave QUESTION=n TEST=N` to see exactly where the waveform diverges.

---

## Challenge list

| ID | Title | Difficulty |
|----|-------|------------|
| 0000 | Simple 2-Input Parametizable Adder | Easy |
| 0001 | Simple 2-Input Parametizable Subtractor | Easy |
| 0002 | Simple 2-Input Parametizable Multiplier | Easy |
| 0003 | Ring Counter | Easy |
| 0004 | Ripple Counter | Easy |
| 0005 | Parametizable Sequence Pattern Detector | Medium |
| 0006 | Dual Edge Flip Flop | Hard |
| 0007 | Parametizable Mux | Medium |
| 0008 | D flip-flop | Easy |
| 0009 | Dual Edge Detector | Easy |
| 0010 | Simple ALU | Easy |
| 0011 | Odd Counter | Easy |
| 0012 | Shift Register | Easy |
| 0013 | LFSR | Medium |
| 0014 | Binary to One-hot | Easy |
| 0015 | Binary to Grey | Easy |
| 0016 | Self reloading counter | Easy |
| 0017 | PISO Parallel in Serial out | Easy |
| 0018 | Parametizable Binary to One-Hot Encoder | Easy |
| 0019 | Priority Encoder | Easy |
| 0020 | Fixed Priority Arbiter | Medium |
| 0021 | Round Robin Arbiter | Medium |
| 0022 | Stopwatch Timer | Hard |
| 0023 | Simple Memory Interface | Medium |
| 0024 | Binary to BCD Converter | Medium |
| 0025 | Synchronous FIFO | Medium |
| 0026 | 7-Segment Display Driver | Easy |
| 0027 | Bidirectional Counter | Medium |
| 0028 | SIPO Serial In Parallel Out | Easy |
| 0029 | Universal Shift Register | Easy |
| 0030 | Synchronous LIFO | Medium |
| 0031 | Johnson Counter | Medium |
| 0032 | Clock Divider | Easy |
| 0033 | Asynchronous FIFO | Hard |
| 0034 | Gray Code Counter | Medium |
| 0035 | Barrel Shifter | Hard |
| 0036 | PWM Generator | Medium |
| 0037 | UART Transmitter | Hard |
| 0038 | Debounce Circuit | Easy |
| 0039 | Traffic Light Controller | Hard |
| 0040 | CRC Calculator | Hard |
| 0041 | 13-8 SECDED Hamming Code Encoder | Easy |
| 0042 | Population Counter | Medium |
| 0043 | Leading Zero Counter | Medium |
| 0044 | Thermometer to Binary Decoder | Easy |
| 0045 | Carry Lookahead Adder | Hard |
| 0046 | FIR Filter | Medium |
| 0047 | Moving Average Filter | Easy |
| 0048 | Digital Differentiator | Medium |
| 0049 | IIR Biquad Filter | Hard |
| 0050 | Decimation Filter | Hard |
| 0051 | Gray to Binary Converter | Easy |
| 0052 | Parity Generator Checker | Easy |
| 0053 | Memory Read Controller | Medium |
| 0054 | Lookup Table Interpolator | Medium |
| 0055 | Memory Arbiter | Hard |
| 0056 | Counter Manager | Medium |
| 0057 | Histogram Calculator | Medium |
| 0058 | Memory Copy Controller | Medium |
| 0059 | Scratchpad Accumulator | Medium |
| 0060 | Register File Max Finder | Medium |
| 0061 | Fibonacci Generator | Easy |
| 0062 | GCD Calculator | Medium |
| 0063 | Prime Number Checker | Medium |
| 0064 | Bubble Sort Engine | Hard |
| 0065 | Sequence Reverser | Easy |
| 0066 | Running Sum Calculator | Easy |
| 0067 | Moving Maximum Filter | Medium |
| 0068 | Factorial Calculator | Medium |
| 0069 | Palindrome Checker | Medium |
| 0070 | Merge Sorted Streams | Hard |
| 0071 | Two Sum Finder | Medium |
| 0072 | Duplicate Detector | Easy |
| 0073 | Min-Max Finder | Easy |
| 0074 | Median Calculator | Hard |
| 0075 | Run Length Encoder | Medium |
| 0076 | Difference Calculator | Easy |
| 0077 | Peak Detector | Medium |
| 0078 | 1D Convolution Engine | Hard |
| 0079 | Binary Search | Medium |
| 0080 | Matrix Transpose | Hard |
| 0081 | Stream Accumulator | Easy |
| 0082 | Prefix Sum | Easy |
| 0083 | Majority Element Finder | Medium |
| 0084 | Longest Consecutive Sequence | Hard |
| 0085 | Dot Product Calculator | Medium |
| 0086 | Hamming Distance Calculator | Easy |
| 0087 | Trailing Zero Counter | Easy |
| 0088 | Insertion Sort Engine | Medium |
| 0089 | Mode Finder | Medium |
| 0090 | Bitonic Sequence Detector | Medium |
| 0091 | Ethernet Header Parser | Medium |
| 0092 | MAC Address Filter | Easy |
| 0093 | IPv4 Header Checksum | Medium |
| 0094 | ARP Request Detector | Medium |
| 0095 | Packet Length Validator | Easy |
| 0096 | VLAN Tag Detector | Easy |
| 0097 | ReLU Activation Unit | Easy |
| 0098 | MAC Unit | Medium |
| 0099 | Max Pooling Unit | Easy |
| 0100 | Argmax Unit | Easy |
