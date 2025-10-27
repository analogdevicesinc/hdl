###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad9434
adi_ip_files axi_ad9434 [list \
  "$ad_hdl_dir/library/xilinx/common/ad_serdes_clk.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mmcm_drp.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_serdes_in.v" \
  "$ad_hdl_dir/library/common/ad_datafmt.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/ad_pnmon.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "axi_ad9434_if.v" \
  "axi_ad9434_pnmon.v" \
  "axi_ad9434_core.v" \
  "axi_ad9434_constr.xdc" \
  "axi_ad9434.v" ]

adi_ip_properties axi_ad9434

adi_init_bd_tcl
adi_ip_bd axi_ad9434 "bd/bd.tcl"

set_property driver_value 0 [ipx::get_ports *dovf* -of_objects [ipx::current_core]]

ipx::infer_bus_interface delay_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

