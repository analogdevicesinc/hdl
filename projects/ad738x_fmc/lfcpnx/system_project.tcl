###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_lattice.tcl


adi_project ad738x_fmc_lfcpnx
adi_project_files_default ad738x_fmc_lfcpnx

adi_project_files ad738x_fmc_lfcpnx -flist [list \
  system_top.v \
  ../../common/lfcpnx/lfcpnx_system_constr.pdc \
  system_constr.pdc]

adi_project_run ad738x_fmc_lfcpnx \
  -cmd_list { \
    {prj_clean_impl -impl $impl} \
    {prj_set_strategy_value -strategy Strategy1 bit_ip_eval=True} \
    {prj_set_strategy_value -strategy Strategy1 syn_frequency=100}
  }
