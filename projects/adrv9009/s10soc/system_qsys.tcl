
set dac_fifo_address_width 10
set xcvr_reconfig_addr_width 11

source $ad_hdl_dir/projects/common/s10soc/s10soc_system_qsys.tcl
source $ad_hdl_dir/projects/common/intel/dacfifo_qsys.tcl

if [info exists ad_project_dir] {
  source ../../common/adrv9009_qsys.tcl
} else {
  source ../common/adrv9009_qsys.tcl
}
