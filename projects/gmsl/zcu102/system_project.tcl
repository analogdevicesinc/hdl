source ../../../scripts/adi_env.tcl

set corundum_dir_common [file normalize [file join [file dirname [info script]] "../../../corundum/fpga/common"]]
set corundum_dir_mod [file normalize [file join [file dirname [info script]] "../../../corundum/fpga/lib"]]
set corundum_dir_zcu102 [file normalize [file join [file dirname [info script]] "../../../corundum/fpga/mqnic/ZCU102/fpga"]]

source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project gmsl_zcu102
adi_project_files gmsl8_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$corundum_dir_zcu102/fpga.xdc" \
  "$corundum_dir_mod/eth/lib/axis/syn/vivado/axis_async_fifo.tcl" \
  "$corundum_dir_common/syn/vivado/mqnic_port.tcl" \
  "$corundum_dir_common/syn/vivado/mqnic_ptp_clock.tcl" \
  "$corundum_dir_common/syn/vivado/mqnic_rb_clk_info.tcl" \
  "$corundum_dir_mod/eth/syn/vivado/ptp_clock_cdc.tcl" \
  "$corundum_dir_common/syn/vivado/rb_drp.tcl" \
  "$corundum_dir_mod/eth/lib/axis/syn/vivado/sync_reset.tcl" \
  "$corundum_dir_common/syn/vivado/tdma_ber_ch.tcl" \
  "$corundum_dir_common/syn/vivado/eth_xcvr_phy_10g_gty_wrapper.tcl" \
  "$corundum_dir_mod/eth/lib/axis/rtl/sync_reset.v" \
  "$corundum_dir_mod/eth/lib/axis/syn/vivado/sync_reset.tcl" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]


adi_project_run gmsl_zcu102
