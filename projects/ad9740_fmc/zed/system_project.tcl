###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set DEVICE [get_env_param DEVICE "AD9744"]

# Convert DEVICE to DAC_RESOLUTION
switch $DEVICE {
  "AD9748" { set DAC_RESOLUTION 8 }
  "AD9740" { set DAC_RESOLUTION 10 }
  "AD9742" { set DAC_RESOLUTION 12 }
  "AD9744" { set DAC_RESOLUTION 14 }
  default  { set DAC_RESOLUTION 14 }
}

adi_project ad9740_fmc_zed 0 [list \
  DAC_RESOLUTION $DAC_RESOLUTION  \
  ]

adi_project_files ad9740_fmc_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
    "system_top.v" \
    "system_constr.xdc" \
    ]

adi_project_run ad9740_fmc_zed
