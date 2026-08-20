###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create ad7134_slip_detect
adi_ip_files ad7134_slip_detect [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "ad7134_slip_detect_constr.sdc" \
  "ad7134_slip_detect_pair.v" \
  "ad7134_slip_detect_regmap.v" \
  "ad7134_slip_detect.v"]

adi_ip_properties ad7134_slip_detect

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set cc [ipx::current_core]

set_property display_name "ADI AD7134 Frame Slip Detector" $cc
set_property description  "Inter-die frame-slip detector for the AD7134 sample stream" $cc

# The streams are declared explicitly rather than inferred: Vivado's
# infer_bus_interfaces matches the AXI4-Stream signal names (s_axis_tvalid,
# s_axis_tdata), while this repository names them without the 't'
# (s_axis_valid, s_axis_data), so inference silently produces no interface.
# Same port map as axi_dmac, minus the sideband signals the offload does not
# drive - the offload master carries only valid/ready/data.

adi_add_bus "s_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"s_axis_ready" "TREADY"} \
    {"s_axis_valid" "TVALID"} \
    {"s_axis_data" "TDATA"}]

adi_add_bus "m_axis" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"m_axis_ready" "TREADY"} \
    {"m_axis_valid" "TVALID"} \
    {"m_axis_data" "TDATA"}]

# The sample stream runs on spi_clk, which is a different clock domain from
# the AXI-Lite interface; associate it explicitly so the BD tool does not
# infer s_axi_aclk for the streaming ports.

adi_add_bus_clock "s_axis_aclk" "s_axis:m_axis" "s_axis_aresetn"

# Infer the interrupt interface from the port named 'irq'.
ipx::infer_bus_interface irq xilinx.com:signal:interrupt_rtl:1.0 $cc

# Parameter validation

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "4" \
  "value_validation_range_maximum" "20" \
 ] \
[ipx::get_user_parameters DC_SHIFT -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "8" \
  "value_validation_range_maximum" "24" \
 ] \
[ipx::get_user_parameters IDLE_LOG2 -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "4" \
  "value_validation_range_maximum" "10" \
 ] \
[ipx::get_user_parameters WIN_LOG2_DEFAULT -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "23" \
  "value_validation_range_maximum" "31" \
 ] \
[ipx::get_user_parameters MSB_POS_DEFAULT -of_objects $cc]

# XGUI

ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

ipgui::add_page -name {Slip Detector} -component $cc -display_name {Slip Detector}
set page0 [ipgui::get_pagespec -name "Slip Detector" -component $cc]

ipgui::add_param -name "ID" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Peripheral ID" \
  "tooltip" "Reported in the PERIPHERAL_ID register (0x04)." \
] [ipgui::get_guiparamspec -name "ID" -component $cc]

ipgui::add_param -name "DC_SHIFT" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "DC removal shift" \
  "tooltip" "Time constant of the leaky integrator that removes the channel-pair offset mismatch, as a power of two. Larger is slower and smoother." \
] [ipgui::get_guiparamspec -name "DC_SHIFT" -component $cc]

ipgui::add_param -name "IDLE_LOG2" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Stream idle timeout (log2 clocks)" \
  "tooltip" "Number of sample-clock cycles without an accepted beat, as a power of two, after which the stream is declared idle and the detector re-arms its warm-up." \
] [ipgui::get_guiparamspec -name "IDLE_LOG2" -component $cc]

ipgui::add_param -name "WIN_LOG2_DEFAULT" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Envelope window (log2 frames)" \
  "tooltip" "Default number of ODR frames accumulated per envelope window, as a power of two. Software can override at runtime via the CONFIG register." \
] [ipgui::get_guiparamspec -name "WIN_LOG2_DEFAULT" -component $cc]

ipgui::add_param -name "MSB_POS_DEFAULT" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Data MSB position (default)" \
  "tooltip" "Bit position of the sample MSB inside each 32-bit channel word: 23 for a plain 24-bit frame, 31 for 24-bit+CRC. Software can override at runtime." \
] [ipgui::get_guiparamspec -name "MSB_POS_DEFAULT" -component $cc]

ipgui::add_param -name "THRESHOLD_DEFAULT" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Detection threshold (default)" \
  "tooltip" "Default delta-envelope threshold for both pairs. Set from a measured ENV_MAX on a known-clean run rather than from theory." \
] [ipgui::get_guiparamspec -name "THRESHOLD_DEFAULT" -component $cc]

ipx::create_xgui_files $cc
ipx::save_core $cc
