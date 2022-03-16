###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

##--------------------------------------------------------------
# IMPORTANT: Set AD7616 operation and interface mode
#
# The get_env_param procedure retrieves parameter value from the environment if exists,
# other case returns the default value specified in its second parameter field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make SER_PAR_N=0
#
#    SER_PAR_N  - Defines the interface type (serial OR parallel)
#               - Default value is 1
#
# LEGEND: Serial    - 1
#         Parallel  - 0
#
# NOTE : This switch is a 'hardware' switch. Please rebuild the design if the
# variable has been changed.
#     SL5 - mounted - Serial
#     SL5 - unmounted - Parallel
#
##--------------------------------------------------------------

if {[info exists ::env(SER_PAR_N)]} {
  set S_SER_PAR_N [get_env_param SER_PAR_N 0]
} elseif {![info exists SER_PAR_N]} {
  set S_SER_PAR_N 1
}

adi_project ad7616_sdz_zed 0 [list \
  SER_PAR_N  $S_SER_PAR_N \
]

adi_project_files ad7616_sdz_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

switch $S_SER_PAR_N {
  1 {
    adi_project_files ad7616_sdz_zed [list \
      "system_top_si.v" \
      "serial_if_constr.xdc"
    ]
  }
  0 {
    adi_project_files ad7616_sdz_zed [list \
      "system_top_pi.v" \
      "parallel_if_constr.xdc"
    ]
  }
}

adi_project_run ad7616_sdz_zed
