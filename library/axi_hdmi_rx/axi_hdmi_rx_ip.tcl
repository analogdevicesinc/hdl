###############################################################################
## Copyright (C) 2015-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_hdmi_rx
adi_ip_files axi_hdmi_rx [list \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_csc.v" \
  "$ad_hdl_dir/library/common/ad_ss_422to444.v" \
  "$ad_hdl_dir/library/common/ad_csc_CrYCb2RGB.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_hdmi_rx.v" \
  "axi_hdmi_rx.v" \
  "axi_hdmi_rx_es.v" \
  "axi_hdmi_rx_tpm.v" \
  "axi_hdmi_rx_core.v" ]

adi_ip_properties axi_hdmi_rx

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_hdmi_rx} [ipx::current_core]

ipx::infer_bus_interface hdmi_rx_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface hdmi_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]

