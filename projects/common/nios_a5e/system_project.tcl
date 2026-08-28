###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project template_nios_a5e

source $ad_hdl_dir/projects/common/nios_a5e/nios_a5e_system_assign.tcl

execute_flow -compile
