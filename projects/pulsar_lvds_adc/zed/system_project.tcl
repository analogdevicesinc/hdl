###############################################################################
## Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# load script
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# RESOLUTION_16_18N - The resolution of the ADC
# LEGEND: 18 BITS RESOLUTION AD7960 - 0
#         16 BITS RESOLUTION AD7626 - 1

adi_project pulsar_lvds_adc_zed 0 [list \
  RESOLUTION_16_18N [get_env_param RESOLUTION_16_18N 0] \
]

adi_project_files pulsar_lvds_adc_zed [list \
  "$ad_hdl_dir/library/xilinx/common/ad_data_clk.v" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.xdc" \
  ]

 switch [get_env_param RESOLUTION_16_18N 0] {
  0 {
    adi_project_files pulsar_lvds_adc_zed [list \
      "system_top_ad7960.v" \
      "system_constr_18b.xdc" \
      ]
  }
  1 {
    adi_project_files pulsar_lvds_adc_zed [list \
      "system_top_ad7626.v" \
      "system_constr_16b.xdc" \
      ]
  }
}

adi_project_run pulsar_lvds_adc_zed
