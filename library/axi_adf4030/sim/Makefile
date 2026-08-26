# =============================================================================
# Makefile -- axi_adf4030 master+slave simulation
#
# Verilator (fast, no license):
#   make              build + run, produces tb_axi_adf4030.vcd
#   make run          re-run without rebuild
#   make wave         open VCD in gtkwave
#   make vivado-wave  open Vivado GUI for waveform viewing (see instructions)
#
# Vivado xsim (requires a Vivado project -- see xsim target below):
#   make xsim         prints instructions for running via Vivado project flow
#
# make clean          remove all build artifacts
#
# Requirements (Verilator):
#   pip install --user --break-system-packages verilator
#   g++ with C++20 support (Ubuntu 24.04 default: g++ 13)
#   python3 must also be callable as 'python':
#     ln -sf $(which python3) /usr/local/bin/python
#
# Requirements (Vivado waveform):
#   Vivado 2020.1+ on PATH (source settings64.sh first)
# =============================================================================

VERILATOR := $(shell python3 -c \
  "import verilator, os; print(os.path.join(os.path.dirname(verilator.__file__),'bin','verilator'))")

HDL_LIB := ../../..
IP_DIR  := ..

SV_SRCS := \
  $(HDL_LIB)/library/util_cdc/sync_bits.v \
  $(HDL_LIB)/library/util_cdc/sync_data.v \
  $(HDL_LIB)/library/util_cdc/sync_event.v \
  $(HDL_LIB)/library/common/up_axi.v \
  $(HDL_LIB)/library/common/ad_rst.v \
  iobufds_dcien_stub.sv \
  trigger_bsync_stretcher_fixed.sv \
  $(IP_DIR)/bsync_generator.sv \
  $(IP_DIR)/trigger_channel.sv \
  $(IP_DIR)/axi_adf4030_regmap.sv \
  $(IP_DIR)/axi_adf4030.sv \
  tb_axi_adf4030.sv

BUILD_DIR := obj_dir
SIM_BIN   := $(BUILD_DIR)/Vtb_axi_adf4030

.PHONY: all run wave vivado-wave xsim xsim-clean clean

# ---------------------------------------------------------------------------
# Verilator targets
# ---------------------------------------------------------------------------
all: $(SIM_BIN)
	@echo ""
	@echo "--- Running simulation ---"
	@echo ""
	$(SIM_BIN)

$(SIM_BIN): $(SV_SRCS)
	$(VERILATOR) \
	  --binary --sv \
	  --top-module tb_axi_adf4030 \
	  --trace --timing \
	  -CFLAGS "-std=c++20 -fcoroutines" \
	  --Mdir $(BUILD_DIR) \
	  -Wno-IMPLICIT -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC -Wno-MULTIDRIVEN \
	  -MAKEFLAGS 'CFG_CXXFLAGS_PCH_I=-include' \
	  $(SV_SRCS)

run:
	$(SIM_BIN)

wave:
	gtkwave tb_axi_adf4030.vcd tb_axi_adf4030.gtkw &

# ---------------------------------------------------------------------------
# Vivado waveform viewer (open VCD produced by Verilator)
#
# Vivado 2025.x cannot open VCD from batch Tcl -- it must be done via the GUI.
# This target opens Vivado; follow the 3 steps printed to the terminal.
# ---------------------------------------------------------------------------
vivado-wave: tb_axi_adf4030.vcd
	@echo ""
	@echo "=== Vivado waveform instructions ==="
	@echo "  Step 1 (automatic): Vivado opens below"
	@echo "  Step 2 (in GUI):    File > Open Waveform..."
	@echo "                      Select: $(CURDIR)/tb_axi_adf4030.vcd"
	@echo "  Step 3 (in GUI):    Tools > Run Tcl Script..."
	@echo "                      Select: $(CURDIR)/wave_config.tcl"
	@echo "                      (pre-groups all signals into labelled sections)"
	@echo ""
	vivado &

# ---------------------------------------------------------------------------
# xsim: native Vivado simulator
#
# The TB uses 'ref logic' in tasks.  xsim flags these as multi-driver errors
# when the same signal is also driven by always_comb or a DUT port.
# (Verilator uses -Wno-MULTIDRIVEN to suppress the equivalent warning.)
#
# To run with xsim, use the Vivado project-level GUI flow:
#   1.  vivado &
#   2.  File > New Project > RTL Project (do not specify sources yet)
#   3.  Add Sources (Design Sources) -- all files listed in SV_SRCS above
#       PLUS: sim/iobufds_dcien_stub.sv, sim/trigger_bsync_stretcher_fixed.sv
#   4.  Set Simulation Top: tb_axi_adf4030
#   5.  Flow Navigator > Run Simulation > Run Behavioral Simulation
#   6.  After run completes: Tools > Run Tcl Script > wave_config.tcl
#
# The GUI flow applies the necessary -relax/-d elaboration flags automatically.
# ---------------------------------------------------------------------------
xsim:
	@echo ""
	@echo "=== xsim requires the Vivado project flow ==="
	@echo "  1.  vivado &"
	@echo "  2.  File > New Project > RTL Project"
	@echo "  3.  Add Sources: all files from SV_SRCS in Makefile"
	@echo "      (include sim/iobufds_dcien_stub.sv and"
	@echo "             sim/trigger_bsync_stretcher_fixed.sv as sim-only)"
	@echo "  4.  Set simulation top: tb_axi_adf4030"
	@echo "  5.  Flow > Run Simulation > Run Behavioral Simulation"
	@echo "  6.  Tools > Run Tcl Script > wave_config.tcl"
	@echo ""

xsim-clean:
	rm -rf xsim.dir .Xil xvlog.pb xelab.pb xsim.jou xsim.log \
	       webtalk*.jou webtalk*.log wave.wdb *.wdb

clean: xsim-clean
	rm -rf $(BUILD_DIR) tb_axi_adf4030.vcd
