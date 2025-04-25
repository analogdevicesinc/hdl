###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# The get_env_param procedure retrieves parameter value from the environment if exists,
# other case returns the default value specified in its second parameter field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make CMOS_LVDS_N=0
#     or
#      make CMOS_LVDS_N=1
#
#
# Parameter description:
#   CMOS_LVDS_N - type of interface
#         0 - LVDS
#         1 - CMOS

set CMOS_LVDS_N [get_env_param CMOS_LVDS_N 0]

# USE_RX_CLK_FOR_TXn
# 0 = Txn SSI reference clock
# 1 = Rx1 clocks
# 2 = Rx2 clocks

adi_project adrv9001_dual_zcu102 0 [list \
  CMOS_LVDS_N $CMOS_LVDS_N \
  USE_RX_CLK_FOR_TX1     [get_env_param USE_RX_CLK_FOR_TX1   0] \
  USE_RX_CLK_FOR_TX2     [get_env_param USE_RX_CLK_FOR_TX2   0] \
]

adi_project_files {} [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

if {$CMOS_LVDS_N == 0} {
  adi_project_files {} [list \
    "lvds_constr.xdc" \
  ]
} else {
  adi_project_files {} [list \
    "cmos_constr.xdc" \
  ]
}

adi_project_run adrv9001_dual_zcu102

