###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_xilinx.tcl

adi_ip_create axi_fsrc_rx
adi_ip_files axi_fsrc_rx [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "fill_holes.sv" \
  "rx_fsrc_remove_invalid.sv" \
  "axi_fsrc_rx.v" \
  "axi_fsrc_rx_regmap.v" \
]

adi_ip_properties axi_fsrc_rx
adi_ip_ttcl fsrc_rx "axi_fsrc_rx_constr.ttcl"
set_property display_name "ADI AXI FSRC RX" [ipx::current_core]
set_property description "ADI AXI FSRC RX" [ipx::current_core]
# set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_fsrc_rx} [ipx::current_core]

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

adi_init_bd_tcl

proc add_reset {name polarity} {
  set reset_intf [ipx::infer_bus_interface $name xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
  set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
  set_property value $polarity $reset_polarity
}

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

add_reset reset ACTIVE_HIGH

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]