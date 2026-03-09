###############################################################################
## Copyright (C) 2016-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dac_data_offload_type 1                      ; ## PL_DDR
set dac_data_offload_size [expr 1024*1024*1024]  ; ## 1 GB
set dac_axi_data_width 128

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_system_qsys.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_plddr4_data_offload_qsys.tcl

if [info exists ad_project_dir] {
  source ../../common/adrv9009_qsys.tcl
} else {
  source ../common/adrv9009_qsys.tcl
}

ad_data_offload_create $dac_data_offload_name

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "$mem_init_sys_file_path/mem_init_sys.txt"
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set sys_cstring "DAC_OFFLOAD:TYPE=$dac_data_offload_type\
SIZE=$dac_data_offload_size"

sysid_gen_sys_init_file $sys_cstring
