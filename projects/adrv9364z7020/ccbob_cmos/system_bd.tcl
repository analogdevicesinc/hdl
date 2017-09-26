
source ../common/adrv9364z7020_bd.tcl
source ../common/ccbob_bd.tcl

ad_ip_parameter util_ad9361_divclk CONFIG.SEL_0_DIV 2
ad_ip_parameter util_ad9361_divclk CONFIG.SEL_1_DIV 1

cfg_ad9361_interface CMOS

set_property CONFIG.ADC_INIT_DELAY 30 [get_bd_cells axi_ad9361]

