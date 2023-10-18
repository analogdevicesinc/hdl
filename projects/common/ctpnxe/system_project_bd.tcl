###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice_bd.tcl

# getting the projects name that is defined in Makefile like PROJECT_NAME
if {$argc == 1} {
  set project_name [lindex $argv 0]
}

# {source ./system_bd.tcl} is the default cmd.
adi_project_bd $project_name -ppath ./ -cmd_list { \
  {source ./system_bd.tcl}}
