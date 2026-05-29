###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create clkin_aligner
adi_ip_files clkin_aligner [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "clkin_aligner_constr.sdc" \
  "clkin_aligner_regmap.v" \
  "clkin_aligner.v"]

adi_ip_properties clkin_aligner

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set cc [ipx::current_core]

set_property display_name "ADI AD7134 CLKIN Aligner" $cc
set_property description  "Gated 48 MHz CLKIN with deterministic dig_clk phase alignment for AD7134" $cc

# Mark clk_in as a clock interface so the BD tool knows to associate
# the connected clock object with it.
adi_add_bus clk_in slave \
  "xilinx.com:signal:clock_rtl:1.0" \
  "xilinx.com:signal:clock:1.0" \
  [list {"clk_in" "CLK"}]

# Mark clk_out as a clock source.
adi_add_bus clk_out master \
  "xilinx.com:signal:clock_rtl:1.0" \
  "xilinx.com:signal:clock:1.0" \
  [list {"clk_out" "CLK"}]

# Infer the interrupt interface from the port named 'irq'. Vivado picks
# up SENSITIVITY=LEVEL_HIGH automatically from the port direction/name.
ipx::infer_bus_interface irq xilinx.com:signal:interrupt_rtl:1.0 $cc

# Parameter validation

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "65535" \
 ] \
[ipx::get_user_parameters STARTUP_CYCLES_DEFAULT -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "65535" \
 ] \
[ipx::get_user_parameters EDGE_TARGET_DEFAULT -of_objects $cc]

# XGUI

ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

ipgui::add_page -name {CLKIN Aligner} -component $cc -display_name {CLKIN Aligner}
set page0 [ipgui::get_pagespec -name "CLKIN Aligner" -component $cc]

ipgui::add_param -name "ID" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Peripheral ID" \
  "tooltip" "Reported in the PERIPHERAL_ID register (0x04)." \
] [ipgui::get_guiparamspec -name "ID" -component $cc]

ipgui::add_param -name "STARTUP_CYCLES_DEFAULT" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Startup cycles (default)" \
  "tooltip" "Default number of XTAL2_CLKIN pulses driven during the one-time startup procedure (Sequence.txt section E). Software can override at runtime." \
] [ipgui::get_guiparamspec -name "STARTUP_CYCLES_DEFAULT" -component $cc]

ipgui::add_param -name "EDGE_TARGET_DEFAULT" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Edge target (default)" \
  "tooltip" "Edge index after RESUME at which IRQ_PENDING[0] is asserted (Sequence.txt section F.7: edge 146 = first dig_clk rising edge)." \
] [ipgui::get_guiparamspec -name "EDGE_TARGET_DEFAULT" -component $cc]

ipx::create_xgui_files $cc
ipx::save_core $cc
