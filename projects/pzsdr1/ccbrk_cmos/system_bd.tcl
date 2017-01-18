
source ../common/pzsdr1_bd.tcl
source ../common/ccbrk_bd.tcl

set_property -dict [list CONFIG.SEL_0_DIV {BYPASS}] $clkdiv
set_property -dict [list CONFIG.SEL_1_DIV {BYPASS}] $clkdiv

cfg_ad9361_interface CMOS

