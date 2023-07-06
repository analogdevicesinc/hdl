###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set REQUIRED_QUARTUS_VERSION 22.1std.0
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project adv7513_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

execute_flow -compile
