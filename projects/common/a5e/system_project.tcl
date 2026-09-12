###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project template_a5e

source $ad_hdl_dir/projects/common/a5e/a5e_system_assign.tcl

execute_flow -compile
