
source $ad_hdl_dir/projects/common/ac701/ac701_system_bd.tcl
source ../common/fmcomms2_bd.tcl

set_property CONFIG.ADC_INIT_DELAY 25 [get_bd_cells axi_ad9361]

