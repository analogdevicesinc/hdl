###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl
set ADI_POST_ROUTE_SCRIPT [file normalize $ad_hdl_dir/projects/scripts/auto_timing_fix_xilinx.tcl]

set ADC_N_BITS [get_env_param ADC_N_BITS 20]
set SPI_SLAVE [get_env_param SPI_SLAVE 0]

adi_project ad4080_fmc_evb_zed 0 [list \
  ADC_N_BITS $ADC_N_BITS \
  SPI_SLAVE $SPI_SLAVE \
]

adi_project_files ad4080_fmc_evb_zed [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.xdc" \
  "system_top.v" ]

if {$SPI_SLAVE == 1} {
  adi_project_files ad4080_fmc_evb_zed [list "system_constr_spi_slave.xdc" ]
  set_property verilog_define {SPI_SLAVE} [current_fileset]
}

adi_project_run ad4080_fmc_evb_zed
