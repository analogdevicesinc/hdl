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
#      make TX_JESD_L=4 RX_OS_JESD_M=8
#      make TX_JESD_M=8 TX_JESD_L=4 RX_JESD_M=8 RX_JESD_L=2 RX_OS_JESD_M=4 RX_OS_JESD_L=2
#      make TX_JESD_M=4 TX_JESD_L=2 RX_JESD_M=8 RX_JESD_L=2 RX_OS_JESD_M=4 RX_OS_JESD_L=2

# Parameter description:
#   [TX/RX/RX_OS]_JESD_M : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample
#

adi_project fmcomms8_zcu102 0 [list \
  RX_JESD_M       [get_env_param RX_JESD_M     8 ] \
  RX_JESD_L       [get_env_param RX_JESD_L     4 ] \
  RX_JESD_S       [get_env_param RX_JESD_S     1 ] \
  TX_JESD_M       [get_env_param TX_JESD_M     8 ] \
  TX_JESD_L       [get_env_param TX_JESD_L     8 ] \
  TX_JESD_S       [get_env_param TX_JESD_S     1 ] \
  RX_OS_JESD_M    [get_env_param RX_OS_JESD_M  4 ] \
  RX_OS_JESD_L    [get_env_param RX_OS_JESD_L  4 ] \
  RX_OS_JESD_S    [get_env_param RX_OS_JESD_S  1 ] \
]
adi_project_files  fmcomms8_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "../common/fmcomms8_spi.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run fmcomms8_zcu102
