
source $ad_hdl_dir/projects/common/mitx045/mitx045_system_bd.tcl
source ../common/fmcomms2_bd.tcl

set_property CONFIG.ADC_INIT_DELAY 20 [get_bd_cells axi_ad9361]

