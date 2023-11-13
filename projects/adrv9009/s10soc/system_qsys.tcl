###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dac_fifo_address_width 10
set xcvr_reconfig_addr_width 11

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/s10soc/s10soc_system_qsys.tcl
source $ad_hdl_dir/projects/common/intel/dacfifo_qsys.tcl

if [info exists ad_project_dir] {
  source ../../common/adrv9009_qsys.tcl
} else {
  source ../common/adrv9009_qsys.tcl
}

#system ID

if {[info exists ::env(ADI_PROJECT_DIR)]} {
  set mem_init_sys_file_path "$::env(ADI_PROJECT_DIR)mem_init_sys.txt";
} else {
  set mem_init_sys_file_path mem_init_sys.txt;
}

set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} $mem_init_sys_file_path

sysid_gen_sys_init_file

