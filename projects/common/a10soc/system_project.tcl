###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project template_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl

execute_flow -compile
