###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################


source ../../../hdl/scripts/adi_env.tcl
source ../../../hdl/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_ad408x

 create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name my_ila
    set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] [get_ips my_ila] ;# BASIC triggering enable
    set_property -dict [list CONFIG.C_NUM_OF_PROBES {13}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_DATA_DEPTH {2048}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_TRIGIN_EN {false}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE0_WIDTH  {1}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE1_WIDTH  {1}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE2_WIDTH  {1}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE3_WIDTH  {1}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE4_WIDTH  {1}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE5_WIDTH  {31}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE6_WIDTH  {1}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE7_WIDTH  {9}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE8_WIDTH  {1}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE9_WIDTH  {9}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE10_WIDTH {3}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE11_WIDTH {1}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE12_WIDTH {20}] [get_ips my_ila]
    generate_target {all} [get_files axi_ad408x.srcs/sources_1/ip/my_ila/my_ila.xci]

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

adi_init_bd_tcl
adi_ip_bd axi_ad408x "bd/bd.tcl"

set_property driver_value 0 [ipx::get_ports *dovf* -of_objects [ipx::current_core]]

ipx::infer_bus_interface adc_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface delay_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

adi_add_auto_fpga_spec_params

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]
