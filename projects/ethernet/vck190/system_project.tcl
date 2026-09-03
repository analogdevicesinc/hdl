###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Corundum-on-Versal reference project for the VCK190 (xcvc1902), MRMAC over GTY.
# The GTY sibling of ethernet_vpk180 (MRMAC over GTM): the block design
# (system_bd.tcl) sources the CIPS/NoC carrier base and the shared Corundum
# integrator; this file adds the HDL/constraint sources and runs the flow. Naming
# the project "..._vck190" auto-selects the correct part (xcvc1902-vsva2197-2MP-e-S).

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ethernet_vck190

adi_project_files ethernet_vck190 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vck190/vck190_system_constr.xdc" \
]

# Corundum scoped constraints. corundum_core's RTL modules (mqnic_port, the PTP
# leaf/rel2tod cores, the async FIFOs, the register-block clock-info, and the
# sync_reset helper) carry timing/CDC constraints as project-level constraint
# tcls (get_cells -hier -filter ORIG_REF_NAME==...); they are NOT packaged into
# the IP, so a consumer must add them to constrs_1 exactly as the VCU118 consumer
# does. Only the board-independent set is needed here - the CMAC-specific tcls
# (cmac_gty_wrapper, cmac_gty_ch_wrapper, rb_drp, boot.xdc) belong to the CMAC
# path and are replaced by the MRMAC BD companion network on Versal.
#
# mrmac_gty_wrapper.tcl is the MRMAC counterpart of the CMAC path's
# cmac_gty_wrapper.tcl: it constrains the wrapper's own CDC (the three
# sync_reset chains, the mrmac_ptp_sync systemtimer bus into MRMAC's ts_clk
# domain, and the MRMAC status bits into mqnic_port's first synchronizer stage).
# Without it those crossings are timed as ordinary logic and post-route setup
# fails by >2 ns in the **async_default** / clkout*_primitive path groups, with
# every failing endpoint a synchronizer flop -- measured on this project.
#
# sync_reset.tcl is the same ADI global file the VCU118 Corundum consumer adds
# (ad9081_fmca_ebz/vcu118/system_project.tcl); it covers the sync_reset
# instances elsewhere in the hierarchy that the wrapper-scoped file does not.
add_files -fileset constrs_1 -norecurse [list \
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

adi_project_run ethernet_vck190
