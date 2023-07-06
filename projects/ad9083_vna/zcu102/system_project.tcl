###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

#   Use over-writable parameters from the environment.
#
#    e.g.
#      make RX_JESD_L=4 RX_JESD_M=16

# Parameter description:
#   [RX]_JESD_M : Number of converters per link
#   [RX]_JESD_L : Number of lanes per link
#   [RX]_JESD_S : Number of samples per frame

adi_project ad9083_vna_zcu102 0 [list \
  RX_JESD_L    [get_env_param RX_JESD_L    1 ] \
  RX_JESD_M    [get_env_param RX_JESD_M   32 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
]
adi_project_files ad9083_fmc_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_3w_spi.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run ad9083_vna_zcu102
