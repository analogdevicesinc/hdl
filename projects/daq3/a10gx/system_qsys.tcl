set dac_fifo_address_width 10

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/a10gx/a10gx_system_qsys.tcl
source $ad_hdl_dir/projects/common/intel/dacfifo_qsys.tcl

if [info exists ad_project_dir] {
  source ../../common/daq3_qsys.tcl
} else {
  source ../common/daq3_qsys.tcl
}

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "[pwd]/mem_init_sys.txt"

sysid_gen_sys_init_file;

