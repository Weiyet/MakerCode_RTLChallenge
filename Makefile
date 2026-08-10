# =============================================================================
# RTL Question Bank - local simulation runner
#
# A tiny, synchronous stand-in for the grading backend so you can build, run,
# and view waveforms for a question entirely offline.
#
#   make sim  QUESTION=5                  # SystemVerilog (interface.sv), default
#   make sim  QUESTION=5 LANGUAGE=VHDL    # interface.vhdl  (needs vhd2vl)
#   make sim  QUESTION=5 LANGUAGE=TLV     # interface.tlv   (needs sandpiper-saas)
#   make sim  QUESTION=5 DUT=solution.sv  # simulate a specific file instead
#   make wave QUESTION=5 [TEST=2]         # open <QID>/test_<k>.vcd in gtkwave
#   make clean
#
# QUESTION may be 5, 05, or 0005 (it is zero-padded to 4 digits).
#
# Outputs are written INTO the question folder (<QID>/):
#   sim_N.log       simulation log for test N
#   test_N.vcd      waveform for test N
#   compile_N.log   compiler output for test N (warnings/errors; may be empty)
#   dut.sv          generated Verilog (VHDL/TLV only)
#
# Pass/fail mirrors the grader: a failing testbench prints "ERROR: ...tb.sv"
# (emitted by $error). No such line -> PASS. Exits non-zero if any test fails.
#
# Requirements: iverilog + vvp. vhd2vl for VHDL, sandpiper-saas for TL-Verilog
# (only if you use those languages). gtkwave for `make wave`.
# =============================================================================

SHELL := /bin/bash

IVERILOG  ?= iverilog
VVP       ?= vvp
VHD2VL    ?= vhd2vl
SANDPIPER ?= sandpiper-saas
GTKWAVE   ?= gtkwave
GHDL      ?= ghdl
GHDL_STD  ?= 08

QUESTION  ?= 0
LANGUAGE  ?= SV
DUT       ?=
TEST      ?= 1

# Directory holding the NNNN/ problem folders. Override it from a sub-track
# Makefile (e.g. `QDIR_ROOT := .`) to reuse this Makefile for another folder.
QDIR_ROOT ?= questions

# Zero-pad to 4 digits; 10# forces base-10 so "010" is not read as octal.
QID  := $(shell printf '%04d' $$((10#$(QUESTION))) 2>/dev/null)
QDIR := $(QDIR_ROOT)/$(QID)

.ONESHELL:
.PHONY: sim wave clean help
.DEFAULT_GOAL := help

help:
	@echo "RTL Question Bank - local simulation runner"
	@echo ""
	@echo "  make sim  QUESTION=<n> [LANGUAGE=SV|VERILOG|VHDL|GHDL|TLV] [DUT=<file>]"
	@echo "  make wave QUESTION=<n> [TEST=<k>]   # open <QID>/test_<k>.vcd (default 1)"
	@echo "  make clean"
	@echo ""
	@echo "Outputs (sim_N.log, test_N.vcd) are written into the question folder."
	@echo "Default LANGUAGE=SV uses interface.sv; override with DUT=<file>."

sim:
	@if [ ! -d "$(QDIR)" ]; then echo "Question $(QID) not found (looked for ./$(QDIR)/)"; exit 1; fi
	lang=$$(echo "$(LANGUAGE)" | tr '[:lower:]' '[:upper:]')

	# ---- native VHDL via GHDL (tb.vhdl) -------------------------------------
	# For tracks that ship real VHDL-2008 testbenches (LANGUAGE=GHDL). This path
	# is self-contained and does not touch the iverilog flow below.
	if [ "$$lang" = "GHDL" ] || [ "$$lang" = "NVHDL" ]; then
	  src="$(DUT)"; [ -z "$$src" ] && src="interface.vhdl"
	  case "$$src" in /*) ;; *) src="$(QDIR)/$$src" ;; esac
	  if [ ! -f "$$src" ]; then echo "DUT source not found: $$src"; exit 1; fi
	  log="$(QDIR)/sim.log"; work=$$(mktemp -d)
	  echo ">> simulating question $(QID) via $(GHDL)  (DUT: $$src)"
	  if ! $(GHDL) -a --std=$(GHDL_STD) --workdir=$$work "$(CURDIR)/$$src" "$(CURDIR)/$(QDIR)/tb.vhdl" > "$$log" 2>&1; then
	    echo "  test 1: ANALYZE ERROR  -> $$log"; sed -n '1,6p' "$$log"; rm -rf $$work; exit 1
	  fi
	  ( cd $$work && $(GHDL) --elab-run --std=$(GHDL_STD) --workdir=$$work tb ) > "$$log" 2>&1 || true
	  rm -rf $$work; rm -f "$(QDIR)/PASS_VHDL"
	  if grep -q "Test PASS" "$$log"; then
	    echo "  test 1: PASS  (log: $$log)"; touch "$(QDIR)/PASS_VHDL"; exit 0
	  else
	    echo "  test 1: FAIL  (log: $$log)"; grep -iE "error|fail|mismatch" "$$log" | head -5; exit 1
	  fi
	fi

	# ---- choose the DUT source file -----------------------------------------
	src="$(DUT)"
	if [ -z "$$src" ]; then
	  case "$$lang" in
	    VHDL)            src="$(QDIR)/interface.vhdl" ;;
	    TLV|TL-VERILOG)  src="$(QDIR)/interface.tlv"  ;;
	    *)               src="$(QDIR)/interface.sv"   ;;
	  esac
	else
	  case "$$src" in /*) ;; *) src="$(QDIR)/$$src" ;; esac   # relative -> under question dir
	fi
	if [ ! -f "$$src" ]; then echo "DUT source not found: $$src"; exit 1; fi

	# ---- normalise to plain (System)Verilog the compiler can read -----------
	case "$$lang" in
	  VHDL)
	    echo ">> converting VHDL via $(VHD2VL)";
	    $(VHD2VL) "$$src" > "$(QDIR)/dut.sv" || { echo "vhd2vl failed"; exit 1; };
	    dutsv="$(QDIR)/dut.sv" ;;
	  TLV|TL-VERILOG)
	    echo ">> converting TL-Verilog via $(SANDPIPER)";
	    rm -f "$(QDIR)/dut.sv" "$(QDIR)/dut_gen.sv";
	    ( cd "$(QDIR)" && echo y | $(SANDPIPER) -i "$(CURDIR)/$$src" -o dut.sv ) || { echo "sandpiper failed"; exit 1; };
	    [ -f "$(QDIR)/out/dut.sv" ]     && cp "$(QDIR)/out/dut.sv"     "$(QDIR)/dut.sv";
	    [ -f "$(QDIR)/out/dut_gen.sv" ] && cp "$(QDIR)/out/dut_gen.sv" "$(QDIR)/dut_gen.sv";
	    rm -rf "$(QDIR)/out";
	    dutsv="$(QDIR)/dut.sv" ;;
	  *)
	    dutsv="$$src" ;;       # SystemVerilog/Verilog: compile the source directly
	esac

	# iverilog -P needs a decimal, so convert Verilog literals (4'b1011, 8'hFF).
	to_dec () {
	  local v="$${1//_/}"
	  if [[ "$$v" == *\'* ]]; then
	    local d="$${v##*\'}"
	    case "$$d" in
	      [bB]*) echo $$((2#$${d:1})) ;;
	      [hH]*) echo $$((16#$${d:1})) ;;
	      [oO]*) echo $$((8#$${d:1})) ;;
	      [dD]*) echo $$((10#$${d:1})) ;;
	      *)     echo $$((10#$$d)) ;;
	    esac
	  else
	    echo "$$v"
	  fi
	}

	PASS=0; FAIL=0
	run_one () {   # $$1 = test number, $$2 = "-P ..." flags (may be empty)
	  local n="$$1" pf="$$2"
	  local out="$(QDIR)/sim_$$n.out" vcd="$(QDIR)/test_$$n.vcd"
	  local log="$(QDIR)/sim_$$n.log" clog="$(QDIR)/compile_$$n.log"
	  if ! $(IVERILOG) -g2012 -s tb -I "$(QDIR)" $$pf \
	       -o "$$out" "$(QDIR)/tb.sv" "$$dutsv" 2> "$$clog"; then
	    echo "  test $$n: COMPILE ERROR  -> $$clog"; FAIL=$$((FAIL+1)); return
	  fi
	  $(VVP) "$$out" +VCDFILE="$$vcd" > "$$log" 2>&1 || true
	  rm -f "$$out"                                 # drop the throwaway binary
	  # A failing testbench emits "ERROR: <path>tb.sv:<line>:" via $error.
	  if grep -qE "ERROR:.*tb\.sv" "$$log"; then
	    echo "  test $$n: FAIL  (log: $$log , wave: $$vcd)"; FAIL=$$((FAIL+1))
	  else
	    echo "  test $$n: PASS  (log: $$log , wave: $$vcd)"; PASS=$$((PASS+1))
	  fi
	}

	echo ">> simulating question $(QID)  (DUT: $$src)"
	# input_vector.txt: line 1 = parameter names, each later line = a value set
	# passed as -P tb.<name>=<value>. No file (or no rows) -> one default run.
	iv="$(QDIR)/input_vector.txt"
	if [ -f "$$iv" ] && [ "$$(sed '1d' "$$iv" | grep -cve '^[[:space:]]*$$')" -gt 0 ]; then
	  read -ra NAMES <<< "$$(sed -n '1p' "$$iv")"
	  n=0
	  while IFS= read -r row || [ -n "$$row" ]; do
	    [ -z "$${row//[[:space:]]/}" ] && continue
	    read -ra VALS <<< "$$row"
	    pf=""
	    for k in "$${!NAMES[@]}"; do
	      [ -n "$${VALS[$$k]}" ] && pf="$$pf -P tb.$${NAMES[$$k]}=$$(to_dec "$${VALS[$$k]}")"
	    done
	    n=$$((n+1)); run_one "$$n" "$$pf"
	  done < <(sed '1d' "$$iv")
	else
	  run_one 1 ""
	fi

	echo ">> done: $$PASS passed, $$FAIL failed  (artifacts in $(QDIR)/)"

	# Drop a per-language marker file so update_csv.py can record progress.
	# All tests pass -> create PASS_<LANG>; any failure -> remove a stale one.
	case "$$lang" in VHDL) tag=VHDL ;; TLV|TL-VERILOG) tag=TLV ;; *) tag=SV ;; esac
	rm -f "$(QDIR)/PASS_$$tag"
	if [ "$$FAIL" -eq 0 ]; then
	  touch "$(QDIR)/PASS_$$tag"
	  echo ">> marked $(QDIR)/PASS_$$tag"
	fi

	[ "$$FAIL" -eq 0 ]

wave:
	@lang=$$(echo "$(LANGUAGE)" | tr '[:lower:]' '[:upper:]')
	if [ "$$lang" = "GHDL" ] || [ "$$lang" = "NVHDL" ]; then
	  work=$$(mktemp -d)
	  $(GHDL) -a --std=$(GHDL_STD) --workdir=$$work "$(CURDIR)/$(QDIR)/solution.vhdl" "$(CURDIR)/$(QDIR)/tb.vhdl"
	  ( cd "$(QDIR)" && $(GHDL) --elab-run --std=$(GHDL_STD) --workdir=$$work tb --vcd=wave.vcd ) || true
	  rm -rf $$work
	  $(GTKWAVE) "$(QDIR)/wave.vcd" >/dev/null 2>&1 &
	  exit 0
	fi
	vcd="$(QDIR)/test_$(TEST).vcd"
	if [ ! -f "$$vcd" ]; then
	  echo "No waveform at $$vcd";
	  if ls $(QDIR)/test_*.vcd >/dev/null 2>&1; then
	    echo "Available (pick one with TEST=<n>):"; ls $(QDIR)/test_*.vcd;
	  else
	    echo "Run 'make sim QUESTION=$(QUESTION)' first.";
	  fi
	  exit 1;
	fi
	$(GTKWAVE) "$$vcd" >/dev/null 2>&1 &

clean:
	@rm -f */sim_*.log */test_*.vcd */compile_*.log */sim_*.out */dut.sv */dut_gen.sv
	@rm -rf build
	@echo "removed generated logs / waveforms / dut.sv from question folders"
