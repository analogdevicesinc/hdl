###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice_pb.tcl

## Default options for adi_project_pb #########################################
## if the -dev_select "manual" then the -device, -speed and -board options can
## be set manually.
# adi_project_pb template_lfcpnx \
#     -dev_select "auto" \
#     -ppath "." \
#     -device "" \
#     -board "" \
#     -speed "" \
#     -language "verilog" \
#     -cmd_list {{source ./system_pb.tcl}}
#     -psc "${env(TOOLRTF)}/../../templates/MachXO3D_Template01/MachXO3D_Template01.psc"
adi_project_pb template_lfcpnx
