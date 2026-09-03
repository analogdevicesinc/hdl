###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################
#
# Package the Corundum MRMAC MAC-shim (mrmac_gty_wrapper) + its RTL submodules
# as a single Vivado library IP, so it can be dropped into a block design as one
# cell that sits between the AMD Versal MRMAC IP (GT quad / clocking) and the
# Corundum datapath.
#
# The wrapper is MODE-parameterized:
#   MODE="1x100G" (default) - one 100GE port; fpga_core side 512b, MRMAC 384b
#   MODE="4x25G"            - one 25GE port  (instantiate x4); both sides 64b
#
# fpga_core-facing side is exposed as standard/analog interfaces (axis_eth_tx/rx,
# flow_control_tx/rx) so it lines up with the Corundum core; the MRMAC-facing
# side, DRP and PTP are left as plain ports for direct pin-to-pin wiring to the
# MRMAC IP cell.
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create mrmac_gty_wrapper

# Package against a Versal VP1802 part (VPK180 target). The exact speed-grade
# string is picked dynamically (the reference project does the same); fall back
# to a known-good UltraScale+ part so packaging still succeeds on a machine
# whose Versal device support is not installed.
set _cand [lsort [get_parts -quiet xcvp1802*]]
if {[llength $_cand] > 0} {
  set_property part [lindex $_cand 0] [current_project]
  puts "INFO: mrmac_gty_wrapper packaged against part [lindex $_cand 0]"
} else {
  set_property part xcvu9p-flga2104-2L-e [current_project]
  puts "CRITICAL WARNING: no xcvp1802 part found; packaged against xcvu9p-flga2104-2L-e"
}

# Sources: the wrapper + its two leaf adapters + the Corundum-lib submodules it
# instantiates (cmac_pad + axis_adapter used only in the 100G branch; axis_fifo
# and sync_reset in both). The MRMAC shim + adapters live in the corundum library
# (library/corundum/versal); cmac_pad/axis_* resolve from $ad_hdl_dir/.. == repo root.
adi_ip_files mrmac_gty_wrapper [list \
  "$ad_hdl_dir/library/corundum/versal/mrmac_gty_wrapper.v" \
  "$ad_hdl_dir/library/corundum/versal/mrmac_tx_adapt.v" \
  "$ad_hdl_dir/library/corundum/versal/mrmac_rx_adapt.v" \
  "$ad_hdl_dir/library/corundum/versal/mrmac_ptp_ts_cvt.v" \
  "$ad_hdl_dir/library/corundum/versal/mrmac_ptp_sync.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/cmac_pad.v" \
  "$ad_hdl_dir/../corundum/fpga/common/rtl/mac_ts_insert.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axis/rtl/axis_adapter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axis/rtl/axis_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/sync_reset.v" \
]

adi_ip_properties_lite mrmac_gty_wrapper

set cc [ipx::current_core]

set_property display_name "Corundum MRMAC GTY Wrapper" $cc
set_property description "Corundum MAC shim between the AMD Versal MRMAC and the Corundum datapath (1x100G / 4x25G non-segmented)" $cc
set_property company_url {https://analogdevicesinc.github.io/hdl/library/corundum/mrmac_gty_wrapper} $cc

# Remove all inferred interfaces and address spaces; re-add a curated set.
ipx::remove_all_bus_interface [ipx::current_core]
ipx::remove_all_address_space [ipx::current_core]

# ---------------------------------------------------------------------------
# fpga_core-facing packet AXI-Stream (Corundum MAC-wrapper contract).
# TX is a slave (fpga_core drives), RX is a master (wrapper drives). The RX
# side has no TREADY (fpga_core RX never back-pressures), so it is omitted.
# ---------------------------------------------------------------------------
adi_add_bus "axis_eth_tx" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"tx_axis_tdata" "TDATA"} \
    {"tx_axis_tkeep" "TKEEP"} \
    {"tx_axis_tvalid" "TVALID"} \
    {"tx_axis_tready" "TREADY"} \
    {"tx_axis_tlast" "TLAST"} \
    {"tx_axis_tuser" "TUSER"} \
  ]

adi_add_bus "axis_eth_rx" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"rx_axis_tdata" "TDATA"} \
    {"rx_axis_tkeep" "TKEEP"} \
    {"rx_axis_tvalid" "TVALID"} \
    {"rx_axis_tlast" "TLAST"} \
    {"rx_axis_tuser" "TUSER"} \
  ]

# ---------------------------------------------------------------------------
# Flow-control / enable / status (analog.com custom interfaces, matching the
# Corundum core). Only the ports the wrapper actually presents are mapped;
# optional interface ports not present here (tx_status, *_fc_quanta_clk_en) are
# simply left unmapped.
# ---------------------------------------------------------------------------
adi_if_infer_bus analog.com:interface:if_flow_control_tx slave flow_control_tx [list \
  "tx_enable  tx_enable" \
  "tx_lfc_en  tx_lfc_en" \
  "tx_lfc_req tx_lfc_req" \
  "tx_pfc_en  tx_pfc_en" \
  "tx_pfc_req tx_pfc_req" \
]

adi_if_infer_bus analog.com:interface:if_flow_control_rx slave flow_control_rx [list \
  "rx_enable  rx_enable" \
  "rx_status  rx_status" \
  "rx_lfc_en  rx_lfc_en" \
  "rx_lfc_req rx_lfc_req" \
  "rx_lfc_ack rx_lfc_ack" \
  "rx_pfc_en  rx_pfc_en" \
  "rx_pfc_req rx_pfc_req" \
  "rx_pfc_ack rx_pfc_ack" \
]

# ---------------------------------------------------------------------------
# Clock / reset associations.
#
# The fpga_core-facing interfaces are synchronous to the wrapper's re-exported
# output clocks tx_clk / rx_clk (== tx_axi_clk / rx_axi_clk) and reset by the
# synchronized output resets tx_rst / rx_rst. Declared master (outputs), exactly
# as the cmac_gty_wrapper-based ethernet_vcu118 IP declares eth_tx_clk/eth_tx_rst.
# ---------------------------------------------------------------------------
adi_add_bus_clock "tx_clk" "axis_eth_tx:flow_control_tx" "tx_rst" "master" "master"
adi_add_bus_clock "rx_clk" "axis_eth_rx:flow_control_rx" "rx_rst" "master" "master"

# Input clocks/resets from the BD clocking (recognized as clock/reset pins so
# the BD connects them). tx_axi_clk/rx_axi_clk drive the datapath; drp_clk
# drives the minimal DRP responder. Resets are active-high async inputs.
ipx::infer_bus_interface tx_axi_clk  xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface rx_axi_clk  xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface drp_clk     xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface tx_reset_in xilinx.com:signal:reset_rtl:1.0 $cc
ipx::infer_bus_interface rx_reset_in xilinx.com:signal:reset_rtl:1.0 $cc
ipx::infer_bus_interface drp_rst     xilinx.com:signal:reset_rtl:1.0 $cc

# Break any auto-association Vivado may have placed on the input clocks so they
# do not fight the master-output-clock associations above.
foreach _clk {tx_axi_clk rx_axi_clk drp_clk} {
  set _bif [ipx::get_bus_interfaces ${_clk} -quiet -of_objects $cc]
  if {$_bif ne ""} {
    set _p [ipx::get_bus_parameters ASSOCIATED_BUSIF -quiet -of_objects $_bif]
    if {$_p ne ""} { set_property value {} $_p }
  }
}

# ---------------------------------------------------------------------------
# GUI: expose MODE (the one knob that matters) + the store-and-forward FIFO
# depths. The width parameters are derived from MODE and shown read-only on an
# Advanced page.
# ---------------------------------------------------------------------------
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

ipgui::add_page -name {Configuration} -component $cc -display_name {Configuration}
set page0 [ipgui::get_pagespec -name "Configuration" -component $cc]

set group [ipgui::add_group -name "Mode" -component $cc \
  -parent $page0 -display_name "Mode"]

ipgui::add_param -name "MODE" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "MODE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "Datapath mode" \
  "widget" "comboBox" \
  "tooltip" {1x100G: one 100GE port (512b core / 384b MRMAC). 4x25G: one 25GE port, 64b (instantiate x4).} \
] $p
set_property value_validation_type list [ipx::get_user_parameters MODE -of_objects $cc]
set_property value_validation_list {1x100G 4x25G} [ipx::get_user_parameters MODE -of_objects $cc]

set group [ipgui::add_group -name "FIFO depths" -component $cc \
  -parent $page0 -display_name "FIFO depths"]

ipgui::add_param -name "TX_FIFO_DEPTH" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "TX_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $group
set_property -dict [list \
  "display_name" "TX frame FIFO depth (bytes)" \
  "tooltip" {Store-and-forward TX frame FIFO; must hold the largest frame at the MRMAC-side (NARROW) width.} \
] $p

ipgui::add_param -name "RX_FIFO_DEPTH" -component $cc -parent $page0
set p [ipgui::get_guiparamspec -name "RX_FIFO_DEPTH" -component $cc]
ipgui::move_param -component $cc -order 1 $p -parent $group
set_property -dict [list \
  "display_name" "RX frame FIFO depth (bytes)" \
  "tooltip" {Elastic RX frame FIFO; drops whole frames and flags rx_fifo_overflow on overrun.} \
] $p

ipgui::add_page -name {Advanced} -component $cc -display_name {Advanced (derived widths)}
set page1 [ipgui::get_pagespec -name "Advanced" -component $cc]

set group [ipgui::add_group -name "Derived widths" -component $cc \
  -parent $page1 -display_name "Derived from MODE (do not override)"]

set _order 0
foreach {pn dn} {
  AXIS_DATA_WIDTH "fpga_core AXIS data width"
  AXIS_KEEP_WIDTH "fpga_core AXIS keep width"
  SEG_COUNT       "MRMAC segment count"
  SEG_WIDTH       "MRMAC segment width"
  KUSER_WIDTH     "MRMAC tkeep_user width per segment"
  NARROW          "MRMAC-side data width (SEG_COUNT*SEG_WIDTH)"
} {
  ipgui::add_param -name $pn -component $cc -parent $page1
  set p [ipgui::get_guiparamspec -name $pn -component $cc]
  ipgui::move_param -component $cc -order $_order $p -parent $group
  set_property -dict [list "display_name" $dn] $p
  incr _order
}

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc
