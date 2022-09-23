
set adc_fifo_address_width 15

source $ad_hdl_dir/projects/common/s10soc/s10soc_system_qsys.tcl
source $ad_hdl_dir/projects/common/intel/adcfifo_qsys.tcl

if [info exists ad_project_dir] {
  source ../../common/ad9213_dual_qsys.tcl
} else {
  source ../common/ad9213_dual_qsys.tcl
}
