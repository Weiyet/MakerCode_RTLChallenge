# =============================================================================
# vhdl_zero2hero - standalone GHDL simulation runner
#
# This track uses NATIVE VHDL testbenches (tb.vhdl) run by GHDL, so it does not
# reuse the repo-root Makefile (whose VHDL path is vhd2vl -> iverilog + tb.sv).
#
#   make sim  QUESTION=5                      # test your interface.vhdl
#   make sim  QUESTION=5 DUT=solution.vhdl    # test the reference answer
#   make wave QUESTION=5                      # dump a VCD and open gtkwave
#   make clean
#
# QUESTION may be 5, 05, or 0005. A passing run prints "Test PASS".
# Requires: ghdl (>=--std=08). gtkwave for `make wave`.
# =============================================================================
SHELL := /bin/bash
.ONESHELL:

GHDL    ?= ghdl
STD     ?= 08
GTKWAVE ?= gtkwave

QUESTION ?= 0
DUT      ?= interface.vhdl

QID  := $(shell printf '%04d' $$((10#$(QUESTION))) 2>/dev/null)
QDIR := $(QID)

.PHONY: sim wave clean help
.DEFAULT_GOAL := help

help:
	@echo "vhdl_zero2hero - GHDL simulation runner"
	@echo ""
	@echo "  make sim  QUESTION=<n> [DUT=solution.vhdl]   # default tests your interface.vhdl"
	@echo "  make wave QUESTION=<n>                        # open a waveform in gtkwave"
	@echo "  make clean"
	@echo ""
	@echo "A passing run prints 'Test PASS'."

sim:
	@if [ ! -d "$(QDIR)" ]; then echo "Question $(QID) not found (looked for ./$(QDIR)/)"; exit 1; fi
	work=$$(mktemp -d)
	if ! $(GHDL) -a --std=$(STD) --workdir=$$work "$(CURDIR)/$(QDIR)/$(DUT)" "$(CURDIR)/$(QDIR)/tb.vhdl" > "$(QDIR)/sim.log" 2>&1; then
	  echo "  $(QID): ANALYZE ERROR  -> $(QDIR)/sim.log"; sed -n '1,6p' "$(QDIR)/sim.log"; rm -rf $$work; exit 1
	fi
	( cd $$work && $(GHDL) --elab-run --std=$(STD) --workdir=$$work tb ) > "$(QDIR)/sim.log" 2>&1 || true
	rm -rf $$work
	if grep -q "Test PASS" "$(QDIR)/sim.log"; then
	  echo "  $(QID): PASS  (log: $(QDIR)/sim.log)"
	else
	  echo "  $(QID): FAIL  (log: $(QDIR)/sim.log)"; grep -iE "error|fail|mismatch" "$(QDIR)/sim.log" | head -5; exit 1
	fi

wave:
	@if [ ! -d "$(QDIR)" ]; then echo "Question $(QID) not found"; exit 1; fi
	work=$$(mktemp -d)
	$(GHDL) -a --std=$(STD) --workdir=$$work "$(CURDIR)/$(QDIR)/solution.vhdl" "$(CURDIR)/$(QDIR)/tb.vhdl"
	( cd "$(QDIR)" && $(GHDL) --elab-run --std=$(STD) --workdir=$$work tb --vcd=wave.vcd ) || true
	rm -rf $$work
	$(GTKWAVE) "$(QDIR)/wave.vcd" >/dev/null 2>&1 &

clean:
	@rm -f */sim.log */wave.vcd
	@rm -rf work-obj*.cf
	@echo "removed sim.log / wave.vcd from question folders"
