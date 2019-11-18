
source ../common/adrv9361z7035_bd.tcl
source ../common/ccbob_bd.tcl

ad_ip_parameter util_ad9361_divclk CONFIG.SEL_0_DIV 2
ad_ip_parameter util_ad9361_divclk CONFIG.SEL_1_DIV 1

cfg_ad9361_interface CMOS

ad_ip_parameter axi_ad9361 CONFIG.ADC_INIT_DELAY 29

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring
