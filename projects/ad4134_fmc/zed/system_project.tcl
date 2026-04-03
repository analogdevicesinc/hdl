###############################################################################
## Copyright (C) 2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description:
#
# NUM_OF_SDI : Number of SDI lines (maps to DIGITAL_INTERFACE_CONFIG Format field)
#
#   1 - Minimum I/O mode (Format 0x0): single-channel daisy-chain, all data
#       multiplexed on DOUT0/DEC3_SDO, DCLK externally tied to FORMAT1/SCLK
#   2 - Dual-channel daisy-chain mode (Format 0x1): data from Ch0/Ch1 on DOUT0,
#       data from Ch2/Ch3 on DOUT1
#   4 - Quad-channel parallel output mode (Format 0x2): each ADC channel has a
#       dedicated data output pin (DOUT0..DOUT3)
#

set NUM_OF_SDI [get_env_param NUM_OF_SDI 4]

adi_project ad4134_fmc_zed 0 [list \
  NUM_OF_SDI  $NUM_OF_SDI ]

adi_project_files ad4134_fmc_zed [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "system_top.v" \
    "system_constr.xdc"]

switch $NUM_OF_SDI {
  1 {
    adi_project_files ad4134_fmc_zed [list \
      "system_constr_1sdi.xdc" ]
  }
  2 {
    adi_project_files ad4134_fmc_zed [list \
      "system_constr_2sdi.xdc" ]
  }
  4 {
    adi_project_files ad4134_fmc_zed [list \
      "system_constr_4sdi.xdc" ]
  }
}

adi_project_run ad4134_fmc_zed
