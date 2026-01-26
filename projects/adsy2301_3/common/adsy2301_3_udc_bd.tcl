###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Clocking

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 clk_in
set_property CONFIG.FREQ_HZ 125000000 [get_bd_intf_ports clk_in]
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
  NUM_PORTS 13 \
]

ad_connect axi_intc/s_axi_aclk sys_cpu_clk
ad_connect axi_intc/s_axi_aresetn sys_cpu_resetn

ad_connect axi_intc/intr sys_concat_intc/dout

ad_connect axi_smartconnect/M00_AXI axi_intc/s_axi

# GPIO

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_out1
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_out2
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_out3
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_in

ad_ip_instance axi_gpio axi_gpio0 [list \
  C_IS_DUAL 1 \
  C_ALL_OUTPUTS 1 \
  C_GPIO_WIDTH 30 \
  C_ALL_OUTPUTS_2 1 \
  C_GPIO2_WIDTH 32 \
]

ad_ip_instance axi_gpio axi_gpio1 [list \
  C_IS_DUAL 1 \
  C_ALL_OUTPUTS 1 \
  C_GPIO_WIDTH 4 \
  C_ALL_INPUTS_2 1 \
  C_GPIO2_WIDTH 15 \
]

ad_connect axi_gpio0/GPIO gpio_out1
ad_connect axi_gpio0/GPIO2 gpio_out2
ad_connect axi_gpio1/GPIO gpio_out3
ad_connect axi_gpio1/GPIO2 gpio_in

ad_connect axi_gpio0/s_axi_aclk sys_cpu_clk
ad_connect axi_gpio0/s_axi_aresetn sys_cpu_resetn
ad_connect axi_gpio1/s_axi_aclk sys_cpu_clk
ad_connect axi_gpio1/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M01_AXI axi_gpio0/S_AXI
ad_connect axi_smartconnect/M02_AXI axi_gpio1/S_AXI

# BF SPI 01

create_bd_port -dir O bf_spi_sclk_01
create_bd_port -dir O bf_spi_csb_01
create_bd_port -dir O bf_spi_mosi_01
create_bd_port -dir I bf_spi_miso_01

ad_ip_instance axi_quad_spi bf_spi_01 [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect bf_spi_01/sck_o bf_spi_sclk_01
ad_connect bf_spi_01/ss_o bf_spi_csb_01
ad_connect bf_spi_01/io0_o bf_spi_mosi_01
ad_connect bf_spi_01/io1_i bf_spi_miso_01

ad_connect bf_spi_01/s_axi_aclk sys_cpu_clk
ad_connect bf_spi_01/ext_spi_clk clk_wizard/clk_out2
ad_connect bf_spi_01/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M03_AXI bf_spi_01/AXI_LITE

ad_connect sys_concat_intc/In0 bf_spi_01/ip2intc_irpt

# BF SPI 02

create_bd_port -dir O bf_spi_sclk_02
create_bd_port -dir O bf_spi_csb_02
create_bd_port -dir O bf_spi_mosi_02
create_bd_port -dir I bf_spi_miso_02

ad_ip_instance axi_quad_spi bf_spi_02 [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect bf_spi_02/sck_o bf_spi_sclk_02
ad_connect bf_spi_02/ss_o bf_spi_csb_02
ad_connect bf_spi_02/io0_o bf_spi_mosi_02
ad_connect bf_spi_02/io1_i bf_spi_miso_02

ad_connect bf_spi_02/s_axi_aclk sys_cpu_clk
ad_connect bf_spi_02/ext_spi_clk clk_wizard/clk_out2
ad_connect bf_spi_02/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M04_AXI bf_spi_02/AXI_LITE

ad_connect sys_concat_intc/In1 bf_spi_02/ip2intc_irpt

# BF SPI 03

create_bd_port -dir O bf_spi_sclk_03
create_bd_port -dir O bf_spi_csb_03
create_bd_port -dir O bf_spi_mosi_03
create_bd_port -dir I bf_spi_miso_03

ad_ip_instance axi_quad_spi bf_spi_03 [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect bf_spi_03/sck_o bf_spi_sclk_03
ad_connect bf_spi_03/ss_o bf_spi_csb_03
ad_connect bf_spi_03/io0_o bf_spi_mosi_03
ad_connect bf_spi_03/io1_i bf_spi_miso_03

ad_connect bf_spi_03/s_axi_aclk sys_cpu_clk
ad_connect bf_spi_03/ext_spi_clk clk_wizard/clk_out2
ad_connect bf_spi_03/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M05_AXI bf_spi_03/AXI_LITE

ad_connect sys_concat_intc/In2 bf_spi_03/ip2intc_irpt

# BF SPI 04

create_bd_port -dir O bf_spi_sclk_04
create_bd_port -dir O bf_spi_csb_04
create_bd_port -dir O bf_spi_mosi_04
create_bd_port -dir I bf_spi_miso_04

ad_ip_instance axi_quad_spi bf_spi_04 [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect bf_spi_04/sck_o bf_spi_sclk_04
ad_connect bf_spi_04/ss_o bf_spi_csb_04
ad_connect bf_spi_04/io0_o bf_spi_mosi_04
ad_connect bf_spi_04/io1_i bf_spi_miso_04

ad_connect bf_spi_04/s_axi_aclk sys_cpu_clk
ad_connect bf_spi_04/ext_spi_clk clk_wizard/clk_out2
ad_connect bf_spi_04/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M06_AXI bf_spi_04/AXI_LITE

ad_connect sys_concat_intc/In3 bf_spi_04/ip2intc_irpt

# BF I2C 01

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 bf_iic_01

ad_ip_instance axi_iic axi_bf_iic_01

ad_connect axi_bf_iic_01/IIC bf_iic_01

ad_connect axi_bf_iic_01/s_axi_aclk sys_cpu_clk
ad_connect axi_bf_iic_01/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M07_AXI axi_bf_iic_01/S_AXI

ad_connect sys_concat_intc/In4 axi_bf_iic_01/iic2intc_irpt

# BF I2C 02

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 bf_iic_02

ad_ip_instance axi_iic axi_bf_iic_02

ad_connect axi_bf_iic_02/IIC bf_iic_02

ad_connect axi_bf_iic_02/s_axi_aclk sys_cpu_clk
ad_connect axi_bf_iic_02/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M08_AXI axi_bf_iic_02/S_AXI

ad_connect sys_concat_intc/In5 axi_bf_iic_02/iic2intc_irpt

# BF I2C 03

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 bf_iic_03

ad_ip_instance axi_iic axi_bf_iic_03

ad_connect axi_bf_iic_03/IIC bf_iic_03

ad_connect axi_bf_iic_03/s_axi_aclk sys_cpu_clk
ad_connect axi_bf_iic_03/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M09_AXI axi_bf_iic_03/S_AXI

ad_connect sys_concat_intc/In6 axi_bf_iic_03/iic2intc_irpt

# BF I2C 04

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 bf_iic_04

ad_ip_instance axi_iic axi_bf_iic_04

ad_connect axi_bf_iic_04/IIC bf_iic_04

ad_connect axi_bf_iic_04/s_axi_aclk sys_cpu_clk
ad_connect axi_bf_iic_04/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M10_AXI axi_bf_iic_04/S_AXI

ad_connect sys_concat_intc/In7 axi_bf_iic_04/iic2intc_irpt

# RF FL SPI

create_bd_port -dir O rf_fl_spi_sclk
create_bd_port -dir O -from 3 -to 0 rf_fl_spi_csb
create_bd_port -dir O rf_fl_spi_mosi
create_bd_port -dir I rf_fl_spi_miso

ad_ip_instance axi_quad_spi rf_fl_spi [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 4 \
  C_SCK_RATIO 2 \
]

ad_connect rf_fl_spi/sck_o rf_fl_spi_sclk
ad_connect rf_fl_spi/ss_o rf_fl_spi_csb
ad_connect rf_fl_spi/io0_o rf_fl_spi_mosi
ad_connect rf_fl_spi/io1_i rf_fl_spi_miso

ad_connect rf_fl_spi/s_axi_aclk sys_cpu_clk
ad_connect rf_fl_spi/ext_spi_clk clk_wizard/clk_out2
ad_connect rf_fl_spi/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M11_AXI rf_fl_spi/AXI_LITE

ad_connect sys_concat_intc/In8 rf_fl_spi/ip2intc_irpt

# LO SPI

create_bd_port -dir O lo_spi_sclk
create_bd_port -dir O lo_spi_csb
create_bd_port -dir O lo_spi_mosi
create_bd_port -dir I lo_spi_miso

ad_ip_instance axi_quad_spi lo_spi [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect lo_spi/sck_o lo_spi_sclk
ad_connect lo_spi/ss_o lo_spi_csb
ad_connect lo_spi/io0_o lo_spi_mosi
ad_connect lo_spi/io1_i lo_spi_miso

ad_connect lo_spi/s_axi_aclk sys_cpu_clk
ad_connect lo_spi/ext_spi_clk clk_wizard/clk_out2
ad_connect lo_spi/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M12_AXI lo_spi/AXI_LITE

ad_connect sys_concat_intc/In9 lo_spi/ip2intc_irpt

# TX SPI

create_bd_port -dir O tx_spi_sclk
create_bd_port -dir O -from 3 -to 0 tx_spi_csb
create_bd_port -dir O tx_spi_mosi
create_bd_port -dir I tx_spi_miso

ad_ip_instance axi_quad_spi tx_spi [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 4 \
  C_SCK_RATIO 2 \
]

ad_connect tx_spi/sck_o tx_spi_sclk
ad_connect tx_spi/ss_o tx_spi_csb
ad_connect tx_spi/io0_o tx_spi_mosi
ad_connect tx_spi/io1_i tx_spi_miso

ad_connect tx_spi/s_axi_aclk sys_cpu_clk
ad_connect tx_spi/ext_spi_clk clk_wizard/clk_out2
ad_connect tx_spi/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M13_AXI tx_spi/AXI_LITE

ad_connect sys_concat_intc/In10 tx_spi/ip2intc_irpt

# RX SPI

create_bd_port -dir O rx_spi_sclk
create_bd_port -dir O -from 3 -to 0 rx_spi_csb
create_bd_port -dir O rx_spi_mosi
create_bd_port -dir I rx_spi_miso

ad_ip_instance axi_quad_spi rx_spi [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 4 \
  C_SCK_RATIO 2 \
]

ad_connect rx_spi/sck_o rx_spi_sclk
ad_connect rx_spi/ss_o rx_spi_csb
ad_connect rx_spi/io0_o rx_spi_mosi
ad_connect rx_spi/io1_i rx_spi_miso

ad_connect rx_spi/s_axi_aclk sys_cpu_clk
ad_connect rx_spi/ext_spi_clk clk_wizard/clk_out2
ad_connect rx_spi/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M14_AXI rx_spi/AXI_LITE

ad_connect sys_concat_intc/In11 rx_spi/ip2intc_irpt

# UDC I2C

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 udc_iic

ad_ip_instance axi_iic axi_udc_iic

ad_connect axi_udc_iic/IIC udc_iic

ad_connect axi_udc_iic/s_axi_aclk sys_cpu_clk
ad_connect axi_udc_iic/s_axi_aresetn sys_cpu_resetn

ad_connect axi_smartconnect/M15_AXI axi_udc_iic/S_AXI

ad_connect sys_concat_intc/In12 axi_udc_iic/iic2intc_irpt

# Flash SPI

# create_bd_port -dir O flash_spi_sclk
# create_bd_port -dir O flash_spi_csb
# create_bd_port -dir O flash_spi_mosi
# create_bd_port -dir I flash_spi_miso

# ad_ip_instance axi_quad_spi flash_spi [list \
#   C_USE_STARTUP 0 \
#   C_NUM_SS_BITS 1 \
#   C_SCK_RATIO 2 \
# ]

# ad_connect flash_spi/sck_o flash_spi_sclk
# ad_connect flash_spi/ss_o flash_spi_csb
# ad_connect flash_spi/io0_o flash_spi_mosi
# ad_connect flash_spi/io1_i flash_spi_miso

# ad_connect flash_spi/s_axi_aclk sys_cpu_clk
# ad_connect flash_spi/ext_spi_clk clk_wizard/clk_out2
# ad_connect flash_spi/s_axi_aresetn sys_cpu_resetn

# ad_connect axi_smartconnect/M16_AXI flash_spi/AXI_LITE

# ad_connect sys_concat_intc/In13 flash_spi/ip2intc_irpt
