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
#       - Default value is 0
#  - Options: Serial    - 1
#             Parallel  - 0
# NUM_OF_SDI - Number of SDI lines used
#  - Options: 1, 2
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
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

switch $INTF {
  1 {
    switch $NUM_OF_SDI {
      1 {
        adi_project_files ad7616_sdz_zed [list \
        "system_top_si.v" \
        "serial_if_constr_spi_1.xdc"]
      }
      2 {
        adi_project_files ad7616_sdz_zed [list \
        "system_top_si.v" \
        "serial_if_constr_spi_2.xdc"]
      }
    }
  }
  0 {
    adi_project_files ad7616_sdz_zed [list \
      "system_top_pi.v" \
      "parallel_if_constr.xdc"
    ]
  }
}

adi_project_run ad7616_sdz_zed
