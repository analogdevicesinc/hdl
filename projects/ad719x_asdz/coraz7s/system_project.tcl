###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set io_mod_n 0

if {[info exists ::env(IO_PMOD_N)]} {
  set io_pmod_n $::env(IO_PMOD_N)
} else {
  set env(IO_PMOD_N) $io_pmod_n
}

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad719x_asdz_coraz7s 0 [list \
  IO_PMOD_N $io_pmod_n \
]

adi_project_files ad719x_asdz_coraz7s [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/projects/common/coraz7s/coraz7s_system_constr.xdc" \
    "system_constr.tcl" \
    "system_top.v"
]

adi_project_run ad719x_asdz_coraz7s
