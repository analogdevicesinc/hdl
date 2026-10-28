###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set p_device "xc7a200tsbg484-1"
set sys_zynq 0

adi_project powerup_s_eliza_xc7a200t

adi_project_files powerup_s_eliza_xc7a200t [list \
  "system_top.v" \
  "system_constr.xdc" \
]

set_property used_in_synthesis false [get_files "$ad_hdl_dir/projects/powerup_s_eliza/xc7a200t/system_constr.xdc"]

# adi_project_run powerup_s_eliza_xc7a200t
