source $ad_hdl_dir/projects/common/hanpilot/hanpilot_system_qsys.tcl
source ../common/fmcomms2_qsys.tcl

set_instance_parameter_value sys_spi {clockPolarity} {1}
set_instance_parameter_value axi_ad9361 {MODE_1R1T} {1}
