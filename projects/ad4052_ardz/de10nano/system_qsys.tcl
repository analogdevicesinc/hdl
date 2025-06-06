###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/de10nano/de10nano_system_qsys.tcl
source ../common/ad4052_qsys.tcl

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "$mem_init_sys_file_path/mem_init_sys.txt"

sysid_gen_sys_init_file

# Set a lower limit than the default of 4 for pipeline stages on the memory-mapped interconnect
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
