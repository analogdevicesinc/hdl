
source ../common/pzsdr2_bd.tcl
source ../common/ccbrk_bd.tcl

ad_ip_parameter clkdiv CONFIG.SEL_0_DIV 2
ad_ip_parameter clkdiv CONFIG.SEL_1_DIV 1

cfg_ad9361_interface CMOS

ad_ip_parameter axi_ad9361 CONFIG.ADC_INIT_DELAY 29

