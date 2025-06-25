###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
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
#      make INTF=0
#
# INTF  - Defines the interface type (serial OR parallel)
#       - 0 - parallel (default)
#       - 1 - serial
# NUM_OF_SDI - Number of SDI lines used when **serial interface** is set
#       - 1 - one SDI line
#       - 2 - two SDI lines (default)
#
# NOTE : This switch is a 'hardware' switch. Please rebuild the design if the
# variable has been changed.
#     SL5 - mounted - Serial
#     SL5 - unmounted - Parallel
#
##--------------------------------------------------------------

set INTF [get_env_param INTF 0]
set NUM_OF_SDI [get_env_param NUM_OF_SDI 2]

adi_project ad7616_sdz_zed 0 [list \
   INTF $INTF \
   NUM_OF_SDI $NUM_OF_SDI \
]

adi_project_files ad7616_sdz_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

switch $INTF {
  1 {
    switch $NUM_OF_SDI {
      1 {
        adi_project_files ad7616_sdz_zed [list \
        "system_top_si.v" \
        "system_constr_serial_sdi1.xdc"]
      }
      2 {
        adi_project_files ad7616_sdz_zed [list \
        "system_top_si.v" \
        "system_constr_serial_sdi2.xdc"]
      }
    }
  }
  0 {
    adi_project_files ad7616_sdz_zed [list \
      "system_top_pi.v" \
      "system_constr_parallel.xdc"
    ]
  }
}

adi_project_run ad7616_sdz_zed
