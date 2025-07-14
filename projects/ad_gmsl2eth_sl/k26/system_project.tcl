###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl

source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad_gmsl2eth_sl_k26
adi_project_files ad_gmsl2eth_sl_k26 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/eth_xcvr_phy_10g_gty_wrapper.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/rb_drp.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_port.tcl" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_clock_cdc.tcl" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/syn/vivado/sync_reset.tcl" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/tdma_ber_ch.tcl" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" ]

adi_project_run ad_gmsl2eth_sl_k26
