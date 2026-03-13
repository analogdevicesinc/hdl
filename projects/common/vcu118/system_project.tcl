###############################################################################
## Copyright (C) 2014-2023, 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project template_vcu118 0 [list \
  CORUNDUM [get_env_param CORUNDUM 0] \
]

adi_project_files template_vcu118 [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" \
]

set_property used_in_synthesis false [get_files "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc"]

if {[get_env_param CORUNDUM 0] == 1} {
  adi_project_files template_vcu118 [list \
    "system_top_corundum.v" \
    "$ad_hdl_dir/projects/common/vcu118/vcu118_qsfp_system_constr.xdc" \
  ]

  add_files -fileset constrs_1 -norecurse [list \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/rb_drp.tcl" \
    "$ad_hdl_dir/library/corundum/scripts/sync_reset.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/cmac_gty_wrapper.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/cmac_gty_ch_wrapper.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl" \
    "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_port.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl" \
    "$ad_hdl_dir/../corundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl" \
  ]

  set_property used_in_synthesis false [get_files "$ad_hdl_dir/projects/common/vcu118/vcu118_qsfp_system_constr.xdc"]
} else {
  adi_project_files template_vcu118 [list \
    "system_top.v" \
  ]
}

adi_project_run template_vcu118
