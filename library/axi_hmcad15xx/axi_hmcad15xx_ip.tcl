###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_hmcad15xx

adi_ip_files axi_hmcad15xx [list \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_in.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_serdes_in.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_dcfilter.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
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
  "sample_assembly.v"  \
  "axi_hmcad15xx_if.v" \
  "axi_hmcad15xx.v" ]

adi_ip_properties axi_hmcad15xx

adi_init_bd_tcl
adi_ip_bd axi_hmcad15xx "bd/bd.tcl"

set cc [ipx::current_core]

set_property company_url {https://wiki.analog.com/resources/fpga/docs/ad7768} $cc


set_property driver_value 0 [ipx::get_ports *dovf* -of_objects $cc]
set_property driver_value 0 [ipx::get_ports *adc* -of_objects  $cc]


ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 $cc
ipx::infer_bus_interface clk_in xilinx.com:signal:clock_rtl:1.0 $cc
set reset_intf [ipx::infer_bus_interface adc_reset xilinx.com:signal:reset_rtl:1.0 $cc ]
set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
set_property value "ACTIVE_HIGH" $reset_polarity

adi_add_auto_fpga_spec_params
ipx::create_xgui_files $cc

ipx::save_core $cc
