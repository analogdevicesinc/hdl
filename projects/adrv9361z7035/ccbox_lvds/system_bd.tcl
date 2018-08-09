
source ../common/adrv9361z7035_bd.tcl
source ../common/ccbox_bd.tcl

cfg_ad9361_interface LVDS

create_bd_port -dir O sys_cpu_clk_out
ad_connect  sys_cpu_clk sys_cpu_clk_out

set_property CONFIG.ADC_INIT_DELAY 29 [get_bd_cells axi_ad9361]

