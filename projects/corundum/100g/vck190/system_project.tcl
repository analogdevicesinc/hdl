###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project corundum_100g_vck190 0 [list \
  LOOPBACK [get_env_param LOOPBACK 0] \
]

adi_project_files corundum_100g_vck190 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vck190/vck190_system_constr.xdc" \
]

add_files -fileset constrs_1 -norecurse [list \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/rb_drp.tcl" \
  "$ad_hdl_dir/library/corundum/scripts/sync_reset.tcl" \
  "$ad_hdl_dir/library/corundum/scripts/mrmac_gty_wrapper.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_port.tcl" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl" \
  "system_constr.xdc" \
]

adi_project_run corundum_100g_vck190
