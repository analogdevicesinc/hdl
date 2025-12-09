###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_dac_interpolate
create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila_0
set_property -dict [list \
  CONFIG.C_DATA_DEPTH {16384} \
  CONFIG.C_EN_STRG_QUAL {1} \
  CONFIG.C_NUM_OF_PROBES {32} \
  CONFIG.C_PROBE0_WIDTH {16} \
  CONFIG.C_PROBE1_WIDTH {16} \
  CONFIG.C_PROBE9_WIDTH {2} \
  CONFIG.C_PROBE10_WIDTH {2} \
  CONFIG.C_PROBE13_WIDTH {2} \
  CONFIG.C_PROBE14_WIDTH {2} \
  CONFIG.C_PROBE22_WIDTH {2} \
] [get_ips ila_0]
generate_target {all} [get_files ila_0.srcs/sources_1/ip/ila_0/ila_0.xci]
adi_ip_files axi_dac_interpolate [list \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_iqcor.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_mul.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "cic_interp.v" \
  "fir_interp.v" \
  "axi_dac_interpolate_reg.v" \
  "axi_dac_interpolate_filter.v" \
  "axi_dac_interpolate.v" ]

adi_ip_properties axi_dac_interpolate

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_dac_interpolate} [ipx::current_core]

ipx::infer_bus_interface dac_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface dac_rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]

