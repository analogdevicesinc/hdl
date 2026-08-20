###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

set ADC_N_BITS [get_env_param ADC_N_BITS 20]

adi_project admfm8000_evalz_zed 0 [list \
	ADC_N_BITS $ADC_N_BITS]
adi_project_files admfm8000_evalz_zed [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v"]

adi_project_run admfm8000_evalz_zed
