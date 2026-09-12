###############################################################################
## Copyright (C) 2020-2023, 2025 Analog Devices, Inc. All rights reserved.
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
#      make USE_RX_CLK_FOR_TX1=0 USE_RX_CLK_FOR_TX2=0
#
# 0 = Tx1 SSI reference clock
# 1 = Rx1 clocks
# 2 = Rx2 clocks
set USE_RX_CLK_FOR_TX1 [get_env_param USE_RX_CLK_FOR_TX1 0]
# 0 = Tx2 SSI reference clock
# 1 = Rx1 clocks
# 2 = Rx2 clocks
set USE_RX_CLK_FOR_TX2 [get_env_param USE_RX_CLK_FOR_TX2 0]

adi_project adrv9001_zc706 0 [list \
  CMOS_LVDS_N 1 \
  USE_RX_CLK_FOR_TX1 $USE_RX_CLK_FOR_TX1 \
  USE_RX_CLK_FOR_TX2 $USE_RX_CLK_FOR_TX2 \
]

adi_project_files adrv9001_zc706 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "cmos_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

set_property PROCESSING_ORDER LATE [get_files system_constr.xdc]

adi_project_run adrv9001_zc706

