###############################################################################
## Copyright (C) 2023 - 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice_bd.tcl

# getting the projects name that is defined in Makefile like PROJECT_NAME
if {$argc == 1} {
  set project_name [lindex $argv 0]
}

## Default options for adi_project_bd #########################################
## if the -dev_select "manual" then the -device, -speed and -board options can
## be set manually.
# adi_project_bd $project_name \
#     -dev_select "auto" \
#     -ppath "." \
#     -device "" \
#     -board "" \
#     -speed "" \
#     -language "verilog" \
#     -cmd_list {{source ./system_bd.tcl}}
#     -psc "${env(TOOLRTF)}/../../templates/MachXO3D_Template01/MachXO3D_Template01.psc"
adi_project_bd $project_name