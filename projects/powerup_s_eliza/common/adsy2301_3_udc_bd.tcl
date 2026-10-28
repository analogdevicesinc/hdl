###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Clocking

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 clk_in
set_property CONFIG.FREQ_HZ 156250000 [get_bd_intf_ports clk_in]
create_bd_port -dir O -type clk clk_out

ad_ip_instance clk_wiz clk_wizard [list \
  PRIM_SOURCE "Differential_clock_capable_pin" \
  CLKOUT1_REQUESTED_OUT_FREQ 100 \
  CLKOUT2_USED true \
  NUM_OUT_CLKS 2 \
  CLKOUT2_REQUESTED_OUT_FREQ 20 \
]

ad_connect clk_wizard/CLK_IN1_D clk_in
ad_connect clk_wizard/reset GND
ad_connect sys_cpu_clk clk_wizard/clk_out1

ad_connect sys_cpu_clk clk_out

# Reset

create_bd_port -dir I -type rst ext_rst

ad_ip_instance proc_sys_reset sys_rstgen

ad_connect sys_rstgen/slowest_sync_clk sys_cpu_clk
ad_connect sys_rstgen/ext_reset_in ext_rst

ad_connect sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect sys_cpu_resetn sys_rstgen/peripheral_aresetn

# Interconnect

ad_ip_instance smartconnect axi_smartconnect [list \
  NUM_SI 1 \
  NUM_MI 16 \
]

ad_connect axi_smartconnect/aclk sys_cpu_clk
ad_connect axi_smartconnect/aresetn sys_cpu_resetn

# Interrupt control

ad_ip_instance axi_intc axi_intc [list \
  C_HAS_FAST 0 \
  C_IRQ_CONNECTION 1 \
]

ad_ip_instance ilconcat sys_concat_intc [list \
  NUM_PORTS 9 \
]

ad_connect axi_intc/s_axi_aclk sys_cpu_clk
ad_connect axi_intc/s_axi_aresetn sys_cpu_resetn

ad_connect axi_intc/intr sys_concat_intc/dout

ad_connect axi_smartconnect/M00_AXI axi_intc/s_axi

# GPIO

ad_ip_instance axi_gpio axi_gpio0 [list \
  C_IS_DUAL 1 \
  C_ALL_OUTPUTS 1 \
  C_GPIO_WIDTH 32 \
  C_ALL_INPUTS_2 1 \
  C_GPIO2_WIDTH 32 \
]

ad_connect axi_gpio0/gpio_io_o axi_gpio0/gpio2_io_i

ad_connect axi_gpio0/s_axi_aclk sys_cpu_clk
ad_connect axi_gpio0/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M01_AXI axi_gpio0/S_AXI
