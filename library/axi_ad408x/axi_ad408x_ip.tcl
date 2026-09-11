###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad408x

adi_ip_files axi_ad408x [list \
  "$ad_hdl_dir/library/xilinx/common/ad_serdes_in.v" \
  "$ad_hdl_dir/library/common/ad_pack.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_in.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_dcfilter.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "ad408x_phy.v" \
  "axi_ad408x.v" ]

adi_ip_properties axi_ad408x

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

adi_init_bd_tcl
adi_ip_bd axi_ad408x "bd/bd.tcl"

set_property driver_value 0 [ipx::get_ports *dovf* -of_objects [ipx::current_core]]

ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface delay_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

set cc [ipx::current_core]

set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "1 2" \
] [ipx::get_user_parameters NUM_LANES -of_objects $cc]

adi_set_ports_dependency "data_b_in_p" \
  "(spirit:decode(id('MODELPARAM_VALUE.NUM_LANES')) == 2)"
adi_set_ports_dependency "data_b_in_n" \
  "(spirit:decode(id('MODELPARAM_VALUE.NUM_LANES')) == 2)"

set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "0 1" \
] [ipx::get_user_parameters USE_CNV -of_objects $cc]

adi_set_ports_dependency "cnv_in_p" \
  "(spirit:decode(id('MODELPARAM_VALUE.USE_CNV')) == 1)"
adi_set_ports_dependency "cnv_in_n" \
  "(spirit:decode(id('MODELPARAM_VALUE.USE_CNV')) == 1)"

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects $cc]

adi_add_auto_fpga_spec_params

ipx::create_xgui_files $cc
ipx::save_core $cc
