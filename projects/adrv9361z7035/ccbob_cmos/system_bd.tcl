
source ../common/adrv9361z7035_bd.tcl
source ../common/ccbob_bd.tcl

ad_ip_parameter util_ad9361_divclk CONFIG.SEL_0_DIV 2
ad_ip_parameter util_ad9361_divclk CONFIG.SEL_1_DIV 1

cfg_ad9361_interface CMOS

ad_ip_parameter axi_ad9361 CONFIG.ADC_INIT_DELAY 29

