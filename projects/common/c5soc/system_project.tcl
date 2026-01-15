###############################################################################
## Copyright (C) 2022-2023, 2025-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project template_c5soc

source $ad_hdl_dir/projects/common/c5soc/c5soc_system_assign.tcl

execute_flow -compile
