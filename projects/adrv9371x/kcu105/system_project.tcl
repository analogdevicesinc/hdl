###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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
#      make RX_JESD_L=4 RX_JESD_M=2 TX_JESD_L=4 TX_JESD_M=2 

# Parameter description:
#   [TX/RX/RX_OS]_JESD_M : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample

adi_project adrv9371x_kcu105 0 [list \
  TX_JESD_M       [get_env_param TX_JESD_M       4 ] \
  TX_JESD_L       [get_env_param TX_JESD_L       4 ] \
  TX_JESD_S       [get_env_param TX_JESD_S       1 ] \
  RX_JESD_M       [get_env_param RX_JESD_M       4 ] \
  RX_JESD_L       [get_env_param RX_JESD_L       2 ] \
  RX_JESD_S       [get_env_param RX_JESD_S       1 ] \
  RX_OS_JESD_M    [get_env_param RX_OS_JESD_M    2 ] \
  RX_OS_JESD_L    [get_env_param RX_OS_JESD_L    2 ] \
  RX_OS_JESD_S    [get_env_param RX_OS_JESD_S    1 ] \
]

adi_project_files adrv9371x_kcu105 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/common/ad_bus_mux.v" \
  "$ad_hdl_dir/library/common/util_pulse_gen.v" \
  "$ad_hdl_dir/projects/common/kcu105/kcu105_system_constr.xdc" \
  "$ad_hdl_dir/projects/common/kcu105/kcu105_system_lutram_constr.xdc" ]

## To improve timing in DDR4 MIG
set_property strategy Performance_RefinePlacement [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE ExploreWithAggressiveHoldFix [get_runs impl_1]

adi_project_run adrv9371x_kcu105
