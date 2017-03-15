
source ../common/pzsdr1_bd.tcl
source ../common/ccbrk_bd.tcl

cfg_ad9361_interface LVDS

set_property CONFIG.ADC_INIT_DELAY 30 [get_bd_cells axi_ad9361]

