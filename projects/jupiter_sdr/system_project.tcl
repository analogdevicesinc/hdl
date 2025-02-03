###############################################################################
## Copyright (C) 2021-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
################################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set p_device xczu3eg-sfva625-2-e

set sys_zynq 2

# 0 = Tx1 SSI reference clock
# 1 = Rx1 clocks
# 2 = Rx2 clocks
set USE_RX_CLK_FOR_TX1 [get_env_param USE_RX_CLK_FOR_TX1 0]
# 0 = Tx2 SSI reference clock
# 1 = Rx1 clocks
# 2 = Rx2 clocks
set USE_RX_CLK_FOR_TX2 [get_env_param USE_RX_CLK_FOR_TX2 0]

adi_project jupiter_sdr 0 [list \
  USE_RX_CLK_FOR_TX1 $USE_RX_CLK_FOR_TX1 \
  USE_RX_CLK_FOR_TX2 $USE_RX_CLK_FOR_TX2 \
]

adi_project_files jupiter_sdr [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" ]

adi_project_run jupiter_sdr
