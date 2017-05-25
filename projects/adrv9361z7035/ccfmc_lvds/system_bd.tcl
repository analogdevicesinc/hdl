
source ../common/adrv9361z7035_bd.tcl
source ../common/ccfmc_bd.tcl

cfg_ad9361_interface LVDS

create_bd_port -dir O sys_cpu_clk_out
ad_connect  sys_cpu_clk sys_cpu_clk_out

ad_ip_parameter axi_ad9361 CONFIG.ADC_INIT_DELAY 29

