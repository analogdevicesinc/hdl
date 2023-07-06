###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_system_qsys.tcl

if [info exists ad_project_dir] {
  source ../../common/adrv9001_qsys.tcl
} else {
  source ../common/adrv9001_qsys.tcl
}

set_instance_parameter_value sys_spi {clockPolarity} {0}

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "[pwd]/mem_init_sys.txt"

set sys_cstring "sys rom custom string placeholder";
sysid_gen_sys_init_file $sys_cstring;
