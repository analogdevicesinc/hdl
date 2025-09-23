###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/coraz7s/coraz7s_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl
global ad_project_params

# Add custom IP: axi_gpio_adi
ad_ip_instance axi_gpio_adi axi_gpio_adi_0

# Conectam la AXI GP0 interconnect
ad_cpu_interconnect 0x43C00000 axi_gpio_adi_0

# GPIO connections
# Cream 3 porturi separate (stil Xilinx)
create_bd_port -dir I  -from 31 -to 0 gpio_i
create_bd_port -dir O  -from 31 -to 0 gpio_o
create_bd_port -dir O  -from 31 -to 0 gpio_t
create_bd_port -dir O irq_0

# Conecteaza IP-ul tau la porturile fizice
ad_connect gpio_i axi_gpio_adi_0/gpio_io_i 
ad_connect gpio_o axi_gpio_adi_0/gpio_io_o 
ad_connect gpio_t axi_gpio_adi_0/gpio_io_t 
ad_connect irq_0 axi_gpio_adi_0/irq 

# Conectare AXI clock si reset la IP-ul axi_gpio_adi_0
if {![llength [get_bd_nets -of_objects [get_bd_pins axi_gpio_adi_0/s_axi_aclk]]]} {
  ad_connect axi_gpio_adi_0/s_axi_aclk sys_cpu_clk
}
if {![llength [get_bd_nets -of_objects [get_bd_pins axi_gpio_adi_0/s_axi_aresetn]]]} {
  ad_connect axi_gpio_adi_0/s_axi_aresetn sys_cpu_resetn
}
ad_connect sys_cpu_clk axi_gp0_interconnect/M02_ACLK


