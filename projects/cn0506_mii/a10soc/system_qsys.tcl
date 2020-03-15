
source $ad_hdl_dir/projects/scripts/adi_sysid_intel.tcl
source $ad_hdl_dir/projects/common/a10soc/a10soc_system_qsys.tcl
source ../common/cn0506_qsys.tcl

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "[pwd]/mem_init_sys.txt"

set sys_cstring "sys rom custom string placeholder";
sysid_gen_sys_init_file $sys_cstring;

