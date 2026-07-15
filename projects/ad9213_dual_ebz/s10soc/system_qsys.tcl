###############################################################################
## Copyright (C) 2019-2023, 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set adc_data_offload_type 0                      ; ## BRAM
set adc_data_offload_size [expr 1024*1024]       ; ## 1 MB

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/s10soc/s10soc_system_qsys.tcl

if [info exists ad_project_dir] {
  source ../../common/ad9213_dual_qsys.tcl
} else {
  source ../common/ad9213_dual_qsys.tcl
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
