###############################################################################
## Copyright (C) 2021-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set script_dir [file dirname [info script]]

source "$script_dir/util_cdc_constr.tcl"

set_false_path -to [get_registers *axi_pwm_gen_regmap*cdc_sync_stage1*]
set_false_path -to [get_registers *axi_pwm_gen_regmap*sync_data*out_data*]
