###############################################################################
## Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad35xxr
adi_ip_files axi_ad35xxr [list \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_dac_common.v" \
  "$ad_hdl_dir/library/common/up_dac_channel.v" \
  "$ad_hdl_dir/library/common/ad_dds_cordic_pipe.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine_cordic.v" \
  "$ad_hdl_dir/library/common/ad_dds_sine.v" \
  "$ad_hdl_dir/library/common/ad_dds_2.v" \
  "$ad_hdl_dir/library/common/ad_dds_1.v" \
  "$ad_hdl_dir/library/common/ad_dds.v" \
  "$ad_hdl_dir/library/common/ad_addsub.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "axi_ad35xxr_channel.v" \
  "axi_ad35xxr_core.v" \
  "axi_ad35xxr_if.v" \
  "axi_ad35xxr.v" ]

adi_ip_properties axi_ad35xxr
adi_init_bd_tcl
adi_ip_bd axi_ad35xxr "bd/bd.tcl"

set cc [ipx::current_core]

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_ad35xxr} $cc

set_property driver_value 0 [ipx::get_ports *dac* -of_objects  $cc]
set_property driver_value 0 [ipx::get_ports *data* -of_objects  $cc]
set_property driver_value 0 [ipx::get_ports *valid* -of_objects  $cc]
ipx::infer_bus_interface dac_clk xilinx.com:signal:clock_rtl:1.0 $cc

adi_add_bus "s_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"dac_data_ready" "TREADY"} \
    {"valid_in_dma" "TVALID"} \
    {"dma_data" "TDATA"}]
adi_add_bus_clock "dac_clk" "s_axis"

adi_add_auto_fpga_spec_params

ipx::create_xgui_files $cc
ipx::save_core $cc
