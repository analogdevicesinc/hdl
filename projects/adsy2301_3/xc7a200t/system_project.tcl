###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set p_device "xc7a200tsbg484-1"
set sys_zynq 0

adi_project adsy2301_3_xc7a200t

adi_project_files adsy2301_3_xc7a200t [list \
  "system_top.v" \
  "system_constr.xdc" \
  "system_constr_synth.xdc" \
]

set_property used_in_synthesis false [get_files "$ad_hdl_dir/projects/adsy2301_3/xc7a200t/system_constr.xdc"]

adi_project_run adsy2301_3_xc7a200t
