# vhdl_zero2hero reuses the repo-root Makefile. This track ships native VHDL-2008
# testbenches (tb.vhdl) run by GHDL, so it selects the root's LANGUAGE=GHDL path.
#   make sim  QUESTION=5                    # tests interface.vhdl (your answer)
#   make sim  QUESTION=5 DUT=solution.vhdl  # tests the reference
#   make wave QUESTION=5                     # dump + open a VCD in gtkwave
QDIR_ROOT := .
LANGUAGE  ?= GHDL
DUT       ?= interface.vhdl
include ../../Makefile
