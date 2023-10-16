###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice_bd.tcl

# {source ./system_bd.tcl} is the default cmd.
adi_project_bd template_ctpnxe -ppath ./ -cmd_list { \
  {source ./system_bd.tcl}}
