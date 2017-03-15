
source ../common/pzsdr2_bd.tcl
source ../common/ccbrk_bd.tcl

set_property -dict [list CONFIG.SEL_0_DIV {2}] $clkdiv
set_property -dict [list CONFIG.SEL_1_DIV {1}] $clkdiv

cfg_ad9361_interface CMOS

set_property CONFIG.ADC_INIT_DELAY 29 [get_bd_cells axi_ad9361]

