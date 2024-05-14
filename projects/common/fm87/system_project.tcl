###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project template_fm87

source $ad_hdl_dir/projects/common/fm87/fm87_system_assign.tcl

set_global_assignment -name VERILOG_FILE $ad_hdl_dir/projects/common/fm87/gpio_slave.v

execute_flow -compile
