
source $ad_hdl_dir/projects/common/a5soc/a5soc_system_qsys.tcl
source ../common/fmcjesdadc1_qsys.tcl

set_instance_parameter_value avl_ad9250_xcvr {SYSCLK_FREQUENCY} {50.0}
save_system "system_bd.qsys"

