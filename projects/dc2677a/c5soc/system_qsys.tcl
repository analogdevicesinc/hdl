###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/c5soc/c5soc_system_qsys.tcl
set xilinx_intel_n 0
source $ad_hdl_dir/projects/dc2677a/common/dc2677a_qsys.tcl

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "[pwd]/mem_init_sys.txt"

set sys_cstring "LVDS_CMOS_N=${ad_project_params(LVDS_CMOS_N)}"
sysid_gen_sys_init_file $sys_cstring
