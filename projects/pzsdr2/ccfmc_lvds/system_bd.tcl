
source ../common/pzsdr2_bd.tcl
source ../common/ccfmc_bd.tcl

cfg_ad9361_interface LVDS

create_bd_port -dir O sys_cpu_clk_out
ad_connect  sys_cpu_clk sys_cpu_clk_out

