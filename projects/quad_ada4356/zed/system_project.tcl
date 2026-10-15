###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description:
#   TDD_SUPPORT : capture mode
#      1 - axi_tdd gates the four DMAs, triggered/one-shot capture (default)
#      0 - DMAs free-run, continuous capture, no axi_tdd instance
#   SHARED_DCO : capture clocking
#      0 - each ADC captured on its own DCO (default)
#      1 - all four captured on ADC B's DCO, one adc_clk for every core and DMA
#
#    e.g.
#      make TDD_SUPPORT=0
#      make TDD_SUPPORT=1 SHARED_DCO=1

adi_project quad_ada4356_zed 0 [list \
  TDD_SUPPORT [get_env_param TDD_SUPPORT 1] \
  SHARED_DCO  [get_env_param SHARED_DCO 0] \
]

adi_project_files quad_ada4356_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.xdc" \
  "system_top.v" ]

adi_project_run quad_ada4356_zed
