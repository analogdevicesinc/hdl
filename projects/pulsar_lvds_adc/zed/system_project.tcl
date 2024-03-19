###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# load script
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# RESOLUTION_16_18N - The resolution of the ADC
# LEGEND: 18 BITS RESOLUTION AD7960 - 0
#         16 BITS RESOLUTION AD7626 - 1

set RESOLUTION_16_18N 0

if {[info exists ::env(RESOLUTION_16_18N)]} {
  set RESOLUTION_16_18N $::env(RESOLUTION_16_18N)
} else {
  set env(RESOLUTION_16_18N) $RESOLUTION_16_18N
}

adi_project pulsar_lvds_adc_zed 0 [list \
  RESOLUTION_16_18N  $RESOLUTION_16_18N \
]

adi_project_files pulsar_lvds_adc_zed [list \
  "system_constr.tcl" \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc"]

 switch $RESOLUTION_16_18N {
  0 {
    adi_project_files pulsar_lvds_adc_zed [list \
      "ad7960_system_top.v" ]
  }
  1 {
    adi_project_files pulsar_lvds_adc_zed [list \
      "ad7626_system_top.v" ]
  }
}

adi_project_run pulsar_lvds_adc_zed
