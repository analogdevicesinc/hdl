# =============================================================================
# wave_config.tcl — Vivado waveform viewer signal groups
#
# This script loads pre-grouped signals into an already-open Vivado waveform
# window.  There are two ways to get to that point:
#
# --- Option A: open the VCD from Verilator (no xsim license needed) ---
#
#   1. Run the Verilator sim to produce tb_axi_adf4030.vcd:
#        make           (from the sim/ directory)
#
#   2. Open Vivado GUI:
#        vivado &
#
#   3. In Vivado:  File > Open Waveform...
#      Navigate to:  .../axi_adf4030/sim/tb_axi_adf4030.vcd
#      Click OK.  The waveform window opens.
#
#   4. Load signal groups:  Tools > Run Tcl Script > wave_config.tcl
#
# --- Option B: run xsim natively (native .wdb, needs Vivado project) ---
#
#   See the xsim section in the Makefile for instructions on creating a
#   Vivado project and running the simulation from the GUI.
#   After the simulation finishes, run this script the same way:
#   Tools > Run Tcl Script > wave_config.tcl
#
# --- Option C: command line shortcut (opens Vivado with the VCD) ---
#
#   From a terminal with Vivado on PATH:
#     make vivado-wave
#   This runs: vivado -source wave_config.tcl
#   Vivado opens in GUI mode.  Then manually open the VCD via File > Open
#   Waveform, then the signal groups from this script are already loaded.
#   (Vivado 2025.x cannot open VCD files from batch Tcl; the GUI menu is
#   required.  After opening the VCD, re-run this script to add signal groups.)
# =============================================================================

# ---------------------------------------------------------------------------
# Helper: add a divider then add each signal, silently skip missing ones
# ---------------------------------------------------------------------------
proc grp {label signals} {
    catch { add_wave_divider $label }
    foreach s $signals {
        catch { add_wave $s }
    }
}

# ---------------------------------------------------------------------------
# Clocks & Reset
# ---------------------------------------------------------------------------
grp "=== Clocks & Reset ===" {
    /tb_axi_adf4030/axi_clk
    /tb_axi_adf4030/axi_rstn
    /tb_axi_adf4030/dev_clk
}

# ---------------------------------------------------------------------------
# BSYNC differential bus  (external chip model + shared bus)
# ---------------------------------------------------------------------------
grp "=== BSYNC bus ===" {
    /tb_axi_adf4030/ext_bsync_en
    /tb_axi_adf4030/ext_bsync_drv
    /tb_axi_adf4030/bsync_p
    /tb_axi_adf4030/bsync_n
}

# ---------------------------------------------------------------------------
# Master bsync_generator internals (shows calibration state machine)
# ---------------------------------------------------------------------------
grp "--- Master: bsync_generator internals ---" {
    /tb_axi_adf4030/i_master/i_bsync_generator/state
    /tb_axi_adf4030/i_master/i_bsync_generator/ratio_counter
    /tb_axi_adf4030/i_master/i_bsync_generator/bsync_ratio
    /tb_axi_adf4030/i_master/i_bsync_generator/bsync_delay
    /tb_axi_adf4030/i_master/i_bsync_generator/calib_done
    /tb_axi_adf4030/i_master/i_bsync_generator/bsync_ready
    /tb_axi_adf4030/i_master/i_bsync_generator/internal_bsync
}

# ---------------------------------------------------------------------------
# Master -- trigger chain & PMOD output
# ---------------------------------------------------------------------------
grp "--- Master: trigger chain ---" {
    /tb_axi_adf4030/m_trigger
    /tb_axi_adf4030/m_sysref
    /tb_axi_adf4030/m_trig_channel
    /tb_axi_adf4030/m_trig_request_out
    /tb_axi_adf4030/m_dma_start
}

# ---------------------------------------------------------------------------
# Master -- system_top dma_start -> sync_start chain
# ---------------------------------------------------------------------------
grp "--- Master: dma_start -> sync_start chain ---" {
    /tb_axi_adf4030/m_dma_start
    /tb_axi_adf4030/m_trigger_stretched
    /tb_axi_adf4030/m_trigger_sync1
    /tb_axi_adf4030/m_trigger_sync2
    /tb_axi_adf4030/m_trigger_captured
    /tb_axi_adf4030/m_sync_start_edge
    /tb_axi_adf4030/m_sync_start
}

# ---------------------------------------------------------------------------
# Slave -- trigger chain
# ---------------------------------------------------------------------------
grp "--- Slave: trigger chain ---" {
    /tb_axi_adf4030/s_sysref
    /tb_axi_adf4030/s_trig_channel
    /tb_axi_adf4030/s_trig_request_out
    /tb_axi_adf4030/s_dma_start
}

# ---------------------------------------------------------------------------
# Slave -- system_top dma_start -> sync_start chain
# ---------------------------------------------------------------------------
grp "--- Slave: dma_start -> sync_start chain ---" {
    /tb_axi_adf4030/s_dma_start
    /tb_axi_adf4030/s_trigger_stretched
    /tb_axi_adf4030/s_trigger_sync1
    /tb_axi_adf4030/s_trigger_sync2
    /tb_axi_adf4030/s_trigger_captured
    /tb_axi_adf4030/s_sync_start_edge
    /tb_axi_adf4030/s_sync_start
}

# ---------------------------------------------------------------------------
# Master AXI write channel (useful for debugging register writes)
# ---------------------------------------------------------------------------
grp "--- Master: AXI write ---" {
    /tb_axi_adf4030/m_awvalid
    /tb_axi_adf4030/m_awready
    /tb_axi_adf4030/m_awaddr
    /tb_axi_adf4030/m_wvalid
    /tb_axi_adf4030/m_wready
    /tb_axi_adf4030/m_wdata
    /tb_axi_adf4030/m_bvalid
}

catch { wave zoom full }

puts ""
puts "=== Signal groups loaded. What to look for: ==="
puts "  BSYNC bus:       periodic 50% at BSYNC_HALF_PER=20 dev_clk (80 ns period)"
puts "  bsync_generator: watch state IDLE->BSYNC_EDGE->CALIB->BSYNC_GEN"
puts "  m/s_dma_start:   1-cycle pulse when trig_channel\[4\] fires"
puts "  m/s_trigger_stretched: SR latch (set by dma_start, clear by captured)"
puts "  m/s_sync_start:  one sysref-half-period wide pulse, one per trigger event"
puts "  Zoom to ~6-8 us to see TEST 11 (master sync_start chain in detail)"
puts ""
