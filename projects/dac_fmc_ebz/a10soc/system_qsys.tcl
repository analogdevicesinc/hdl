###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dac_fifo_address_width 13

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_system_qsys.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_plddr4_dacfifo_qsys.tcl

if [info exists ad_project_dir] {
  source ../../common/dac_fmc_ebz_qsys.tcl
} else {
  source ../common/dac_fmc_ebz_qsys.tcl
}

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "$mem_init_sys_file_path/mem_init_sys.txt"
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set sys_cstring "JESD:L=$ad_project_params(JESD_L)\
MODE=$ad_project_params(MODE)\
DEVICE=$ad_project_params(DEVICE)\
DEVICE_CODE=$ad_project_params(DEVICE_CODE)\
DAC_FIFO_ADDR_WIDTH=$dac_fifo_address_width"

sysid_gen_sys_init_file sys_cstring
