###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make RX_JESD_L=4 RX_JESD_M=4

# To have multichip synchronization, we will be treating the two links as one,
# thus L and M parameters are doubled!
# Parameter description:
#   RX_JESD_M: number of converters
#   RX_JESD_L: number of lanes
#   RX_JESD_S: number of samples per frame

adi_project ad9694_fmc_zcu102 0 [list \
  RX_JESD_M    [get_env_param RX_JESD_M    4 ] \
  RX_JESD_L    [get_env_param RX_JESD_L    4 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
]

adi_project_files ad9694_fmc_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run ad9694_fmc_zcu102
