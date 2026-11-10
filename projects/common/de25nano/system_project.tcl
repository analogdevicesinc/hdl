###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project template_de25nano

source $ad_hdl_dir/projects/common/de25nano/de25nano_system_assign.tcl

execute_flow -compile
