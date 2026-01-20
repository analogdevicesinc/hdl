###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_fsrc_tx
adi_ip_files axi_fsrc_tx [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
  "$ad_hdl_dir/library/util_cdc/sync_data.v" \
  "$ad_hdl_dir/library/common/ad_perfect_shuffle.v" \
  "pulse_sync.v" \
  "fifo_sync_2deep.v" \
  "accum_set.sv" \
  "tx_fsrc_make_holes.sv" \
  "tx_fsrc_sample_en_gen.sv" \
  "tx_fsrc.sv" \
  "axi_fsrc_tx.sv" \
  "axi_fsrc_tx_regmap.v" \
]

adi_ip_properties axi_fsrc_tx
adi_ip_ttcl fsrc_tx "axi_fsrc_tx_constr.ttcl"
set_property display_name "ADI AXI FSRC TX" [ipx::current_core]
set_property description "ADI AXI FSRC TX" [ipx::current_core]
# set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_fsrc_tx} [ipx::current_core]

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

adi_init_bd_tcl

proc add_reset {name polarity} {
  set reset_intf [ipx::infer_bus_interface $name xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
  set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
  set_property value $polarity $reset_polarity
}

ipx::infer_bus_interface s_axi_aclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

for {set i 1} {$i < 64} {incr i} {
  set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > $i" \
    [ipx::get_ports *_$i -of_objects [ipx::current_core]]
}

add_reset reset ACTIVE_HIGH
add_reset s_axi_aresetn ACTIVE_LOW

ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]
set_property value s_axi [ipx::get_bus_parameters ASSOCIATED_BUSIF -of_objects [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]]

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]