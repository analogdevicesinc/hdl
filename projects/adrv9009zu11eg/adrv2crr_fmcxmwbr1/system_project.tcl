###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

##-----------------------------------------------------------------------------
# IMPORTANT: Set interface mode
#
# The get_env_param procedure retrieves parameter value from the environment if
# exists, other case returns the default value specified in its second parameter
# field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make ADI_PRODUCTION = 1
#
#    ADI_PRODUCTION  - Defines the interface type (XMICROWAVE or FMCXMWBR1)
#
# LEGEND: 0 - XMICROWAVE - uses all the spi lines and gpios
#         1 - FMCXMWBR1 - used for production testing
#
##-----------------------------------------------------------------------------

set intf 0

if {[info exists ::env(ADI_PRODUCTION)]} {
  set intf $::env(ADI_PRODUCTION)
} else {
  set env(ADI_PRODUCTION) $intf
}

adi_project_create adrv9009zu11eg_fmcxmwbr1 0 [list \
  RX_JESD_M       [get_env_param RX_JESD_M     8] \
  RX_JESD_L       [get_env_param RX_JESD_L     4] \
  RX_JESD_S       [get_env_param RX_JESD_S     1] \
  TX_JESD_M       [get_env_param TX_JESD_M     8] \
  TX_JESD_L       [get_env_param TX_JESD_L     8] \
  TX_JESD_S       [get_env_param TX_JESD_S     1] \
  RX_OS_JESD_M    [get_env_param RX_OS_JESD_M  4] \
  RX_OS_JESD_L    [get_env_param RX_OS_JESD_L  4] \
  RX_OS_JESD_S    [get_env_param RX_OS_JESD_S  1] \
] "xczu11eg-ffvf1517-2-i"

adi_project_files adrv9009zu11eg_fmcxmwbr1 [list \
  "system_constr.xdc"\
  "../common/adrv9009zu11eg_spi.v" \
  "../common/adrv9009zu11eg_constr.xdc" \
  "../common/adrv2crr_fmc_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" ]

switch $intf {
  0 {
    adi_project_files adrv9009zu11eg_fmcxmwbr1 [list \
      "system_top_xmicrowave.v" ]
  }
  1 {
    adi_project_files adrv9009zu11eg_fmcxmwbr1 [list \
      "system_top_fmcxmwbr1.v" ]
  }
}

## To improve timing in DDR4 MIG
set_property strategy Performance_ExploreWithRemap [get_runs impl_1]

adi_project_run adrv9009zu11eg_fmcxmwbr1
